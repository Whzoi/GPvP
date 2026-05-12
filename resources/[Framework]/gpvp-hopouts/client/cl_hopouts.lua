-- Hopouts Script for Custom Lobbies (Client-Side)
local Hopouts = {
    enabled = false,
    team1 = {},
    team2 = {},
    currentRound = 0,
    maxRounds = 5,
    roundActive = false,
    countdownActive = false,
    team1Wins = 0,
    team2Wins = 0,
    spawnCoords = vector4(527.7125, -1693.8428, 29.4343, 49.6992),
    spawnOffset = 1.8288,
    myTeam = nil,
    myTeamIndex = nil,
    spawnedVehicles = {},
    playerStats = {},
    isSpawning = false,
    isFrozen = false,
    isSpectating = false,
    spectateTarget = nil
}

local function GetSpawnPosition(teamNumber, index)
    local baseCoords = Hopouts.spawnCoords
    local indexOffset = (index - 1) * Hopouts.spawnOffset
    local offsetX = math.cos(math.rad(baseCoords.w)) * indexOffset
    local offsetY = math.sin(math.rad(baseCoords.w)) * indexOffset
    if teamNumber == 2 then
        local teamOffsetDistance = 15.0
        offsetX = offsetX + (math.cos(math.rad(baseCoords.w + 90)) * teamOffsetDistance)
        offsetY = offsetY + (math.sin(math.rad(baseCoords.w + 90)) * teamOffsetDistance)
    end
    return vector4(baseCoords.x + offsetX, baseCoords.y + offsetY, baseCoords.z, baseCoords.w)
end





local function IsInCustomLobby()
    local lobbyID = exports['lobby']:GetCurrentLobbyID(GetPlayerServerIdOfLocal())
    return lobbyID ~= nil and lobbyID ~= 1
-- This line was commented out as it was unreachable
end

local function GetPlayerServerIdOfLocal()
    return GetPlayerServerId(PlayerId())
end

local function ShowCountdown(number)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(tostring(number))
    EndTextCommandDisplayHelp(0, false, true, 1000)
end

Citizen.CreateThread(function()
    while true do
        if Hopouts.isFrozen then
            DisableAllControlActions(0)
        else
            Citizen.Wait(500)
        end
        Citizen.Wait(0)
    end
end)

--local function ShowAnnouncement(text, subtitle)
--    TriggerEvent('chat:addMessage', {
--        color = {255, 215, 0},
--        args = {'Hopouts', text .. (subtitle and " | " .. subtitle or "")}
--    })
--end

--local function StartCountdown()
--    if Hopouts.countdownActive then return end
--    Hopouts.countdownActive = true
--    Citizen.CreateThread(function()
--        for i = 3, 1, -1 do
--            ShowCountdown(i)
--            PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true)
--            Citizen.Wait(1000)
--        end
--        ShowAnnouncement("FIGHT!", "Round " .. Hopouts.currentRound .. " has begun!")
--        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true)
--        Hopouts.countdownActive = false
--        Hopouts.roundActive = true
--        Hopouts.isFrozen = false
--        EnableAllControlActions(0)
--        NetworkSetFriendlyFireOption(true)
--        SetCanAttackFriendly(PlayerPedId(), true, false)
--    end)
--end

local function UpdateScoreboard()
    local team1Alive = 0
    local team2Alive = 0

    for _, playerId in ipairs(Hopouts.team1) do
        local player = GetPlayerFromServerId(playerId)
        if player ~= -1 and not IsPedDeadOrDying(GetPlayerPed(player), 1) then
            team1Alive = team1Alive + 1
        end
    end
    for _, playerId in ipairs(Hopouts.team2) do
        local player = GetPlayerFromServerId(playerId)
        if player ~= -1 and not IsPedDeadOrDying(GetPlayerPed(player), 1) then
            team2Alive = team2Alive + 1
        end
    end

    SendNUIMessage({
        type = 'scoreboard:update',
        team1Wins = Hopouts.team1Wins,
        team2Wins = Hopouts.team2Wins,
        team1Alive = team1Alive,
        team2Alive = team2Alive,
        team1Total = #Hopouts.team1,
        team2Total = #Hopouts.team2,
        currentRound = Hopouts.currentRound,
        maxRounds = Hopouts.maxRounds
    })
end

