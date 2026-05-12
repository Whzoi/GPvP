-- local webhooklog = "https://discord.com/api/webhooks/1437133335880143040/n6QpfjcMXEYbg0UDTz9Lwx6lAhKjICXnF5oC_b32V-UhRePXbV4q8LTwhYc7q3hO8DnQ"

-- local datawebhook = "https://discord.com/api/webhooks/1437133335880143040/n6QpfjcMXEYbg0UDTz9Lwx6lAhKjICXnF5oC_b32V-UhRePXbV4q8LTwhYc7q3hO8DnQv"

-- local function createDatabase()
--     local sql = [[
--     CREATE TABLE IF NOT EXISTS players (
--         id INT AUTO_INCREMENT PRIMARY KEY,
--         steam_id VARCHAR(50),
--         cfx_id VARCHAR(50) NOT NULL,
--         name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
--         ip_hash VARCHAR(64),
--         discord VARCHAR(50),
--         license VARCHAR(50),
--         xbl VARCHAR(50),
--         live VARCHAR(50),
--         banned BOOLEAN DEFAULT FALSE,
--         UNIQUE(steam_id),
--         UNIQUE(cfx_id)
--     ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--     ]]

--     local stats_sql = [[
--         CREATE TABLE IF NOT EXISTS stats (
--             id INT AUTO_INCREMENT PRIMARY KEY,
--             steam_id VARCHAR(50) NOT NULL,
--             kills INT DEFAULT 0,
--             deaths INT DEFAULT 0,
--             assists INT DEFAULT 0,
--             playtime INT DEFAULT 0,
--             ranked_wins INT DEFAULT 0,
--             ranked_losses INT DEFAULT 0,
--             ranked_kills INT DEFAULT 0,
--             ranked_deaths INT DEFAULT 0,
--             ranked_assists INT DEFAULT 0,
--             ranked_mmr INT DEFAULT 0,
--             ranked_rank VARCHAR(50) DEFAULT 'Unranked',
--             level INT DEFAULT 1,
--             current_xp INT DEFAULT 0,
--             UNIQUE(steam_id)
--         ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--     ]]    

--     exports.oxmysql:execute(sql, {}, function()
--         print("Database and table 'players' have been created or already exist.")
--     end)

--     exports.oxmysql:execute(stats_sql, {}, function()
--         print("Database and table 'stats' have been created or already exist.")
--     end)
-- end

-- createDatabase()

-- local function ExtractIdentifiers(src)
--     local identifiers = {
--         steam = "",
--         ip = "",
--         discord = "",
--         license = "",
--         xbl = "",
--         live = "",
--         cfx = ""
--     }
--     for _, id in pairs(GetPlayerIdentifiers(src)) do
--         if string.sub(id, 1, string.len("steam:")) == "steam:" then
--             identifiers.steam = id
--         elseif string.sub(id, 1, string.len("license:")) == "license:" then
--             identifiers.license = id
--         elseif string.sub(id, 1, string.len("xbl:")) == "xbl:" then
--             identifiers.xbl = id
--         elseif string.sub(id, 1, string.len("ip:")) == "ip:" then
--             identifiers.ip = id
--         elseif string.sub(id, 1, string.len("discord:")) == "discord:" then
--             identifiers.discord = id
--         elseif string.sub(id, 1, string.len("live:")) == "live:" then
--             identifiers.live = id
--         elseif string.sub(id, 1, string.len("fivem:")) == "fivem:" then
--             identifiers.cfx = id
--         end
--     end
--     return identifiers
-- end

local function simpleHash(str)
    local hash = 0
    if #str == 0 then return hash end
    for i = 1, #str do
        local char = string.byte(str, i)
        hash = ((hash << 5) - hash) + char
        hash = hash & hash -- Convert to 32bit integer
    end
    return string.format("%08x", hash)
end

-- local function checkBanEvade(playerIdentifiers, callback)
--     local ipHash = simpleHash(playerIdentifiers.ip)

--     local query = [[
--         SELECT * FROM players 
--         WHERE ip_hash = ? 
--         OR steam_id = ? 
--         OR discord = ? 
--         OR license = ? 
--         OR xbl = ? 
--         OR live = ? 
--         OR cfx_id = ?
--     ]]
--     local params = {
--         ipHash,
--         playerIdentifiers.steam,
--         playerIdentifiers.discord,
--         playerIdentifiers.license,
--         playerIdentifiers.xbl,
--         playerIdentifiers.live,
--         playerIdentifiers.cfx
--     }

--     exports.oxmysql:fetch(query, params, function(result)
--         if #result > 0 then
--             for _, player in ipairs(result) do
--                 if player.banned then
--                     callback(true)
--                     return
--                 end
--             end
--         end
--         callback(false)
--     end)
-- end

local TX_ADMINS = {}
AddEventHandler("txAdmin:events:adminAuth", function(data)
    if data.netid ~= -1 then
        TX_ADMINS[tostring(data.netid)] = data.isAdmin
    end
end)

-- local function disp_time(time)
--     local days = math.floor(time/86400)
--     local hours = math.floor(math.fmod(time, 86400)/3600)
--     local minutes = math.floor(math.fmod(time,3600)/60)
--     local seconds = math.floor(math.fmod(time,60))
--     return string.format("%d days %02d hours %02d minutes %02d seconds",days,hours,minutes,seconds)
-- end

-- local function initializePlayerStats(steam_id)
--     local stats_query = [[
--         INSERT INTO stats (steam_id, kills, deaths, assists, playtime, ranked_wins, ranked_losses, ranked_kills, ranked_deaths, ranked_assists, ranked_mmr, ranked_rank, level, current_xp) 
--         VALUES (?, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Unranked', 1, 0)
--         ON DUPLICATE KEY UPDATE steam_id = VALUES(steam_id);
--     ]]
--     exports.oxmysql:execute(stats_query, {steam_id}, function()
--         local message = ('Initialized stats for player with steam_id: %s'):format(steam_id)
--         print(message)
--         exports['admin']:sendToDiscord(webhooklog, 'Player Stats Initialized', message, 3447003, 'Server Logger')
--     end)
-- end

-- local function fetchUserPlaytime(src, callback)
--     local identifiers = ExtractIdentifiers(src)
--     local fivem = identifiers.cfx

--     if fivem ~= "" then
--         local api = "https://lambda.fivem.net/api/ticket/playtimes/7dvoad?identifiers[]=" .. fivem
        
--         PerformHttpRequest(api, function (errorCode, resultData)
--             if errorCode == 200 then
--                 local playtimeData = json.decode(resultData)
--                 if playtimeData and playtimeData[1] and playtimeData[1].seconds then
--                     local playtime = playtimeData[1].seconds
--                     callback(playtime)
--                 else
--                     callback(nil, "Failed to parse playtime data.")
--                 end
--             else
--                 callback(nil, "Failed to fetch playtime data.")
--             end
--         end)
--     else
--         callback(nil, "FiveM identifier not connected.")
--     end
-- end

-- local function getIdentifier(src, identifierKey)
--     local identifiers = ExtractIdentifiers(src)
--     if identifierKey == "fivem" then
--         return identifiers.cfx or ""
--     end
--     return identifiers[identifierKey] or ""
-- end

-- RegisterNetEvent('Erotic:LoadUser')
-- AddEventHandler('Erotic:LoadUser', function()
--     local src = source
--     local identifiers = ExtractIdentifiers(src)
--     local name = GetPlayerName(src)
--     local ipHash = simpleHash(identifiers.ip)

--     if identifiers.steam == "" then
--         print(('Player %d does not have a steam identifier. Cannot proceed with database operations.'):format(src))
--         return
--     end

--     checkBanEvade(identifiers, function(isBanned)
--         if isBanned then
--             return
--         end

--         exports.oxmysql:fetch('SELECT * FROM players WHERE steam_id = ?', {identifiers.steam}, function(result)
--             local query
--             local params

--             if #result == 0 then
--                 query = 'INSERT INTO players (name, steam_id, cfx_id, ip_hash, discord, license, xbl, live, banned) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), steam_id = VALUES(steam_id), ip_hash = VALUES(ip_hash), discord = VALUES(discord), license = VALUES(license), xbl = VALUES(xbl), live = VALUES(live)'
--                 params = { name, identifiers.steam, identifiers.cfx, ipHash, identifiers.discord, identifiers.license, identifiers.xbl, identifiers.live, false }
--             else
--                 query = 'UPDATE players SET name = ?, steam_id = ?, ip_hash = ?, discord = ?, license = ?, xbl = ?, live = ? WHERE cfx_id = ?'
--                 params = { name, identifiers.steam, ipHash, identifiers.discord, identifiers.license, identifiers.xbl, identifiers.live, identifiers.cfx }
--             end

--             exports.oxmysql:execute(query, params, function()
--                 local message = ('Player %d identifiers:\nName: %s\nSteam: %s\nCFX: %s\nLicense: %s\nIP: %s\nDiscord: %s\nXBL: %s\nLive: %s'):format(src, name, identifiers.steam, identifiers.cfx, identifiers.license, identifiers.ip, identifiers.discord, identifiers.xbl, identifiers.live)
--                 exports['admin']:sendToDiscord(datawebhook, 'Player ' .. (#result == 0 and 'Added' or 'Updated'), message, 3447003, 'Server Logger')
--                 print(message)
--                 initializePlayerStats(identifiers.steam)

--                 fetchUserPlaytime(src, function(playtime, err)
--                     if playtime then
--                         exports.oxmysql:execute('UPDATE stats SET playtime = ? WHERE steam_id = ?', { playtime, identifiers.steam }, function()
--                             print(('Player %d playtime updated to %d seconds.'):format(src, playtime))
--                         end)
--                     else
--                         print(('Player %d playtime update failed: %s'):format(src, err))
--                     end
--                 end)
--             end)
--         end)
--     end)
-- end)

-- AddEventHandler('playerDropped', function(reason)
--     local playerId = source
--     print(('Player %d dropped (Reason: %s)'):format(playerId, reason))

--     -- Trigger the client event to unload user data
--     TriggerEvent('Erotic:UnloadUser', playerId)
-- end)

-- AddEventHandler('Erotic:UnloadUser', function(playerId)
--     local identifiers = ExtractIdentifiers(playerId)
--     print(('Unloading user data for player ID: %d'):format(playerId))

--     -- Add any additional unloading logic here

--     -- Trigger the client event to unload user data
--     TriggerClientEvent('Erotic:UnloadUser', playerId)
-- end)

-- local function updateStats(steam_id, statType, amount)
--     local statColumn = statType

--     exports.oxmysql:fetch('SELECT * FROM stats WHERE steam_id = ?', {steam_id}, function(result)
--         if #result > 0 then
--             local currentStat = result[1][statColumn] or 0
--             local newStat = currentStat + amount

--             exports.oxmysql:execute('UPDATE stats SET ' .. statColumn .. ' = ? WHERE steam_id = ?', {newStat, steam_id})
--         else
--             print('Player stats not found for steam_id: ' .. steam_id)
--         end
--     end)
-- end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(180000)
        TriggerClientEvent('drp:scripts:vehwipe', -1)
    end
end)

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local victimId = source

    if killerId and killerId ~= victimId then
        local victimName = GetPlayerName(victimId)
        local killerName = GetPlayerName(killerId)
        -- local killerIdentifiers = ExtractIdentifiers(killerId)
        -- local victimIdentifiers = ExtractIdentifiers(victimId)

        updateStats(killerIdentifiers.steam, "kills", 1)
        updateStats(victimIdentifiers.steam, "deaths", 1)

        local killMessage = ('Player %s (%s) got a kill on %s (%s) with %s.'):format(killerName, killerId, victimName, victimId, deathData.killerWeapon)
        print(killMessage)
        exports['admin']:sendToDiscord(webhooklog, 'Kill Update', killMessage, 0x00FFFF, 'Server Logger')

        local deathMessage = ('Player %s (%s) was killed by %s (%s) with %s.'):format(victimName, victimId, killerName, killerId, deathData.killerWeapon)
        print(deathMessage)
        exports['admin']:sendToDiscord(webhooklog, 'Death Update', deathMessage, 0xFF0000, 'Server Logger')

        TriggerClientEvent('erotic:KilledPlayer', killerId, victimId, victimName)
    end
end)

-- AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
-- 	-- mark this connection as deferred, this is to prevent problems while checking player identifiers.
-- 	deferrals.defer()

-- 	-- save source
-- 	local s = source

-- 	-- letting the user know what's going on.
-- 	deferrals.update("Checking for steam identifier...")

-- 	-- Needed, not sure why.
-- 	Citizen.Wait(100)

-- 	-- check for steam identifier
-- 	local allowed = false
-- 	local steamNumber
-- 	for number,id in ipairs(GetPlayerIdentifiers(s)) do
-- 		if string.find(id, "steam:") then
-- 			allowed = true -- if the identifier is a steam identifier, allow the player.
-- 			steamNumber = number -- verify the array order
-- 			break
-- 		end
-- 	end

-- 	if allowed and steamNumber == 1 then
-- 		local identifiers = ExtractIdentifiers(s)
-- 		deferrals.update("Checking for bans...")

-- 		checkBanEvade(identifiers, function(isBanned)
-- 			if isBanned then
-- 				deferrals.done("You are currently banned from this server.")
-- 				return
-- 			end

-- 			deferrals.done()
-- 		end)
-- 	elseif steamNumber ~= 1 then
-- 		deferrals.done("Could not verify your Steam session! For security reasons you cannot be let in to the server, make sure Steam is running and try again. If the problem persists then you will have to contact the staff of this server.")
--     else
-- 		deferrals.done("Could not verify your Steam session! For security reasons you cannot be let in to the server, make sure Steam is running and try again. If the problem persists then you will have to contact the staff of this server.")
-- 	end
-- end)


