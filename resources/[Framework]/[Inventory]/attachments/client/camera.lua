local weaponCam = nil
local rotationX = 0.0
local rotationY = 0.0
local rotationSpeed = 0.15
local cameraDistance = 0.5
local targetCameraDistance = 0.5
local cameraBaseYaw = 0.0
local currentPresetIndex = 1
local benchSafetyEnabled = false
local distanceStep = 0.05
local distanceClamp = {min = 0.25, max = 1.0}

local CameraConfig = {
    swayAmplitude = 0.004,
    swaySpeedMs = 800.0,
    presets = {
        { label = "Front",    rotX = 0.08, rotYOffset = math.pi,                dist = 0.70 },
        { label = "Side",     rotX = 0.06, rotYOffset = math.pi + math.rad(90), dist = 0.65 },
        { label = "Detail",   rotX = 0.16, rotYOffset = math.pi,                dist = 0.45 }
    }
}

local math_clamp = math.clamp
local math_cos = math.cos
local math_sin = math.sin
local math_rad = math.rad
local math_pi = math.pi
local get_game_timer = GetGameTimer
local get_disabled_control_normal = GetDisabledControlNormal
local is_disabled_control_pressed = IsDisabledControlPressed
local does_entity_exist = DoesEntityExist
local is_nui_focused = IsNuiFocused
local set_nui_focus = SetNuiFocus
local set_cam_coord = SetCamCoord
local set_cam_rot = SetCamRot
local point_cam_at_entity = PointCamAtEntity
local get_entity_forward_vector = GetEntityForwardVector
local create_cam = CreateCam
local set_cam_use_shallow_dof_mode = SetCamUseShallowDofMode
local set_cam_near_dof = SetCamNearDof
local set_cam_far_dof = SetCamFarDof
local set_cam_active = SetCamActive
local set_cam_active_with_interp = SetCamActiveWithInterp
local render_script_cams = RenderScriptCams
local send_nui_message = SendNUIMessage
local does_cam_exist = DoesCamExist
local createthread = CreateThread
local get_gameplay_cam_coord = GetGameplayCamCoord
local get_gameplay_cam_rot = GetGameplayCamRot
local play_sound_frontend = PlaySoundFrontend
local request_named_ptfx_asset = RequestNamedPtfxAsset
local use_particle_fx_asset_next_call = UseParticleFxAssetNextCall
local start_particle_fx_non_looped_at_coord = StartParticleFxNonLoopedAtCoord
local get_entity_coords = GetEntityCoords
local get_active_players = GetActivePlayers
local set_entity_locally_invisible = SetEntityLocallyInvisible
local get_player_ped = GetPlayerPed
local playerid = PlayerId
local hide_hud_and_radar_this_time = HideHudAndRadarThisFrame
local set_use_hi_dof = SetUseHiDof
local wait = Wait
local disable_player_firing = DisablePlayerFiring
local player_ped_id = PlayerPedId
local disable_all_control_actions = DisableAllControlActions
local is_disabled_control_just_pressed = IsDisabledControlJustPressed
local set_nui_focus_keep_input = SetNuiFocusKeepInput
local freeze_entity_position = FreezeEntityPosition
local delete_entity = DeleteEntity
local destroy_cam = DestroyCam
local pairs = pairs
local set_ped_can_ragdoll = SetPedCanRagdoll

local function setPlayerBenchSafety(enabled)
    local ped = player_ped_id()
    if enabled and not benchSafetyEnabled then
        set_ped_can_ragdoll(ped, false)
        benchSafetyEnabled = true
    elseif not enabled and benchSafetyEnabled then
        set_ped_can_ragdoll(ped, true)
        benchSafetyEnabled = false
    end
end
local set_entity_collision = SetEntityCollision

local function playBenchFlyIn(targetCam)
    local introCam = create_cam("DEFAULT_SCRIPTED_CAMERA", true)
    local startPos = get_gameplay_cam_coord()
    local startRot = get_gameplay_cam_rot(2)

    set_cam_coord(introCam, startPos.x, startPos.y, startPos.z)
    set_cam_rot(introCam, startRot.x, startRot.y, startRot.z, 2)
    set_cam_active(introCam, true)
    set_cam_active(targetCam, true)

    render_script_cams(true, false, 0, true, true)
    set_cam_active_with_interp(targetCam, introCam, 900, true, true)

    createthread(function()
        wait(950)
        if does_cam_exist(introCam) then
            destroy_cam(introCam, true)
        end
    end)
