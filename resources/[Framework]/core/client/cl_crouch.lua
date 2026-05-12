local crouched = false

local isPunchingDisabled = false

Citizen.CreateThread(function()
    while true do
        if isPunchingDisabled and IsControlPressed(0, 24) then -- 24 is INPUT_ATTACK
            DisableControlAction(0, 24, true)
        end
        Wait(0)
    end
end)




RegisterCommand("crouch", function()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        return
    end

    RequestAnimSet("move_ped_crouched")

    while not HasAnimSetLoaded("move_ped_crouched") do
        Wait(100)
    end

    if crouched == true then
        ResetPedMovementClipset(ped, 0.25)
        crouched = false
    elseif crouched == false then
        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
        crouched = true
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        DisableControlAction(0, 36, false)
    end
end)

RegisterKeyMapping("crouch", "Crouch", "KEYBOARD", "LCONTROL")