--[[
    MAIN ITEM REGISTER THREAD
]]
local healing = false
CreateThread(function()
    Item.Register("oxy", {
        func = function(item)
            if (Player.Health() == 200 and not healing) then
                -- Already Full HP
                return false
            end
            local playerPed = PlayerPedId()
            healing = true
            local finished = exports["taskbar"]:taskBar({
                length = 1000,
                text = "Vicodin",
                animation = { dict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a" },
                canShoot = true
            })
            if (finished == 100) then
                healing = false
                local count = math.random(20, 50)
                while count > 0 do
                    Wait(1000)
                    count = count - 1
                    if GetEntityHealth(playerPed) == 200 then
                        count = 0
                    end
                    local healAmount = math.random(1, 4)
                    SetEntityHealth(playerPed, GetEntityHealth(playerPed) + healAmount)
                    if IsEntityDead(playerPed) then
                        break
                    end
                end
                API.RemoveItem(item, 1)
            end
        end
    })
    
    Item.Register("armour", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local plyPed = PlayerPedId()
            RequestAnimDict('clothingshirt')
            RequestAnimDict('anim@narcotics@trash')
            while not HasAnimDictLoaded('clothingshirt') do
                Wait(0)
            end
            while not HasAnimDictLoaded('anim@narcotics@trash') do
                Wait(0)
            end
            TaskPlayAnim(plyPed, 'anim@narcotics@trash', 'drop_front', 1.0, -1, 1000, 49, 3.0, false, false, false)
            CreateThread(function()
                Wait(1000)
                TaskPlayAnim(plyPed, 'clothingshirt', 'try_shirt_positive_d', 1.0, -1, -1, 50, 0, false, false, false)
            end)
            local finished = exports["taskbar"]:taskBar({
                length = 4000,
                text = "Medium Armour"
              })
            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 60)
                API.RemoveItem(item, 1)
            end
            StopAnimTask(plyPed, 'anim@narcotics@trash', 'drop_front', 1.0)
            StopAnimTask(plyPed, 'clothingshirt', 'try_shirt_positive_d', 1.0)
            ClearPedSecondaryTask(plyPed)
            return true
        end,
        animClearance = true
    })

        Item.Register("minis", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local finished = exports["taskbar"]:taskBar({
                length = 2500,
                text = "Mini Shield",
                animation = { dict = "mp_suicide", anim = "pill" },
              })
            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 15)
                API.RemoveItem(item, 1)
            end
            return true
        end,
        animClearance = true
    })

            Item.Register("bigpot", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local finished = exports["taskbar"]:taskBar({
                length = 4000,
                text = "Big Shield",
                animation = { dict = "amb@world_human_drinking@beer@female@idle_a", anim = "idle_e" }
              })
            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 50)
                API.RemoveItem(item, 1)
            end
            return true
        end,
        animClearance = true
    })

    Item.Register("armour2", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local finished = exports["taskbar"]:taskBar({
                length = 4000,
                text = "Heavy Armour",
                animation = { dict = "clothingtie", anim = "try_tie_negative_a" }
              })

            if (finished == 100) then
                    SetPlayerMaxArmour(PlayerId(), 100)
                    AddArmourToPed(Player.Ped(), 100)
                API.RemoveItem(item, 1)
            end
            return true
        end,
        animClearance = true
    })

    Item.Register("bandage", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() >= 175 then return false end 
            local playerPed = PlayerPedId()

            local currentHealth = Player.Health()
            local healthToSet = currentHealth + 15
            if healthToSet >= 175 then 
                healthToSet = 175 
            end
            -- animation + set health
            Player.InAnim = true 
            local finished = exports["taskbar"]:taskBar({
                length = 4500,
                text = "BANDAGING",
                animation = { scenario = "CODE_HUMAN_MEDIC_KNEEL" }
              })
            if (finished == 100) then
                SetEntityHealth(Player.Ped(), healthToSet)
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false
            return true
        end,
        animClearance = true
    })

    Item.Register("repairkit", {
        func = function(item)
            if Player.InVehicle() then return false end 
            local a = GetEntityCoords(Player.Ped(), 1)
            local b = GetOffsetFromEntityInWorldCoords(Player.Ped(), 0.0, 100.0, 0.0)
            local veh = Player.GetTargetVehicle(a, b)
            if veh == 0 then return false end 

            Player.InAnim = true
            SetVehicleDoorOpen(veh, 4, 1, 1)
            local finished = exports["taskbar"]:taskBar({
                length = 7500,
                text = "repairing",
                animation = { dict = "mini@repair", anim = "fixing_a_player" }
              })

            if (finished == 100) then
                SetVehicleEngineHealth(veh, 9999)
                SetVehiclePetrolTankHealth(veh, 9999)
                SetVehicleFixed(veh)
                StopAnimTask(Player.Ped(), "mini@repair", "fixing_a_player", 1.0)
                Player.InAnim = false
                API.RemoveItem(item, 1)
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false
            return true
        end,
        animClearance = true
    })

    Item.Register("radio", {
        func = function(item)
            ExecuteCommand("radio")
        end,
    })

    Item.Register("joint", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            Player.InAnim = true
            local finished = exports["taskbar"]:taskBar({
                length = 2500,
                text = "using joint",
                animation = { dict = "amb@world_human_smoking_pot@male@base", anim = "base", prop = "joint"},
                canShoot = true
            })
            if (finished == 100) then
                SetPedArmour(Player.Ped(), Player.Armour() + 25)
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            Player.InAnim = false

        end,
        animClearance = true
    })

    Item.Register("kevlar", {
        func = function(item)
            if Player.Armour() == 100 then return false end 
            local playerPed = PlayerPedId()
            if Player.InVehicle() and GetEntitySpeed(PlayerPedId()) < 1.0 then 
                local finished = exports["taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar"
                  })
                ClearPedTasks(playerPed)
    
                if (finished == 100) then
                    SetPedArmour(Player.Ped(), GetPlayerMaxArmour(PlayerId()))
                    API.RemoveItem(item, 1)
                    Player.InAnim = false
                end
                
                ClearPedTasksImmediately(Player.Ped())
                Player.InAnim = false
                return 
            elseif Player.InVehicle() and GetEntitySpeed(PlayerPedId()) > 1.0 then 
                return false
            elseif not Player.InVehicle() then 

                Player.InAnim = true 
                local finished = exports["taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar",
                    animation = { scenario = "CODE_HUMAN_MEDIC_KNEEL"}
                  })
                ClearPedTasks(playerPed)
    
                if (finished == 100) then
                    SetPedArmour(Player.Ped(), GetPlayerMaxArmour(PlayerId()))
                    ClearPedTasksImmediately(Player.Ped())
                    API.RemoveItem(item, 1)
                    Player.InAnim = false
                end
                
                ClearPedTasksImmediately(Player.Ped())
                Player.InAnim = false

            end
        end,
        animClearance = true
    })

    Item.Register("medkit", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() == 200 then return false end 
            local playerPed = PlayerPedId()
            Player.InAnim = true 
            local finished = exports["taskbar"]:taskBar({
                length = 3500,
                text = "healing",
                animation = { scenario = "CODE_HUMAN_MEDIC_KNEEL" }
              })
            ClearPedTasks(playerPed)

            if (finished == 100) then
                SetEntityHealth(Player.Ped(), 200)
                ClearPedTasksImmediately(Player.Ped())
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false
        end,
        animClearance = true
    })

    Item.Register("deluxo", {
        func = function(item)
            TriggerEvent('drp:spawnvehicle', "deluxo")
        end,
    }) 

    Item.Register("stamina", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.InStim then return false end 
            Player.InStim = true 
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
            API.RemoveItem(item, 1)
            TriggerEvent("notifyClient", "Using Stamina Shot", "centerRight", 5000)
            Wait(15000)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            Player.InStim = false 
        end,
        animClearance = true
    })

    for k,v in pairs(Config.Loadouts) do 
        local kit = v.kit 
        local name = v.name 
        local format = v.format 
        Item.Register(name, {
            func = function(item)
                if Player.InVehicle() then return false end 
                local finished = exports["taskbar"]:taskBar({
                    length = 3500,
                    text = "Using Loadout"
                  })
                ClearPedTasks(PlayerPedId())
                if (finished == 100) then
                    DoKitStuff(kit)
                    API.RemoveItem(item, 1)
                end
            end,
        })
    end
end)
