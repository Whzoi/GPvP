local leaderboard = {}

local function ensureEntry(playerId)
    if not playerId then return nil end
    leaderboard[playerId] = leaderboard[playerId] or {
        kills = 0,
        deaths = 0,
        damage = 0,
        name = GetPlayerName(playerId) or ("Player " .. playerId)
    }
    return leaderboard[playerId]
end

local function sanitizeEntries()
    for playerId, data in pairs(leaderboard) do
        data.name = GetPlayerName(playerId) or data.name or ("Player " .. playerId)
        data.kills = math.max(0, tonumber(data.kills) or 0)
        data.deaths = math.max(0, tonumber(data.deaths) or 0)
        data.damage = math.max(0, tonumber(data.damage) or 0)
    end
end

local function buildTopLeaderboard()
    sanitizeEntries()
    local rows = {}
    for playerId, data in pairs(leaderboard) do
        if GetPlayerName(playerId) then
            table.insert(rows, {
                id = playerId,
                name = data.name or ("Player " .. playerId),
                kills = data.kills or 0,
                deaths = data.deaths or 0,
                damage = data.damage or 0
            })
        end
    end

    table.sort(rows, function(a, b)
        if a.kills == b.kills then
            if a.damage == b.damage then
                return (a.name or "") < (b.name or "")
            end
            return (a.damage or 0) > (b.damage or 0)
        end
        return (a.kills or 0) > (b.kills or 0)
    end)

    local top = {}
    for i = 1, math.min(3, #rows) do
        top[i] = rows[i]
    end
    return top
end

local function broadcastLeaderboard()
    local top = buildTopLeaderboard()
    TriggerClientEvent("gpvp-hud:updateLeaderboard", -1, top)
end

RegisterNetEvent("gpvp-hud:registerKill", function(payload)
    local src = source
    if type(payload) ~= "table" then return end

    local killerEntry = ensureEntry(src)
    if not killerEntry then return end

    killerEntry.kills = (killerEntry.kills or 0) + 1
    killerEntry.damage = (killerEntry.damage or 0) + math.max(0, tonumber(payload.damage) or 0)
    killerEntry.name = GetPlayerName(src) or killerEntry.name

    local victimId = tonumber(payload.victim)
    if victimId and victimId ~= 0 and victimId ~= src and GetPlayerName(victimId) then
        local victimEntry = ensureEntry(victimId)
        if victimEntry then
            victimEntry.deaths = (victimEntry.deaths or 0) + 1
            victimEntry.name = GetPlayerName(victimId) or victimEntry.name
        end
    end

    broadcastLeaderboard()
end)

RegisterNetEvent("gpvp-hud:requestLeaderboard", function()
    local src = source
    TriggerClientEvent("gpvp-hud:updateLeaderboard", src, buildTopLeaderboard())
end)

AddEventHandler("playerDropped", function()
    local src = source
    leaderboard[src] = nil
    broadcastLeaderboard()
end)

AddEventHandler("playerJoining", function()
    local src = source
    leaderboard[src] = nil
end)

local function ensureEntry(playerId)
    if not playerId then return nil end
    leaderboard[playerId] = leaderboard[playerId] or {
        kills = 0,
        deaths = 0,
        damage = 0,
        name = GetPlayerName(playerId) or ("Player " .. playerId)
    }
    return leaderboard[playerId]
end

local function sanitizeEntries()
    for playerId, data in pairs(leaderboard) do
        data.name = GetPlayerName(playerId) or data.name or ("Player " .. playerId)
        data.kills = math.max(0, tonumber(data.kills) or 0)
        data.deaths = math.max(0, tonumber(data.deaths) or 0)
        data.damage = math.max(0, tonumber(data.damage) or 0)
    end
end

local function buildTopLeaderboard()
    sanitizeEntries()
    local rows = {}
    for playerId, data in pairs(leaderboard) do
        if GetPlayerName(playerId) then
            table.insert(rows, {
                id = playerId,
                name = data.name or ("Player " .. playerId),
                kills = data.kills or 0,
                deaths = data.deaths or 0,
                damage = data.damage or 0
            })
        end
    end

    table.sort(rows, function(a, b)
        if a.kills == b.kills then
            if a.damage == b.damage then
                return (a.name or "") < (b.name or "")
            end
            return (a.damage or 0) > (b.damage or 0)
        end
        return (a.kills or 0) > (b.kills or 0)
    end)

    local top = {}
    for i = 1, math.min(3, #rows) do
        top[i] = rows[i]
    end
    return top
end

local function broadcastLeaderboard()
    local top = buildTopLeaderboard()
    TriggerClientEvent("gpvp-hud:updateLeaderboard", -1, top)
end

RegisterNetEvent("gpvp-hud:registerKill", function(payload)
    local src = source
    if type(payload) ~= "table" then return end

    local killerEntry = ensureEntry(src)
    if not killerEntry then return end

    killerEntry.kills = (killerEntry.kills or 0) + 1
    killerEntry.damage = (killerEntry.damage or 0) + math.max(0, tonumber(payload.damage) or 0)
    killerEntry.name = GetPlayerName(src) or killerEntry.name

    local victimId = tonumber(payload.victim)
    if victimId and victimId ~= 0 and victimId ~= src and GetPlayerName(victimId) then
        local victimEntry = ensureEntry(victimId)
        if victimEntry then
            victimEntry.deaths = (victimEntry.deaths or 0) + 1
            victimEntry.name = GetPlayerName(victimId) or victimEntry.name
        end
    end

    broadcastLeaderboard()
end)

RegisterNetEvent("gpvp-hud:requestLeaderboard", function()
    local src = source
    TriggerClientEvent("gpvp-hud:updateLeaderboard", src, buildTopLeaderboard())
end)

AddEventHandler("playerDropped", function()
    local src = source
    leaderboard[src] = nil
    broadcastLeaderboard()
end)

AddEventHandler("playerJoining", function()
    local src = source
    leaderboard[src] = nil
end)