end

local function spawnBenchFX(coords)
    request_named_ptfx_asset("core")
    local tries = 0
    while not HasNamedPtfxAssetLoaded("core") and tries < 20 do
        wait(0)
        tries += 1
    end
    use_particle_fx_asset_next_call("core")
    start_particle_fx_non_looped_at_coord("ent_sht_electric_spark", coords.x, coords.y, coords.z + 0.1, 0.0, 0.0, 0.0, 0.35, false, false, false)
end

local function playAttachmentTransition()
    if not weaponCam then return end
    play_sound_frontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    local startDist = targetCameraDistance
    local snapDist = math.max(distanceClamp.min, startDist - 0.12)
    local fxPos = EDIT_GUN and get_entity_coords(EDIT_GUN) or nil

    CreateThread(function()
        targetCameraDistance = snapDist
        Wait(110)
        targetCameraDistance = startDist
    end)

    if fxPos then
        request_named_ptfx_asset("core")
        local tries = 0
        while not HasNamedPtfxAssetLoaded("core") and tries < 20 do
            Wait(0)
            tries += 1
        end
        use_particle_fx_asset_next_call("core")
        start_particle_fx_non_looped_at_coord("ent_sht_electric_spark", fxPos.x, fxPos.y, fxPos.z + 0.08, 0.0, 0.0, 0.0, 0.25, false, false, false)
    end
end

local function applyCameraPreset(idx)
    local preset = CameraConfig.presets[idx]
    if not preset then return end
    currentPresetIndex = idx
    rotationX = preset.rotX
    rotationY = cameraBaseYaw + preset.rotYOffset
    targetCameraDistance = preset.dist
    cameraDistance = targetCameraDistance
end

local function cyclePreset(step)
    local count = #CameraConfig.presets
    if count == 0 then return end
    local nextIndex = ((currentPresetIndex - 1 + step) % count) + 1
    applyCameraPreset(nextIndex)
    play_sound_frontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

local function resetCameraPose()
    applyCameraPreset(1)
    play_sound_frontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function createWeaponCam(coords, gunHash)
    
    local weaponObject = EDIT_GUN
    cameraBaseYaw = math_rad(coords.w or 0.0)
    applyCameraPreset(currentPresetIndex)

    local cameraX = coords.x + cameraDistance * math_cos(rotationY) * math_cos(rotationX)
    local cameraY = coords.y + cameraDistance * math_sin(rotationY) * math_cos(rotationX)
    local cameraZ = coords.z + cameraDistance * math_sin(rotationX)

    weaponCam = create_cam("DEFAULT_SCRIPTED_CAMERA", true)
    set_cam_coord(weaponCam, cameraX, cameraY, cameraZ)
    point_cam_at_entity(weaponCam, weaponObject, 0.0, 0.0, 0.0, true)
    -- Keep the weapon crisp (no shallow depth of field blur)
    set_cam_use_shallow_dof_mode(weaponCam, false)
    set_cam_near_dof(weaponCam, 0.0)
    set_cam_far_dof(weaponCam, 200.0)
    play_sound_frontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    setPlayerBenchSafety(true)
    spawnBenchFX(coords)
    playBenchFlyIn(weaponCam)

    local hasChanged, bestIndex = GetWeaponBoneCoords(gunHash)
    if hasChanged then
        send_nui_message({ type = "updatePos", bonePositions = BONE_POSITIONS })
    end
    if bestIndex then
        send_nui_message({ type = "highlightBone", index = bestIndex })
    end
    handleCamUpdates(weaponObject, gunHash, coords)
    createthread(function()
        while does_cam_exist(weaponCam) do
            Wait(1)
            ShowHelpNotification(
                'Press ~INPUT_FRONTEND_RDOWN~ Accept' ..
                '~n~Press ~INPUT_FRONTEND_PAUSE_ALTERNATE~ Cancel' ..
                '~n~Hold ~INPUT_FRONTEND_RB~ Camera mode: Scroll to zoom'
            )
        end
    end)
