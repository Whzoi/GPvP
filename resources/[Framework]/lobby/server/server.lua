local LOBBY = {
    lobbies = {
        {
            ID = 1,
            owner = nil,
            gamemode = "custom",
            playerCount = 0,
            lobbyinfo = {
                name = "Southside #1",
                tags = "",
                map = "southside",
                maxPlayers = 999,
                passwordProtected = false,
                password = nil,
                banned = ""
            },
            settings = {
                recoilMode = "gpvp",
                firstPersonVehicle = true,
                hsMulti = true,
                disableFP = true,
                -- vdm = false,
                disableLadders = true,
                disableQPeeking = false,
                disableHighRoofs = true,
                skeletons = false,
                noRagdoll = false,
                barrelStuffing = false,
                noAutoReload = false,
                onlyInSafezone = true,
            }
        },
        {
            ID = 2,
            owner = nil,
            gamemode = "custom",
            playerCount = 0,
            lobbyinfo = {
                name = "Pistol Only",
                tags = "",
                map = "southside",
                maxPlayers = 20,
                passwordProtected = false,
                password = nil,
                banned = ""
            },
            settings = {
                recoilMode = "gpvp",
                firstPersonVehicle = true,
                hsMulti = true,
                disableFP = true,
                -- vdm = false,
                disableLadders = true,
                disableQPeeking = false,
                disableHighRoofs = true,
                skeletons = false,
                noRagdoll = false,
                barrelStuffing = false,
                noAutoReload = false,
                onlyInSafezone = true,
            }
        }
    },
    Players = {}
}

local Maps = {
    ["southside"] = {
        spawn = vector4(218.3482, -1391.1870, 29.59 , 318.6517),
    },

    ["morningwood"] = {
        spawn = vector4(-1155.5471, -214.4832, 38.5301, 329.6809),
    },

    ["vinewood"] = {
        spawn = vector4(71.4304, 126.0425, 79.2103, 164.6355),
    },
    ["sandy"] = {
        spawn = vector4(1981.0631, 3704.3433, 32.4423, 73.2651),
    },
    ["littleseoul"] = {
        spawn = vector4(-888.2589, -853.1732, 20.5661, 284.5149),
    },
    ["mirrorpark"] = {
        spawn = vector4(1040.9985, -775.2896, 58.0229, 0.7598),
    },
}

function LOBBY:GenerateUniqueLobbyID()
    local maxID = 0
    for _, lobby in ipairs(self.lobbies) do
        if lobby.ID > maxID then
            maxID = lobby.ID
        end
    end
    return maxID + 1
end

function LOBBY:DeleteLobbyByID(lobbyID)
    for i, lobby in ipairs(self.lobbies) do
        if lobby.ID == lobbyID then
            table.remove(self.lobbies, i)
            print("Deleted lobby with ID: " .. lobbyID)
            break
        end
    end
end

function LOBBY:FindLobbyByID(lobbyID)
    for _, lobby in ipairs(self.lobbies) do
        if lobby.ID == lobbyID then
            return lobby
        end
    end
    return nil
end

function LOBBY:InitializePlayerDataIfNotExists(user_id, playerName)
    if not self.Players[user_id] then
        self.Players[user_id] = {
            user_id = user_id,
            source = source,
            stats = { name = playerName, kills = 0, damage = 0 }
        }
    end
end

function LOBBY:UpdatePlayerStats(playerData, user_stats)
    if user_stats.kills then playerData.stats.kills = user_stats.kills end
    if user_stats.damage then playerData.stats.damage = user_stats.damage end
end

function LOBBY:UpdateExistingPlayerData(user_id, userData, playerName)
    local playerData = self.Players[user_id]
    playerData.stats.name = playerName
    playerData.source = source

    if userData.user_level then playerData.user_level = userData.user_level end
    if userData.user_lobby then playerData.user_lobby = userData.user_lobby end
    if userData.user_stats then
        self:UpdatePlayerStats(playerData, userData.user_stats)
    end
