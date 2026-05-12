local KILLCAM_TIME = 3000
local activeCam = nil
local killcamRunning = false
local activeScaleform = nil
local cachedSpawn = { coords = nil, heading = nil }
local function ApplyFullArmour()
    local player = PlayerId()
    local ped = PlayerPedId()
    local armour = GetPlayerMaxArmour(player)
    armour = armour > 0 and armour or 100

    SetPlayerMaxArmour(player, armour)
    SetPedArmour(ped, armour)
    TriggerEvent('core:setFullArmour') -- allow core to enforce retries if needed
end
-- local set_cam_use_shallow_dof_mode = SetCamUseShallowDofMode
-- local set_cam_near_dof = SetCamNearDof
-- local set_cam_far_dof = SetCamFarDof
-- local set_cam_active = SetCamActive


local function cleanupCam()
    if activeCam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(activeCam, false)
        activeCam = nil
    end
    if activeScaleform then
        SetScaleformMovieAsNoLongerNeeded(activeScaleform)
        activeScaleform = nil
    end
    killcamRunning = false
    StopScreenEffect('DeathFailOut')
    TriggerEvent('killcam:setActive', false)
end

local function respawnPlayer()
    DoScreenFadeOut(300)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local coords = cachedSpawn.coords or vector3(218.3501, -1391.1760, 30.5875)
    local heading = cachedSpawn.heading or 229.8816

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), heading)
    ClearPedBloodDamage(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
    SetEntityInvincible(PlayerPedId(), false)
    ApplyFullArmour()

    DoScreenFadeIn(500)
end

RegisterNetEvent('killcam:setSpawn', function(coords, heading)
    if coords then
        cachedSpawn.coords = vector3(coords.x, coords.y, coords.z)
    end
    if heading then
        cachedSpawn.heading = heading
    end
end)

local function loadScaleform(name)
    local handle = RequestScaleformMovie(name)
    local timeout = GetGameTimer() + 5000
    while not HasScaleformMovieLoaded(handle) do
        if GetGameTimer() > timeout then break end
        Wait(0)
    end
    return handle
end

local function showKillcam(killerServerId)
    if killcamRunning then return end
    killcamRunning = true
    TriggerEvent('killcam:setActive', true)

    local killerClientId = GetPlayerFromServerId(killerServerId)
    local killerPed = killerClientId and GetPlayerPed(killerClientId) or 0
    if killerPed == 0 then
        respawnPlayer()
        cleanupCam()
        return
    end

    local killerCoords = GetEntityCoords(killerPed)

    -- Create a simple over-shoulder camera on the killer
    activeCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local offset = GetOffsetFromEntityInWorldCoords(killerPed, 0.0, 2.5, 1.0) -- in front of the ped
    SetCamCoord(activeCam, offset.x, offset.y, offset.z)
    PointCamAtPedBone(activeCam, killerPed, 31086, 0.0, 0.0, 0.0, true) -- head bone
    SetCamFov(activeCam, 70.0)
    -- set_cam_use_shallow_dof_mode(weaponCam, true)
    -- -- Depth of field
    -- set_cam_near_dof(weaponCam, 0.05)
    -- set_cam_far_dof(weaponCam, 0.9)
    -- set_cam_active(weaponCam, true)
    -- SetCamActive(activeCam, true)
    RenderScriptCams(true, false, 0, true, true)

    local killerName = killerClientId and GetPlayerName(killerClientId) or "Unknown"
    -- Big message scaleform
    activeScaleform = loadScaleform("MP_BIG_MESSAGE_FREEMODE")
    if activeScaleform and HasScaleformMovieLoaded(activeScaleform) then
        BeginScaleformMovieMethod(activeScaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
        ScaleformMovieMethodAddParamTextureNameString("Wasted")
        ScaleformMovieMethodAddParamTextureNameString(("Killer: %s"):format(killerName))
        EndScaleformMovieMethod()

        local endTime = GetGameTimer() + KILLCAM_TIME
        CreateThread(function()
            while killcamRunning and GetGameTimer() < endTime do
                Wait(0)
                DrawScaleformMovieFullscreen(activeScaleform, 255, 255, 255, 255, 0)
            end
        end)
    end

    -- Simple bottom UI hint
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(("~r~Killed by ~w~%s"):format(killerName))
    EndTextCommandPrint(KILLCAM_TIME, true)

    -- Optionally play a quick effect
    StartScreenEffect('DeathFailOut', 0, false)

    SetTimeout(KILLCAM_TIME, function()
        cleanupCam()
        respawnPlayer()
    end)
end

AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    if killerId and killerId ~= -1 then
        showKillcam(killerId)
    else
        -- Unknown killer; just respawn quickly
        respawnPlayer()
    end
end)

-- Fallback: also listen for plain player death (suicide or non-player)
AddEventHandler('baseevents:onPlayerDied', function()
    respawnPlayer()
end)
