local crosshairEnabled = true
local crosshairVisible = false
local isAiming = false
local isWeaponGun = false
local plyId = PlayerId()
local plyPed = PlayerPedId()
local plyVeh = { id = 0, model = 0, class = -1 }
local crosshairSize = 5
local DEBUG = false

local policeBikes = {
    [-1921512137] = true,
    [-1145771600] = true,
    [297719966] = true
}

local function manageCrosshair(toggle)
    if not crosshairEnabled then
        if crosshairVisible then
            SendNUIMessage({ action = "hide" })
            crosshairVisible = false
        end
        return
    end

    if toggle and not crosshairVisible then
        SendNUIMessage({ action = "show" })
        crosshairVisible = true
    elseif (not toggle) and crosshairVisible then
        SendNUIMessage({ action = "hide" })
        crosshairVisible = false
    end
end

RegisterCommand("crosshair", function(_, _, rawCommand)
    local hexArg = string.sub(rawCommand, 11)
    if #hexArg > 0 then
        SetResourceKvp('crosshairColor', hexArg)
        SetResourceKvp('crosshair_color', hexArg)
        if exports['notifications'] then
            exports['notifications']:SendAlert('success', 'Crosshair color updated')
        end
        SendNUIMessage({ action = "color", color = hexArg })
    else
        -- toggle enabled state
        local current = GetResourceKvpInt('crosshair_enabled')
        local newVal = current == 0 and 1 or 0
        SetResourceKvpInt('crosshair_enabled', newVal)
        crosshairEnabled = (newVal ~= 0)
        if exports['notifications'] then
            exports['notifications']:SendAlert(crosshairEnabled and 'success' or 'error', crosshairEnabled and 'Crosshair Enabled' or 'Crosshair Disabled')
        end
        if not crosshairEnabled then
            SendNUIMessage({ action = "hide" })
            crosshairVisible = false
        end
    end
end, false)


RegisterCommand("togglecrosshair", function()
    local current = GetResourceKvpInt('crosshair_enabled')
    local newVal = current == 0 and 1 or 0
    SetResourceKvpInt('crosshair_enabled', newVal)
    -- legacy key for compatibility
    SetResourceKvpInt('crosshair', newVal == 0 and 2 or 1)
    crosshairEnabled = (newVal ~= 0)
    if not crosshairEnabled then
        manageCrosshair(false)
    end
    SendNUIMessage({ action = "toggle", enabled = crosshairEnabled })
end, false)

RegisterCommand("crosssize", function(_, args)
    local sz = tonumber(args[1])
    if not sz then return end
    sz = math.floor(math.max(1, math.min(10, sz)))
    crosshairSize = sz
    SetResourceKvpInt('crosshair_size', sz)
    SendNUIMessage({ action = "size", size = sz })
end, false)


local function setViewMode(viewmode)
    for i = 1, 7 do
        SetCamViewModeForContext(i, viewmode)
    end
    SetFollowPedCamViewMode(viewmode)
    SetFollowVehicleCamViewMode(viewmode)
end

local function refreshPlayerState()
    plyId = PlayerId()
    plyPed = PlayerPedId()

    local veh = GetVehiclePedIsIn(plyPed, false)
    if veh and veh ~= 0 then
        plyVeh.id = veh
        plyVeh.model = GetEntityModel(veh)
        plyVeh.class = GetVehicleClass(veh)
        wasInVehicle = true
    else
        plyVeh.id = 0
        plyVeh.model = 0
        plyVeh.class = -1
        wasInVehicle = false
    end

    local weapon = GetSelectedPedWeapon(plyPed)
    isWeaponGun = weapon and weapon ~= `WEAPON_UNARMED` and IsPedArmed(plyPed, 4)
end

local function init()
    refreshPlayerState()

    if GetResourceKvpInt('crosshair_enabled') == 0 then
        SetResourceKvpInt('crosshair_enabled', 1)
    end
    crosshairEnabled = (GetResourceKvpInt('crosshair_enabled') ~= 0)

    local savedColor = GetResourceKvpString('crosshair_color') or GetResourceKvpString('crosshairColor')
    if not savedColor or savedColor == "" then
        savedColor = '#FFFFFF'
        SetResourceKvp("crosshair_color", savedColor)
    end
    SendNUIMessage({ action = "color", color = savedColor })
    local savedSize = GetResourceKvpInt('crosshair_size')
    if savedSize and savedSize > 0 then
        crosshairSize = math.max(1, math.min(10, savedSize))
    end
    SendNUIMessage({ action = "size", size = crosshairSize })
    SendNUIMessage({ action = "hide" })
end

CreateThread(function()
    Wait(100)
    init()
    refreshPlayerState()

    while true do

        Wait(0)
        refreshPlayerState()

        local aimCtrl = IsControlPressed(0, 25) or IsControlPressed(0, 24)
        local aimingNow = IsPlayerFreeAiming(plyId) or IsAimCamActive() or aimCtrl

        if crosshairEnabled and isWeaponGun and aimingNow then
            manageCrosshair(true)
        else
            manageCrosshair(false)
        end
    end
end)

exports('setViewMode', setViewMode) -- legacy export noop for compatibility