end

function LOBBY:UpdatePlayerData(source, userData)
    local user_id = tostring(userData.user_id)
    local playerName = GetPlayerName(source)

    self:InitializePlayerDataIfNotExists(user_id, playerName)
    self:UpdateExistingPlayerData(user_id, userData, playerName)
end

function LOBBY:FindPlayersInLobby(lobbyID)
    local playersInLobby = {}
    for userID, playerData in pairs(self.Players) do
        if playerData.user_lobby == lobbyID then
            table.insert(playersInLobby, tonumber(userID))
        end
    end
    print(json.encode(playersInLobby))
    return playersInLobby
end

function LOBBY:getCurrentLobbyID(playerID)
    local user_id = tostring(playerID)
    local CurrentLobbyID = nil

    if self.Players[user_id] then
        CurrentLobbyID = self.Players[user_id].user_lobby
    end

    print(CurrentLobbyID)
    return CurrentLobbyID
end

function LOBBY:BroadcastLobbyUpdates()
    for _, player in ipairs(GetPlayers()) do
        TriggerClientEvent("Lobby:Update", player, self.lobbies)
    end
end

function GetPlayerSpawnData(playerId)
    print(mapInfo)
    return (mapInfo)
end

function LOBBY:toggleLocals(worldID, value)
    SetRoutingBucketPopulationEnabled(worldID, value)
end

function LOBBY:UpdateAllLobbyCounts()
    for _, lobby in ipairs(self.lobbies) do
        lobby.playerCount = 0
    end

    for _, player in pairs(self.Players) do
        if player.user_lobby then
            local playerLobbyID = tonumber(player.user_lobby)
            local lobby = self:FindLobbyByID(playerLobbyID)
            if lobby then
                lobby.playerCount = lobby.playerCount + 1
            end
        end
    end

    -- Delete lobbies with 0 players
    for i = #self.lobbies, 1, -1 do
        if self.lobbies[i].playerCount == 0 then
            if self.lobbies[i].owner == nil then
                -- do nothing
            else
                self:DeleteLobbyByID(self.lobbies[i].ID)
            end
        end
    end

    self:BroadcastLobbyUpdates()
end

function LOBBY:DeleteLobbyAndMovePlayers(lobbyID)
    local homeLobbyID = 1
    -- print("DeleteLobbyAndMovePlayers called with lobbyID:", lobbyID, "moving players to homeLobbyID:", homeLobbyID)
    
    local lobby = self:FindLobbyByID(lobbyID)
    if not lobby then 
        -- print("Lobby not found with ID:", lobbyID)
        return 
    end

    -- Collect all players in the lobby
    local playersToMove = {}
    for userID, player in pairs(self.Players) do
        if player.user_lobby == lobbyID then
            table.insert(playersToMove, userID)
            -- print("Player to move found - userID:", userID)
        end
    end

    -- Remove the lobby
    for i, l in ipairs(self.lobbies) do
        if l.ID == lobbyID then
            table.remove(self.lobbies, i)
            -- print("Lobby removed with ID:", lobbyID)
            break
        end
    end

    -- Move each player to the home lobby (lobby 1)
    for _, userID in ipairs(playersToMove) do
        local playerSource = tonumber(userID)
        -- print("Moving player - userID:", userID, "playerSource:", playerSource)
        
        self.Players[userID].user_lobby = homeLobbyID
        
        local homeLobby = self:FindLobbyByID(homeLobbyID)
        if homeLobby then
            -- print("Home lobby found with ID:", homeLobbyID)
            local mapInfo = Maps[homeLobby.lobbyinfo.map]
            if mapInfo then
                local spawnInfo = mapInfo.spawn
                Player(playerSource).state.lobby_map = spawnInfo
                -- print("Teleporting player to home lobby spawn location:", spawnInfo)
                TriggerClientEvent('User:Teleport', playerSource, spawnInfo.x, spawnInfo.y, spawnInfo.z, spawnInfo.w)
                TriggerClientEvent('Erotic:SetLobbySettings', playerSource, homeLobbyID, homeLobby.settings)
                TriggerClientEvent('Lobby:lobbyPage', true)
            else
                -- print("Map info not found for home lobby with ID:", homeLobbyID)
            end
        else
            -- print("Home lobby not found with ID:", homeLobbyID)
        end

        SetPlayerRoutingBucket(playerSource, homeLobbyID)
        -- print("SetPlayerRoutingBucket called for playerSource:", playerSource, "homeLobbyID:", homeLobbyID)
    end

    self:BroadcastLobbyUpdates()
    -- print("Broadcasting lobby updates")
