local function ExtractIdentifiers(src)
    local identifiers = {
        steam = ""
    }
    for _, id in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            identifiers.steam = id
            break
        end
    end
    return identifiers
end

local function steamHexTo64(hex)
    if not hex or hex == "" then return nil end
    local stripped = hex:gsub("^steam:", "")
    local decimal = tonumber(stripped, 16)
    if not decimal then return nil end
    -- SteamID64 base: 0x0110000100000000
    local base = 72119331747806720
    return tostring(base + decimal)
end

local function defaultSteamAvatar(hex)
    -- Use one of the embed placeholders based on last digit so users differ slightly.
    local lastDigit = tonumber(hex:sub(-1)) or 0
    local idx = (lastDigit % 5)
    return string.format("https://cdn.discordapp.com/embed/avatars/%d.png", idx)
end

local function sendProfileToClient(src, steam_id, kills, deaths)
    local steam64 = steamHexTo64(steam_id)
    local payload = {
        user_id = src,
        steamName = GetPlayerName(src),
        steamAvatar = nil,
        stats = {
            name = GetPlayerName(src),
            kills = kills or 0,
            deaths = deaths or 0,
            kd = (deaths and deaths > 0) and (kills / deaths) or (kills or 0)
        }
    }

    if steam64 then
        payload.steamAvatar = string.format("https://avatars.steamstatic.com/%s_full.jpg", steam64)
    end

    if not payload.steamAvatar then
        payload.steamAvatar = defaultSteamAvatar(steam_id ~= "" and steam_id or "0")
    end

    TriggerClientEvent('radar:receivePlayerProfile', src, payload)
end

-- local function updateStats(steam_id, statType, amount)
--     local statColumn = statType
--     -- Upsert ensures a stats row exists for this steam_id, then increments the column.
--     local query = 'INSERT INTO stats (steam_id, ' .. statColumn .. ') VALUES (?, ?) ON DUPLICATE KEY UPDATE ' .. statColumn .. ' = ' .. statColumn .. ' + VALUES(' .. statColumn .. ')'
--     exports.oxmysql:execute(query, {steam_id, amount})
-- end



local function getTxAdminApiConfig()
    local url = GetConvar("txadmin_api_url", "")
    local token = GetConvar("txadmin_api_token", "")
    if url == "" or token == "" then return nil end
    return { url = url, token = token }
end

local function fetchTxAdminPlayerData(steam_id, callback)
    -- txAdmin lives outside the game as a web service. Provide its base URL and a token via convars:
    -- set txadmin_api_url "http://127.0.0.1:40120/api" and set txadmin_api_token "your_api_token_here"
    local cfg = getTxAdminApiConfig()
    if not cfg then return callback(nil) end

    local steamHex = steam_id:gsub("^steam:", "")
    local endpoint = string.format("%s/player/%s", cfg.url, steamHex)

    PerformHttpRequest(endpoint, function(statusCode, body, headers)
        if statusCode ~= 200 or not body then return callback(nil) end
        local ok, data = pcall(json.decode, body)
        if not ok or type(data) ~= "table" then return callback(nil) end
        callback(data)
    end, "GET", "", { ["Authorization"] = "Bearer " .. cfg.token })
end

local function readTxAdminPlayersDb()
    local path = GetConvar("txadmin_players_db_path", "")
    if path == nil or path == "" then return nil end

    local file = io.open(path, "r")
    if not file then return nil end

    local content = file:read("*a")
    file:close()

    if not content or content == "" then return nil end

    local ok, data = pcall(json.decode, content)
    if not ok or type(data) ~= "table" then return nil end

    return data
end

local function getPlaytimeFromPlayersDb(steam_id)
    local db = readTxAdminPlayersDb()
    if not db or not db.players then return nil end

    local steamHex = steam_id:gsub("^steam:", "")
    for _, player in pairs(db.players) do
        local play = player.playTime or player.playtime

        -- Match against ids array or explicit steam fields
        local hasMatch = false
        if player.ids and type(player.ids) == "table" then
            for _, id in ipairs(player.ids) do
                if id == steam_id or id == ("steam:" .. steamHex) or id == steamHex then
                    hasMatch = true
                    break
                end
            end
        end

        if not hasMatch and player.steam then
            local stored = tostring(player.steam):gsub("^steam:", "")
            if stored == steamHex then hasMatch = true end
        end

        if hasMatch and play then
            return tonumber(play)
        end
    end

    return nil