local function CheckTeamDeaths()
    if not Hopouts.roundActive then return end
    local team1Alive = 0
    local team2Alive = 0
    for _, playerId in ipairs(Hopouts.team1) do
        local player = GetPlayerFromServerId(playerId)
        if player ~= -1 and not IsPedDeadOrDying(GetPlayerPed(player), true) then
            team1Alive = team1Alive + 1
        end
    end
    for _, playerId in ipairs(Hopouts.team2) do
        local player = GetPlayerFromServerId(playerId)
        if player ~= -1 and not IsPedDeadOrDying(GetPlayerPed(player), true) then
            team2Alive = team2Alive + 1
        end
    end
    if team1Alive == 0 and #Hopouts.team1 > 0 then
        if #Hopouts.team2 > 0 then
            TriggerServerEvent('hopouts:roundEnd', 2)
        end
    elseif team2Alive == 0 and #Hopouts.team2 > 0 then
        if #Hopouts.team1 > 0 then
            TriggerServerEvent('hopouts:roundEnd', 1)
        end
    end
    UpdateScoreboard()
end

Citizen.CreateThread(function()
    while true do
        if Hopouts.enabled and Hopouts.roundActive then
            CheckTeamDeaths()
            Citizen.Wait(1000)
        else
            Citizen.Wait(500)
        end
    end
end)

local function SpawnVehiclesForPlayer(spawnPos)
    for _, vehicle in ipairs(Hopouts.spawnedVehicles) do
        if DoesEntityExist(vehicle) then
            SetEntityAsMissionEntity(vehicle, false, true)
            DeleteVehicle(vehicle)
        end
    end
    Hopouts.spawnedVehicles = {}
    local vehicleModels = { GetHashKey("revolter"), GetHashKey("revolter"), GetHashKey("jester"), GetHashKey("jester") }
    local vehicleOffsets = { {forward = 7.0, side = -3.0}, {forward = 7.0, side = 3.0}, {forward = 14.0, side = -3.0}, {forward = 14.0, side = 3.0} }
    Citizen.CreateThread(function()
        for i = 1, #vehicleModels do
            local model = vehicleModels[i]
            local offset = vehicleOffsets[i]
            RequestModel(model)
            local timeout = 0
            while not HasModelLoaded(model) and timeout < 5000 do
                Citizen.Wait(10)
                timeout = timeout + 10
            end
            if HasModelLoaded(model) then
                local heading = spawnPos.w
                local forwardX = math.cos(math.rad(heading)) * offset.forward
                local forwardY = math.sin(math.rad(heading)) * offset.forward
                local perpAngle = heading + 90
                local sideX = math.cos(math.rad(perpAngle)) * offset.side
                local sideY = math.sin(math.rad(perpAngle)) * offset.side
                local vehicleX = spawnPos.x + forwardX + sideX
                local vehicleY = spawnPos.y + forwardY + sideY
                local vehicleZ = spawnPos.z
                local vehicle = CreateVehicle(model, vehicleX, vehicleY, vehicleZ, heading, true, false)
                if DoesEntityExist(vehicle) then
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                    SetVehicleOnGroundProperly(vehicle)
                    SetVehicleEngineOn(vehicle, true, true, false)
                    Entity(vehicle).state.isHopoutsVehicle = true
                    table.insert(Hopouts.spawnedVehicles, vehicle)
                    TriggerEvent('keys:addNew', vehicle, GetVehicleNumberPlateText(vehicle))
                end
                SetModelAsNoLongerNeeded(model)
            end
        end
    end)
end

local function SpawnPlayer(teamNumber, index)
    if Hopouts.isSpawning then return end
    Hopouts.isSpawning = true
    local spawnPos = GetSpawnPosition(teamNumber, index)
    NetworkResurrectLocalPlayer(spawnPos.x, spawnPos.y, spawnPos.z, spawnPos.w, 1, 0)
    Citizen.Wait(0)
    local ped = PlayerPedId()
    if not ped or ped == 0 then
        Hopouts.isSpawning = false
        return
    end
    SetEntityCoordsNoOffset(ped, spawnPos.x, spawnPos.y, spawnPos.z, false, false, false)
    SetEntityHeading(ped, spawnPos.w)
    Citizen.Wait(10)
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 100)
    ClearPedTasksImmediately(ped)
    SetEntityInvincible(ped, false)
    Hopouts.isFrozen = true
    TriggerEvent('baseevents:revived')
    Citizen.CreateThread(function()
        Citizen.Wait(100)
        Hopouts.isSpawning = false
    end)
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        SpawnVehiclesForPlayer(spawnPos)
    end)
end

local function ResetRound()
    Hopouts.roundActive = false
    Hopouts.isSpectating = false
    NetworkSetInSpectatorMode(false, nil)
    NetworkSetFriendlyFireOption(false)
    SetCanAttackFriendly(PlayerPedId(), false, false)
    if Hopouts.myTeam and Hopouts.myTeamIndex then
        Citizen.CreateThread(function()
            Citizen.Wait(100)
            SpawnPlayer(Hopouts.myTeam, Hopouts.myTeamIndex)
        end)
    end