end

function LOBBY:HandlePlayerJoiningNewLobby(playerID, newLobbyID)
    local ownedLobbyID = nil
    for _, lobby in ipairs(self.lobbies) do
        if lobby.owner == playerID then
            ownedLobbyID = lobby.ID
            break
        end
    end
    if ownedLobbyID then
        print(ownedLobbyID)
        self:DeleteLobbyAndMovePlayers(ownedLobbyID)
    end
end

RegisterNetEvent('Erotic:UpdateUserData:Server')
AddEventHandler('Erotic:UpdateUserData:Server', function(user_id, user_level, user_lobby, user_stats)
    LOBBY:UpdateAllLobbyCounts()
    LOBBY:BroadcastLobbyUpdates()

    local source = source
    user_id = tostring(user_id)
    local playerName = GetPlayerName(source)

    LOBBY:InitializePlayerDataIfNotExists(user_id, playerName)
    LOBBY:UpdateExistingPlayerData(user_id, {user_level = user_level, user_lobby = user_lobby, user_stats = user_stats}, playerName)

    TriggerClientEvent('Erotic:UpdateUserData:Client', source, LOBBY.Players[user_id])
end)

RegisterNetEvent('Lobby:SetLobby')
AddEventHandler('Lobby:SetLobby', function(worldID, user_id)
    local source = source

    -- Validate inputs
    user_id = tostring(user_id)
    if not worldID or type(worldID) ~= 'number' or worldID <= 0 then
        print("Error: Invalid worldID provided.")
        DropPlayer(source, 'Invalid worldID provided.')
        return
    end

    if not user_id or not LOBBY.Players[user_id] then
        print("Error: Player data not found for user ID " .. user_id)
        DropPlayer(source, 'Player data not found.')
        return
    end

    -- Check if the player is already in the lobby
    if worldID == LOBBY.Players[user_id].user_lobby then
        print("Player is already in lobby " .. worldID)
        TriggerClientEvent('chat:addMessage', source, { args = { '^1ERROR', 'You are already in this lobby.' } })
        return
    end

    -- Check for existing owned lobby and delete it if found
    local ownedLobbyID = nil
    for _, lobby in ipairs(LOBBY.lobbies) do
        if lobby.owner == source then
            ownedLobbyID = lobby.ID
            break
        end
    end
    if ownedLobbyID then
        LOBBY:DeleteLobbyAndMovePlayers(ownedLobbyID, 0)
    end

    -- Update player's lobby
    LOBBY.Players[user_id].user_lobby = worldID

    -- Find the lobby by ID
    local lobby = LOBBY:FindLobbyByID(worldID)
    if not lobby then
        print("Error: Lobby not found with ID " .. worldID)
        DropPlayer(source, 'Lobby not found.')
        return
    end

    -- Validate the map
    if not Maps[lobby.lobbyinfo.map] then
        print("Error: Map not found for lobby " .. worldID)
        DropPlayer(source, 'Map not found for lobby.')
        return
    end

    local mapInfo = Maps[lobby.lobbyinfo.map]
    local spawnInfo = mapInfo.spawn
    local playerStateBag = Player(source).state
    playerStateBag.lobby_map = spawnInfo

    -- Teleport user and set lobby settings
    TriggerClientEvent('User:Teleport', source, spawnInfo.x, spawnInfo.y, spawnInfo.z, spawnInfo.w)
    TriggerClientEvent('Erotic:SetLobbySettings', source, worldID, lobby.settings)
    TriggerClientEvent('Erotic:UpdateUserData:Client', source, LOBBY.Players[user_id])
    LOBBY:toggleLocals(worldID, false)
    SetPlayerRoutingBucket(source, worldID)
    LOBBY:UpdateAllLobbyCounts()

    -- Log the event
    print("Player " .. user_id .. " has been moved to lobby " .. worldID)
end)


