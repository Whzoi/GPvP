local killcamActive = false

-- Killcam coordination: when killcam runs, skip the default death flow so the camera can play.
RegisterNetEvent('killcam:setActive', function(state)
    killcamActive = state and true or false
end)

local function UndeadedPlayer(x, y, z, h)
    NetworkResurrectLocalPlayer(vector3(x, y, z), h, true, false)
    TriggerEvent('baseevents:revived')
    TriggerEvent('core:setFullArmour')
end

local function DeathTimer(spawndata)
    if spawndata then
        UndeadedPlayer(spawndata.x, spawndata.y, spawndata.z, spawndata.w or 0)
    else
        UndeadedPlayer(213.7408, -1368.8058, 30.5875, 170.7939) -- Default spawn if no data received -- which means this script broke and i need to kms :)
    end
end

RegisterNetEvent('example:setSpawnData', function(spawndata)
    if spawndata then
        TriggerEvent('killcam:setSpawn', { x = spawndata.x, y = spawndata.y, z = spawndata.z }, spawndata.w or 0)
    end
    DeathTimer(spawndata)
end)

RegisterCommand('kill', function(source, args, rawCommand)
    local ped = PlayerPedId()
    SetPedToRagdoll(ped, 5000, 5000, 0, true, true, false)
    Citizen.Wait(100)
    SetEntityHealth(ped, 0)
end)

local function HandlePlayerDeath()
    if killcamActive then return end
    Wait(0) -- allow killcam to flag itself before we run
    if killcamActive then return end

    local ped = PlayerPedId()
    SetPedToRagdoll(ped, 5000, 5000, 0, true, true, false)
    RemoveAllPedWeapons(ped, true)
    AnimpostfxPlay("DeathFailOut", 0, false)
    PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds", true)
    ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
    Citizen.Wait(1000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    AnimpostfxStop("DeathFailOut")
    TriggerServerEvent('example:getSpawnData')
end

AddEventHandler('baseevents:onPlayerDied', HandlePlayerDeath)
AddEventHandler('baseevents:onPlayerKilled', HandlePlayerDeath)

AddEventHandler('baseevents:revived', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    TriggerEvent('core:setFullArmour')
end)
