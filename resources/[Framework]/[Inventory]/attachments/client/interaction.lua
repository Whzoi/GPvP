local inZone = false
CreateThread(function()
    exports["core"]:AddBoxZone(
        "weaponbench",
        vector3(232.4490, -1389.3483, 30.4709),
        2.0, 
        2.0, 
        {
            heading = -128,
            scale={1.0, 1.0, 1.0},
            minZ = 29,
            maxZ = 32,
        }
    )
end)

local wait = Wait
local is_control_just_released = IsControlJustReleased
local function interaction()
    Citizen.CreateThread(function()
        while inZone do
            if not isOpen then
                if is_control_just_released(0, 38) then
                    -- exports['prompts']:hidePrompt()
                exports["gpvp-textui"]:hideTextUI('attachment_bench') 

                    TriggerEvent("erp-weaponbench:openMenu", {
                        editCoords = vec4(232.8460, -1388.7490, 30.4280, 140.6639)
                    })
                end
            end
            wait()
        end
    end)
end

RegisterCommand('openweaponbench', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    
    TriggerEvent("erp-weaponbench:openMenu", {
        editCoords = vec4(232.4490, -1389.3483, 30.4709, 318.3112)
    })
end, false)

AddEventHandler("polyzone:enter", function(name)
    if name == "weaponbench" then
        inZone = true
        -- exports['prompts']:hidePrompt()
        -- Wait(100)

        -- exports['prompts']:showPrompt({
        --     pressText = "Press E",
        --     text = "to use the bench"
        -- })     
        
        -- The id should be unique!
        exports["gpvp-textui"]:showTextUI('attachment_bench', 'Weapon Bench', 'E') 
        interaction()
    end
end)

AddEventHandler("polyzone:exit", function(name)
    if name == "weaponbench" then
        inZone = false
        -- exports['prompts']:hidePrompt()
        exports["gpvp-textui"]:hideTextUI('attachment_bench') 
    end
end)