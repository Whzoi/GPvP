-- Hopouts Server Script
local Hopouts = {}

-- Store hopouts state per lobby
Hopouts.games = {}

-- Initialize hopouts for a lobby
local function InitializeHopouts(lobbyID)
    if not Hopouts.games[lobbyID] then
        Hopouts.games[lobbyID] = {
            enabled = false,
            team1 = {},
            team2 = {},
            readyPlayers = {},
            currentRound = 0,
            maxRounds = 5,
            roundActive = false,
            team1Wins = 0,
            team2Wins = 0
        }
    end
end

-- Get player's lobby ID from LOBBY system
local function GetPlayerLobbyID(source)
    -- Assuming _G.LOBBY is accessible and contains player data mapped by user_id
    if not _G.LOBBY or not _G.LOBBY.Players then return 1 end
    
    -- Iterate through LOBBY.Players to find the player's source (server ID)
    for user_id, playerData in pairs(_G.LOBBY.Players) do
        -- Check if the source matches and return the lobby ID
        if playerData.source == source then
            return playerData.user_lobby or 1
        end
    end
    return 1 -- Default fallback (Public/Main Lobby)
end

-- Broadcast team updates to all players in lobby
local function BroadcastTeamUpdate(lobbyID)
    local game = Hopouts.games[lobbyID]
    if not game then return end
    
    -- Get all players currently on the server
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerSource = tonumber(playerId)
        local playerLobby = GetPlayerLobbyID(playerSource)
        
        -- Only send the update to players in the specific lobby
        if playerLobby == lobbyID then
            TriggerClientEvent('hopouts:teamUpdate', playerSource, game.team1, game.team2)
            -- Also ensure the score is updated for the players joining a running game
            TriggerClientEvent('hopouts:updateScore', playerSource, game.team1Wins, game.team2Wins, game.currentRound)
        end
    end
end

-- Check if player is already in a team
local function IsPlayerInTeam(lobbyID, source)
    local game = Hopouts.games[lobbyID]
    if not game then return false, nil end
    
    for _, playerId in ipairs(game.team1) do
        if playerId == source then
            return true, 1
        end
    end
    
    for _, playerId in ipairs(game.team2) do
        if playerId == source then
            return true, 2
        end
    end
    
    return false, nil
end

-- Remove player from team
local function RemovePlayerFromTeam(lobbyID, source)
    local game = Hopouts.games[lobbyID]
    if not game then return end
    
    for i, playerId in ipairs(game.team1) do
        if playerId == source then
            table.remove(game.team1, i)
            return
        end
    end
    
    for i, playerId in ipairs(game.team2) do
        if playerId == source then
            table.remove(game.team2, i)
            return
        end
    end
end

-- Events
RegisterNetEvent('hopouts:enable')
AddEventHandler('hopouts:enable', function()
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    
    -- Only allow the game host/initiator (user who is currently in the lobby and ran the command) to enable/disable
    if lobbyID == 1 or not _G.LOBBY.user_is_host then 
        -- Optionally add a check if the user is authorized to enable/disable
    end
    
    InitializeHopouts(lobbyID)
    Hopouts.games[lobbyID].enabled = true
    Hopouts.games[lobbyID].team1 = {}
    Hopouts.games[lobbyID].team2 = {}
    Hopouts.games[lobbyID].readyPlayers = {}
    Hopouts.games[lobbyID].currentRound = 0
    Hopouts.games[lobbyID].team1Wins = 0
    Hopouts.games[lobbyID].team2Wins = 0
    Hopouts.games[lobbyID].roundActive = false
    
    BroadcastTeamUpdate(lobbyID)
end)

RegisterNetEvent('hopouts:disable')
AddEventHandler('hopouts:disable', function()
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    
    if Hopouts.games[lobbyID] then
        Hopouts.games[lobbyID].enabled = false
        Hopouts.games[lobbyID].team1 = {}
        Hopouts.games[lobbyID].team2 = {}
        Hopouts.games[lobbyID].readyPlayers = {}
        Hopouts.games[lobbyID].roundActive = false
        BroadcastTeamUpdate(lobbyID)
    end
end)

RegisterNetEvent('hopouts:joinTeam')
AddEventHandler('hopouts:joinTeam', function(teamNumber)
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    
    InitializeHopouts(lobbyID)
    local game = Hopouts.games[lobbyID]
    
    if not game.enabled then
        TriggerClientEvent('hopouts:joinedTeam', source, teamNumber, nil, false, 'Hopouts is not enabled!')
        return
    end
    
    -- Check if player is already in a team
    local inTeam, currentTeam = IsPlayerInTeam(lobbyID, source)
    if inTeam then
        -- Remove from current team if switching teams
        if currentTeam ~= teamNumber then
            RemovePlayerFromTeam(lobbyID, source)
        else
            -- Already on this team, no action needed, but confirm join to client
            local index = 0
            for i, playerId in ipairs(teamNumber == 1 and game.team1 or game.team2) do
                if playerId == source then index = i break end
            end
            TriggerClientEvent('hopouts:joinedTeam', source, teamNumber, index, true, 'You are already on Team ' .. teamNumber)
            return
        end
    end
    
    local targetTeam = teamNumber == 1 and game.team1 or game.team2
    
    if #targetTeam >= 5 then
        TriggerClientEvent('hopouts:joinedTeam', source, teamNumber, nil, false, 'This team is full!')
        return
    end
    
    -- Add player to team
    table.insert(targetTeam, source)
    local index = #targetTeam
    
    BroadcastTeamUpdate(lobbyID)
    TriggerClientEvent('hopouts:joinedTeam', source, teamNumber, index, true, 'Joined Team ' .. teamNumber)
end)

