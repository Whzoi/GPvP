local xhair = {
    enabled = true,
    colour = "#fff"
}

local disable_control_action = DisableControlAction
local get_selected_ped_weapon = GetSelectedPedWeapon
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local is_control_pressed = IsControlPressed
local is_using_keyboard = IsUsingKeyboard
local is_aim_cam_active = IsAimCamActive
local is_ped_armed = IsPedArmed
local is_player_free_aiming = IsPlayerFreeAiming
local player_ped_id = PlayerPedId
local player_id = PlayerId
local set_follow_ped_cam_view_mode = SetFollowPedCamViewMode
local send_nui_message = SendNUIMessage
local wait = Wait

Citizen.CreateThread(function()
    local xhairSettings = GetResourceKvpString("xhairSettings-gpvp")
    if xhairSettings then
        xhairSettings = json.decode(xhairSettings)

        xhair.enabled = xhairSettings.enabled
        xhair.colour = xhairSettings.colour
        Wait(250)
        send_nui_message({ type = "xhair", cross = xhair.enabled })
        send_nui_message({ type = "xhair_colour", color = xhair.colour })
    end
end)

COMBAT = {
    plyPed = player_ped_id(),
    pedWeapon = false,
    InVehicle = false,
    isAiming = false,
    isArmed = false,
    isAimingg = false,
    Sniper = false,
    nonstopCombat = false,

    PedCamera = function(self)
        while true do
            wait(250)
            if self.isArmed or self.isAiming and not self.InVehicle then
                local camMode = get_follow_ped_cam_view_mode()
                if camMode == 1 or camMode == 2 or camMode == 4 then
                    set_follow_ped_cam_view_mode(0)
                -- elseif self.isAiming and camMode == 0 then
                    disable_control_action(1, 0, true)
                end
            else
                wait(500)
            end
        end
    end,
    
    InfoThread = function(self)
        while true do
            wait(1000)
            self.plyPed = player_ped_id()
            self.pedWeapon = get_selected_ped_weapon(self.plyPed) or false;

            self.InVehicle = is_ped_in_any_vehicle(self.plyPed, false)
            self.isAiming = (is_control_pressed(0, 25) and is_using_keyboard(0)) or is_aim_cam_active()
            self.isArmed = is_ped_armed(self.plyPed, 7)
            self.isAimingg = is_player_free_aiming(player_id())
            self.Sniper = (self.pedWeapon == 177293209 or self.pedWeapon == 1785463520)
        end
    end,
}

Citizen.CreateThread(function()
    COMBAT:InfoThread()
    Citizen.Wait(250)
end)

RegisterCommand('cross', function(src, args, rawCommand)
    local hexArg = string.sub(rawCommand, 7)
    if #hexArg > 0 then
        xhair.colour = hexArg
        SetResourceKvp('xhairSettings-gpvp', json.encode(xhair))

        send_nui_message({ type = "xhair_colour", color = hexArg })
    else
        xhair.enabled = not xhair.enabled
        SetResourceKvp('xhairSettings-gpvp', json.encode(xhair))

        send_nui_message({ type = "xhair", cross = xhair.enabled })
    end
end)