end

local function camControl(weaponObject, coords)
    if not does_entity_exist(weaponObject) then return end
    if not is_nui_focused() then
        set_nui_focus(true, true)
    end
    if is_disabled_control_pressed(0, 206) then
        set_nui_focus(false, false)

        if is_disabled_control_pressed(2, 241) then
            targetCameraDistance -= distanceStep
        end

        if is_disabled_control_pressed(2, 242) then
            targetCameraDistance += distanceStep
        end

        if is_disabled_control_just_pressed(0, 174) then
            cyclePreset(-1)
        elseif is_disabled_control_just_pressed(0, 175) then
            cyclePreset(1)
        elseif is_disabled_control_just_pressed(0, 172) then
            resetCameraPose()
        end

        targetCameraDistance = math_clamp(targetCameraDistance, distanceClamp.min, distanceClamp.max)
        cameraDistance = cameraDistance + (targetCameraDistance - cameraDistance) * 0.18

        local mouseX = get_disabled_control_normal(0, 1) * rotationSpeed
        local mouseY = get_disabled_control_normal(0, 2) * rotationSpeed

        rotationX = math_clamp(rotationX - mouseY, -math_pi / 2, math_pi / 2)
        rotationY = rotationY - mouseX
    
        local sway = math_sin(get_game_timer() / CameraConfig.swaySpeedMs) * CameraConfig.swayAmplitude
        local camRotY = rotationY + sway
        local camX = coords.x + cameraDistance * math_cos(camRotY) * math_cos(rotationX)
        local camY = coords.y + cameraDistance * math_sin(camRotY) * math_cos(rotationX)
        local camZ = coords.z + cameraDistance * math_sin(rotationX)

        set_cam_coord(weaponCam, camX, camY, camZ)
        point_cam_at_entity(weaponCam, weaponObject, 0.0, 0.0, 0.0, true)
    end
end

function handleBackground()
    createthread(function()
        while isOpen do
            if not LOADING_VARIATION then
                for k,v in pairs(get_active_players()) do
                    if v ~= playerid() then
                        set_entity_locally_invisible(get_player_ped(v))
                    end
                end
            end
            hide_hud_and_radar_this_time()
            set_use_hi_dof(false)
            wait()
        end
    end)
end

function handleCamUpdates(weaponObject, gunHash, coords)
    createthread(function()
        while does_entity_exist(weaponObject) do
            wait(0)

            local plyPed = player_ped_id()
            disable_player_firing(plyPed, true)
            disable_all_control_actions(0)
            local hasChanged, bestIndex = GetWeaponBoneCoords(gunHash)

            if hasChanged then
                send_nui_message({ type = "updatePos", bonePositions = BONE_POSITIONS })
            end
            if bestIndex then
                send_nui_message({ type = "highlightBone", index = bestIndex })
            end

            -- Keep the weapon clean; no colored overlay/outline
            SetEntityDrawOutline(weaponObject, false)

            camControl(weaponObject, coords)

            if is_disabled_control_just_pressed(0, 191) then
                -- exports["erotic"]:toggleHud(true)
                -- exports["gpvp-hud"]:UpdateHudEnabled(not hudEnabled)
                -- exports["drp-hud"]:toggleNui(true)
                -- exports["killfeed"]:toggleHud(true)
                send_nui_message({ type = "openUI", toggle = false, gunData = {} })
                set_nui_focus(false, false)
                set_nui_focus_keep_input(false)
                freeze_entity_position(plyPed, false)
                SetEntityDrawOutlineColor(0, 0, 0, 0)
                SetEntityDrawOutlineShader(1)
                SetEntityDrawOutline(weaponObject, false)
                delete_entity(weaponObject)
                destroy_cam(weaponCam, true)
                render_script_cams(false, false, 0, true, true)
                EDIT_GUN = nil
                setPlayerBenchSafety(false)
                break
            end
        end
    end)
end

function destroyWeaponCamera()
    destroy_cam(weaponCam, true)
    render_script_cams(false, false, 0, true, true)
    weaponCam = nil
    setPlayerBenchSafety(false)
end

-- exposed for attachment change feedback
function playAttachmentFX()
    playAttachmentTransition()
end
