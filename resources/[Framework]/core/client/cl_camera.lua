-- Prevent players from cycling into the far/third camera view; keep the first two options.
local BLOCKED_CAM_MODES = {
    [2] = true, -- third camera slot in the cycle
    [3] = true, -- some contexts expose a 3rd index; treat it as blocked too
}

local fallbackPedMode = 1
local fallbackVehicleMode = 1

local function removeThirdCameraUse()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        local current = GetFollowVehicleCamViewMode()

        if BLOCKED_CAM_MODES[current] then
            SetFollowVehicleCamViewMode(fallbackVehicleMode)
        end

        return
    end

    local current = GetFollowPedCamViewMode()

    if BLOCKED_CAM_MODES[current] then
        SetFollowPedCamViewMode(fallbackPedMode)
    end
end

CreateThread(function()
    while true do
        removeThirdCameraUse()
        Wait(150)
    end
end)