RegisterNetEvent('hopouts:leave')
AddEventHandler('hopouts:leave', function()
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    local game = Hopouts.games[lobbyID]
    if not game or not game.enabled then return end

    RemovePlayerFromTeam(lobbyID, source)

    for i, playerId in ipairs(game.readyPlayers) do
        if playerId == source then
            table.remove(game.readyPlayers, i)
            break
        end
    end

    BroadcastTeamUpdate(lobbyID)
end)

RegisterNetEvent('hopouts:ready')
AddEventHandler('hopouts:ready', function()
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    local game = Hopouts.games[lobbyID]
    if not game or not game.enabled then return end

    local inTeam, _ = IsPlayerInTeam(lobbyID, source)
    if not inTeam then
        TriggerClientEvent('chat:addMessage', source, { color = {255, 0, 0}, args = {'Hopouts', 'You must be in a team to ready up.'} })
        return
    end

    for _, readyPlayerId in ipairs(game.readyPlayers) do
        if readyPlayerId == source then
            TriggerClientEvent('chat:addMessage', source, { color = {255, 255, 0}, args = {'Hopouts', 'You are already ready.'} })
            return
        end
    end

    table.insert(game.readyPlayers, source)
    TriggerClientEvent('chat:addMessage', source, { color = {0, 255, 0}, args = {'Hopouts', 'You are now ready.'} })

    -- Check if all players are ready
    local allReady = true
    local allPlayers = {}
    for _, p in ipairs(game.team1) do table.insert(allPlayers, p) end
    for _, p in ipairs(game.team2) do table.insert(allPlayers, p) end

    if #allPlayers < 2 then -- Minimum 1v1
        return
    end

    for _, playerId in ipairs(allPlayers) do
        local found = false
        for _, readyId in ipairs(game.readyPlayers) do
            if playerId == readyId then
                found = true
                break
            end
        end
        if not found then
            allReady = false
            break
        end
    end

    if allReady then
        game.readyPlayers = {} -- Reset for next round
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local playerSource = tonumber(playerId)
            if GetPlayerLobbyID(playerSource) == lobbyID then
                TriggerClientEvent('hopouts:startRound', playerSource, 1)
            end
        end
    end
end)

RegisterNetEvent('hopouts:triggerstart')
AddEventHandler('hopouts:triggerstart', function()
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    local game = Hopouts.games[lobbyID]
    if not game or not game.enabled then return end

    game.readyPlayers = {} -- Reset for next round
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerSource = tonumber(playerId)
        if GetPlayerLobbyID(playerSource) == lobbyID then
            TriggerClientEvent('hopouts:startRound', playerSource, 1)
        end
    end
end)

RegisterNetEvent('hopouts:spectate')
AddEventHandler('hopouts:spectate', function(targetServerId)
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    local game = Hopouts.games[lobbyID]
    if not game or not game.enabled then return end

    local sourceInTeam, sourceTeam = IsPlayerInTeam(lobbyID, source)
    local targetInTeam, targetTeam = IsPlayerInTeam(lobbyID, targetServerId)

    if sourceInTeam and targetInTeam and sourceTeam == targetTeam then
        TriggerClientEvent('hopouts:startSpectating', source, targetServerId)
    end
end)

RegisterNetEvent('hopouts:roundEnd')
AddEventHandler('hopouts:roundEnd', function(winningTeam)
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    
    local game = Hopouts.games[lobbyID]
    if not game or not game.enabled or not game.roundActive then return end
    
    -- Update wins
    if winningTeam == 1 then
        game.team1Wins = game.team1Wins + 1
    else
        game.team2Wins = game.team2Wins + 1
    end
    
    game.currentRound = game.currentRound + 1
    game.roundActive = false
    
    -- Broadcast round end
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerSource = tonumber(playerId)
        local playerLobby = GetPlayerLobbyID(playerSource)
        if playerLobby == lobbyID then
            TriggerClientEvent('hopouts:roundEnd', playerSource, winningTeam, game.team1Wins, game.team2Wins, game.currentRound)
        end
    end
end)

RegisterNetEvent('hopouts:startNextRound')
AddEventHandler('hopouts:startNextRound', function()
    local source = source
    local lobbyID = GetPlayerLobbyID(source)
    
    local game = Hopouts.games[lobbyID]
    if not game or not game.enabled then return end
    
    -- Check if game is over
    if game.currentRound >= game.maxRounds then
        -- Game over, reset internal state
        game.currentRound = 0
        game.team1Wins = 0
        game.team2Wins = 0
        
        BroadcastTeamUpdate(lobbyID)
        return
    end
    
    -- Start next round
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerSource = tonumber(playerId)
        local playerLobby = GetPlayerLobbyID(playerSource)
        if playerLobby == lobbyID then
            TriggerClientEvent('hopouts:startRound', playerSource, game.currentRound + 1)
        end
    end
end)

-- Clean up when player leaves
AddEventHandler('playerDropped', function()
    local source = source
    -- Remove player from all hopouts games
    for lobbyID, game in pairs(Hopouts.games) do
        RemovePlayerFromTeam(lobbyID, source)
        BroadcastTeamUpdate(lobbyID)
        
        -- Optional: Check for end-of-round/game condition if the player leaving causes one team to be empty
    end
end)