end

function StartSpectating(target)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
    if not targetPed or targetPed == 0 then return end
    Hopouts.isSpectating = true
    Hopouts.spectateTarget = target
    NetworkSetInSpectatorMode(true, targetPed)
end

function StopSpectating()
    Hopouts.isSpectating = false
    Hopouts.spectateTarget = nil
    NetworkSetInSpectatorMode(false, nil)
end

Citizen.CreateThread(function()
    while true do
        if Hopouts.isSpectating then
            if IsControlJustPressed(0, 19) then -- INPUT_CHARACTER_WHEEL
                local myTeamates = Hopouts.myTeam == 1 and Hopouts.team1 or Hopouts.team2
                local currentIndex = -1
                for i, id in ipairs(myTeamates) do
                    if id == Hopouts.spectateTarget then
                        currentIndex = i
                        break
                    end
                end
                if currentIndex ~= -1 then
                    local nextIndex = currentIndex + 1
                    if nextIndex > #myTeamates then nextIndex = 1 end
                    TriggerServerEvent('hopouts:spectate', myTeamates[nextIndex])
                end
            end
        else
            Citizen.Wait(500)
        end
        Citizen.Wait(0)
    end
end)

RegisterCommand('hopouts', function()
    if not IsInCustomLobby() then
        TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'System', 'This command can only be used in custom lobbies!'} })
        return
    end
    Hopouts.enabled = not Hopouts.enabled
    if Hopouts.enabled then
        TriggerEvent('chat:addMessage', { color = {0, 255, 0}, args = {'Hopouts', 'Hopouts enabled! Use /team1 or /team2 to select your team.'} })
        TriggerServerEvent('hopouts:enable')
        SendNUIMessage({type = 'scoreboard:show'})
    else
        TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'Hopouts', 'Hopouts disabled.'} })
        TriggerServerEvent('hopouts:disable')
        Hopouts.team1, Hopouts.team2, Hopouts.myTeam, Hopouts.myTeamIndex = {}, {}, nil, nil
        Hopouts.isFrozen = false
        EnableAllControlActions(0)
        StopSpectating()
        SendNUIMessage({type = 'scoreboard:hide'})
        for _, vehicle in ipairs(Hopouts.spawnedVehicles) do
            if DoesEntityExist(vehicle) then
                SetEntityAsMissionEntity(vehicle, false, true)
                DeleteVehicle(vehicle)
            end
        end
        Hopouts.spawnedVehicles = {}
    end
end, false)

RegisterCommand('team1', function()
    if not Hopouts.enabled then
        TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'Hopouts', 'Hopouts is not enabled! Use /hopouts first.'} })
        return
    end
    if not IsInCustomLobby() then
        TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'System', 'This command can only be used in custom lobbies!'} })
        return
    end
    TriggerServerEvent('hopouts:joinTeam', 1)
end, false)

RegisterCommand('team2', function()
    if not Hopouts.enabled then
        TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'Hopouts', 'Hopouts is not enabled! Use /hopouts first.'} })
        return
    end
    if not IsInCustomLobby() then
        TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'System', 'This command can only be used in custom lobbies!'} })
        return
    end
    TriggerServerEvent('hopouts:joinTeam', 2)
end, false)

RegisterCommand('ready', function()
    if not Hopouts.enabled then return end
    TriggerServerEvent('hopouts:ready')
end, false)

RegisterCommand('leavehop', function()
    if not Hopouts.enabled then return end
    TriggerServerEvent('hopouts:leave')
    Hopouts.myTeam, Hopouts.myTeamIndex = nil, nil
    Hopouts.isFrozen = false
    EnableAllControlActions(0)
    StopSpectating()
    TriggerEvent('chat:addMessage', { color = {255, 255, 0}, args = {'Hopouts', 'You have left the hopout.'} })
end, false)

RegisterCommand('cancelhop', function()
    if not Hopouts.enabled then return end
    TriggerServerEvent('hopouts:cancel')
end, false)

RegisterCommand('triggerstart', function()
    if not Hopouts.enabled then return end
    TriggerServerEvent('hopouts:triggerstart')
end, false)