end

local function getTxAdminPlaytimeMinutes(src)
    -- Best-effort: only returns a number if txAdmin exposes playtime; otherwise nil.
    if GetResourceState('txAdmin') ~= 'started' then return nil end

    local ok, result = pcall(function()
        if exports.txAdmin and exports.txAdmin.getPlayTime then
            return exports.txAdmin:getPlayTime(src)
        elseif exports.txAdmin and exports.txAdmin.getPlayerInfo then
            local info = exports.txAdmin:getPlayerInfo(src)
            return info and info.playTime or nil
        end
        return nil
    end)

    if ok and type(result) == "number" then
        return result
    elseif ok and type(result) == "table" and result.playTime then
        return tonumber(result.playTime)
    end

    return nil
end

local function formatMinutesToClock(minutes)
    if not minutes then return "Unavailable" end
    local mins = math.floor(minutes)
    local hours = math.floor(mins / 60)
    local rem = mins % 60
    return string.format("%dh %02dm", hours, rem)
end

RegisterCommand('stats', function(source, args, raw)
    if source == 0 then
        print("Use /stats in-game.")
        return
    end

    local identifiers = ExtractIdentifiers(source)
    if identifiers.steam == "" then
        exports['notifications']:SendAlert('inform', 'Steam identifier not found; cannot show stats.', 2000)
        return
    end

    fetchTotals(identifiers.steam, function(kills, deaths)
        local kd = deaths > 0 and (kills / deaths) or kills
        local playtimeMinutes = getTxAdminPlaytimeMinutes(source)

        -- If txAdmin HTTP API is configured, prefer it (more accurate across sessions).
        fetchTxAdminPlayerData(identifiers.steam, function(apiData)
            if apiData and apiData.playTime then
                playtimeMinutes = tonumber(apiData.playTime) or playtimeMinutes
            end

            if not playtimeMinutes then
                local seconds = getPlaytimeFromPlayersDb(identifiers.steam)
                if seconds then playtimeMinutes = seconds / 60 end
            end

            local playtimeLabel = formatMinutesToClock(playtimeMinutes)
            local statsText = string.format("Kills: %d | Deaths: %d | K/D: %.2f", kills, deaths, kd, playtimeLabel)

            -- Show a short success notification with stats
            TriggerClientEvent('notifications:client:SendAlert', source, {
                type = 'inform',
                text = statsText,
                length = 4000
            })

            sendProfileToClient(source, identifiers.steam, kills, deaths)
        end)
    end)
end, false)

-- RegisterNetEvent('radar:requestPlayerProfile')
-- AddEventHandler('radar:requestPlayerProfile', function()
--     local src = source
--     local identifiers = ExtractIdentifiers(src)
--     if identifiers.steam == "" then return end

--     -- fetchTotals(identifiers.steam, function(kills, deaths)
--         -- sendProfileToClient(src, identifiers.steam, kills, deaths)
--     end)
-- end)

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local victimId = source

    -- Check if killerId is valid and not equal to victimId
    if killerId and killerId ~= victimId then
        local killerName = GetPlayerName(killerId)
        local victimName = GetPlayerName(victimId)

        print("Killer: " .. tostring(killerName))
        print("Victim: " .. tostring(victimName))

        -- local killerIdentifiers = ExtractIdentifiers(killerId)
        -- local victimIdentifiers = ExtractIdentifiers(victimId)

        -- if killerIdentifiers.steam ~= "" then
        --     -- updateStats(killerIdentifiers.steam, "kills", 1)
        --     fetchKD(killerIdentifiers.steam, function(kd)
        --         if kd then
        --             TriggerClientEvent('erotic:UpdateKD', killerId, kd)
        --         end
        --     end)
        -- end

        -- if victimIdentifiers.steam ~= "" then
        --     updateStats(victimIdentifiers.steam, "deaths", 1)
        --     fetchKD(victimIdentifiers.steam, function(kd)
        --         if kd then
        --             TriggerClientEvent('erotic:UpdateKD', victimId, kd)
        --         end
        --     end)
        -- end

        -- Trigger the event only on the client of the killer
        TriggerClientEvent('erotic:KilledPlayer', killerId, victimId, victimName)
    end
end)