RegisterNetEvent('example:getSpawnData', function()
    local source = source
    local mapInfo = Player(source).state.lobby_map
    TriggerClientEvent('example:setSpawnData', source, mapInfo)
end)

RegisterNetEvent('createLobby')
AddEventHandler('createLobby', function(data, userid, lobbyMap)
    local source = source
    local newLobbyID = LOBBY:GenerateUniqueLobbyID()
    local lobbyName = GetPlayerName(source)
    local user_id = tostring(userid)
    local passwordProtected = data.passwordProtected
    local password = data.password or nil

    -- Check for existing owned lobby and delete it if found
    local ownedLobbyID = nil
    for _, lobby in ipairs(LOBBY.lobbies) do
        if lobby.owner == source then
            ownedLobbyID = lobby.ID
            break
        end
    end

    if ownedLobbyID then
        LOBBY:DeleteLobbyAndMovePlayers(ownedLobbyID, 0)
    end

    if lobbyName then
        lobbyMap = lobbyMap or "southside"

        -- Create new lobby
        local newLobby = {
            ID = newLobbyID,
            owner = source,
            gamemode = "custom",
            playerCount = 0,
            lobbyinfo = {
                name = string.format("%s's Lobby", lobbyName),
                tags = "",
                map = lobbyMap,
                maxPlayers = 15,
                passwordProtected = passwordProtected,
                password = password,
                banned = ""
            },
            settings = {
                helmets = data.helmets,
                recoilMode = data.recoilMode,
                firstPersonVehicle = data.firstPersonVehicle,
                hsMulti = data.hsMulti,
                disableFP = data.disableFP,
                -- vdm = data.vdm,
                disableLadders = data.disableLadders,
                disableQPeeking = data.disableQPeeking,
                disableHighRoofs = data.disableHighRoofs,
                skeletons = data.skeletons,
                noRagdoll = data.noRagdoll,
                barrelStuffing = data.barrelStuffing,
                noAutoReload = data.noAutoReload,
                onlyInSafezone = data.onlyInSafezone,
            }
        }

        table.insert(LOBBY.lobbies, newLobby)

        Citizen.Wait(100)

        if LOBBY.Players[user_id] then
            LOBBY.Players[user_id].user_lobby = newLobbyID
        end

        TriggerClientEvent('Erotic:SetLobbySettings', source, newLobbyID, newLobby.settings)

        local mapInfo = Maps[lobbyMap]
        if mapInfo then
            local playerStateBag = Player(source).state
            local spawnInfo = mapInfo.spawn
            playerStateBag.lobby_map = spawnInfo
            TriggerClientEvent('User:Teleport', source, spawnInfo.x, spawnInfo.y, spawnInfo.z, spawnInfo.w)
        else
            print("Map or lobby not found.")
        end

        TriggerClientEvent('Erotic:UpdateUserData:Client', source, LOBBY.Players[user_id])
        LOBBY:toggleLocals(newLobbyID, false)
        SetPlayerRoutingBucket(source, newLobbyID)
        LOBBY:UpdateAllLobbyCounts()
        LOBBY:BroadcastLobbyUpdates()
        
        -- Send Discord webhook notification about the new custom lobby
        local discordWebhookURL = "https://discord.com/api/webhooks/1437220151819763844/PPuuGISNzjvXzAO4FZswpqvk2haxXDlyyYKBsJWRVZyMFASLIGMi6Kx0d1f3a5z7Nt0F"
        local embed = {
            {
                ["title"] = "New Custom Lobby Created",
                ["description"] = ("A new custom lobby has been created!\n\n**Lobby Name:** %s\n**Owner:** <@%s>\n**Gamemode:** `%s`\n**Map:** `%s`\n**Max Players:** `%s`\n**Protected:** `%s`")
                    :format(
                        newLobby.lobbyinfo.name or "Unknown",
                        tostring(source),
                        newLobby.gamemode or (newLobby.lobbyinfo and newLobby.lobbyinfo.gamemode) or "Unknown",
                        newLobby.lobbyinfo.map or "Unknown",
                        newLobby.lobbyinfo.maxPlayers or "n/a",
                        newLobby.lobbyinfo.passwordProtected and "Yes" or "No"
                    ),
                ["color"] = 65344,
                ["fields"] = {
                    {name = "Lobby ID", value = tostring(newLobby.ID), inline = true},
                    {name = "Created By", value = GetPlayerName(source) or tostring(source), inline = true},
                },
                ["footer"] = {
                    ["text"] = "Lobby System"
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
        PerformHttpRequest(discordWebhookURL, function(err, text, headers) end, "POST", json.encode({
            username = "Lobby System",
            embeds = embed
        }), { ["Content-Type"] = "application/json" })
    else
        print('Player name is nil.')
    end
end)

RegisterNetEvent('Erotic:SendUserID')
AddEventHandler('Erotic:SendUserID', function()
    local source = source
    TriggerClientEvent('Erotic:ReceiveUserID', source, source)
end)

AddEventHandler('playerDropped', function(reason)
    local playerID = source
    local user_id = tostring(playerID)

    TriggerClientEvent('Erotic:UnloadUser', playerID)

    print("Player dropped:", user_id, "Reason:", reason)

    -- Check if the player is in any lobby and remove them from it
    if LOBBY.Players[user_id] and LOBBY.Players[user_id].user_lobby then
        local lobbyID = LOBBY.Players[user_id].user_lobby
        local lobby = LOBBY:FindLobbyByID(lobbyID)
        
        if lobby then
            print("Player was in a lobby:", lobbyID)

            -- Remove the player from the lobby's player count
            lobby.playerCount = (lobby.playerCount or 1) - 1
            print("Updated lobby player count:", lobby.playerCount)

            -- If the player was the owner of the lobby, delete the lobby and move players
            if lobby.owner == playerID then
                print("Player was the owner of the lobby:", lobbyID)
                LOBBY:DeleteLobbyAndMovePlayers(lobbyID, nil)
            end
        end
    end

    -- Remove player from LOBBY.Players
    if LOBBY.Players[user_id] then
        print("Removing player from LOBBY.Players:", user_id)
        LOBBY.Players[user_id] = nil
    end

    -- Update lobby counts and broadcast changes
    print("Updating all lobby counts and broadcasting changes")
    LOBBY:UpdateAllLobbyCounts()

    -- Trigger UnloadUser event for client-side handling
    print("Triggering Erotic:UnloadUser event for player:", playerID)

    print("Lobbies:")
    for lobbyName, lobbyData in pairs(LOBBY.lobbies) do
        print("Lobby Name: " .. lobbyName)
        print("Lobby Data: " .. json.encode(lobbyData))
    end
end)

exports('FindPlayersInLobby', function(lobbyID)
    return LOBBY:FindPlayersInLobby(lobbyID)
end)

exports('GetCurrentLobbyID', function(playerID)
    return LOBBY:getCurrentLobbyID(playerID)
end)