RegisterNetEvent('hopouts:cancelled')
AddEventHandler('hopouts:cancelled', function()
    Hopouts.myTeam, Hopouts.myTeamIndex = nil, nil
    local baseCoords = vector3(211.9867, -1368.7795, 30.5865)
    RequestCollisionAtCoord(baseCoords.x, baseCoords.y, baseCoords.z)
    NetworkResurrectLocalPlayer(baseCoords.x, baseCoords.y, baseCoords.z, 293.9, true, false)
    SetEntityCoords(PlayerPedId(), baseCoords.x, baseCoords.y, baseCoords.z, 1, 0, 0, 1)
    Hopouts.isFrozen = false
    EnableAllControlActions(0)
    StopSpectating()
    TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'Hopouts', 'The hopout has been cancelled.'} })
end)

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    if not Hopouts.enabled or not Hopouts.roundActive then return end
    local victimId = GetPlayerServerIdOfLocal()
    if Hopouts.myTeam then
        local myTeamates = Hopouts.myTeam == 1 and Hopouts.team1 or Hopouts.team2
        local firstAliveTeammate = nil
        for _, id in ipairs(myTeamates) do
            if id ~= victimId and not IsPedDeadOrDying(GetPlayerPed(GetPlayerFromServerId(id)), 1) then
                firstAliveTeammate = id
                break
            end
        end
        if firstAliveTeammate then
            TriggerServerEvent('hopouts:spectate', firstAliveTeammate)
        end
    end
end)

RegisterNetEvent('hopouts:teamUpdate')
AddEventHandler('hopouts:teamUpdate', function(team1, team2)
    Hopouts.team1 = team1
    Hopouts.team2 = team2
    UpdateScoreboard()
end)

RegisterNetEvent('hopouts:joinedTeam')
AddEventHandler('hopouts:joinedTeam', function(teamNumber, index, success, message)
    Citizen.CreateThread(function()
        if success then
            Hopouts.myTeam = teamNumber
            Hopouts.myTeamIndex = index
            Citizen.Wait(100)
            SpawnPlayer(teamNumber, index)
            local teamMsg = message or ('Joined Team ' .. tostring(teamNumber))
            TriggerEvent('chat:addMessage', { color = {0, 255, 0}, args = {'Hopouts', teamMsg} })
        else
            TriggerEvent('chat:addMessage', { color = {255, 0, 0}, args = {'Hopouts', message or 'Failed to join team'} })
        end
    end)
end)

RegisterNetEvent('hopouts:startRound')
AddEventHandler('hopouts:startRound', function(roundNumber)
    Hopouts.currentRound = roundNumber
    Citizen.CreateThread(function()
        ResetRound()
        Citizen.Wait(1000)
        StartCountdown()
    end)
end)

RegisterNetEvent('hopouts:roundEnd')
--AddEventHandler('hopouts:roundEnd', function(winningTeam, team1Wins, team2Wins, currentRound)
--    Hopouts.roundActive = false
--    Hopouts.team1Wins = team1Wins
--    Hopouts.team2Wins = team2Wins
--    Hopouts.currentRound = currentRound
--    local teamName = winningTeam == 1 and "Team 1" or "Team 2"
--    ShowAnnouncement(teamName .. " wins Round " .. currentRound .. "!", "")
--    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true)
--    ResetRound()
--    if currentRound >= Hopouts.maxRounds then
--        Citizen.Wait(3000)
--        local finalWinner = team1Wins > team2Wins and "Team 1" or (team2Wins > team1Wins and "Team 2" or "Tie")
--        ShowAnnouncement(finalWinner .. " wins the match!", "Final Score: Team 1: " .. team1Wins .. " - Team 2: " .. team2Wins)
--        Citizen.Wait(5000)
--        Hopouts.currentRound = 0
--        Hopouts.team1Wins = 0
--        Hopouts.team2Wins = 0
--    else
--        Citizen.Wait(5000)
--        if IsPlayerHost(PlayerId()) then
--             TriggerServerEvent('hopouts:startNextRound')
--        end
--    end
--end)

RegisterNetEvent('hopouts:updateScore')
AddEventHandler('hopouts:updateScore', function(team1Wins, team2Wins, currentRound)
    Hopouts.team1Wins = team1Wins
    Hopouts.team2Wins = team2Wins
    Hopouts.currentRound = currentRound
    UpdateScoreboard()
end)

RegisterNetEvent('hopouts:startSpectating')
AddEventHandler('hopouts:startSpectating', function(targetServerId)
    StartSpectating(targetServerId)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, vehicle in ipairs(Hopouts.spawnedVehicles) do
            if DoesEntityExist(vehicle) then
                SetEntityAsMissionEntity(vehicle, false, true)
                DeleteVehicle(vehicle)
            end
        end
        SendNUIMessage({type = 'scoreboard:hide'})
    end
end)
