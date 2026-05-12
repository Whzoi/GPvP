local function SetFullArmour()
    local player = PlayerId()
    local ped = PlayerPedId()
    local maxArmour = GetPlayerMaxArmour(player)
    local armour = maxArmour > 0 and maxArmour or 100

    SetPlayerMaxArmour(player, armour)
    SetPedArmour(ped, armour)
end

local function SetFullArmourWithRetry()
    CreateThread(function()
        for _ = 1, 10 do
            SetFullArmour()
            Citizen.Wait(500)
        end
    end)
end

local function Initialize()
    CreateThread(function()
        Citizen.Wait(1000)
        DoScreenFadeOut(1000)
        exports.spawnmanager:setAutoSpawn(false)
        exports.spawnmanager:spawnPlayer({
            x = 0.0,
            y = 0.0,
            z = 0.0,
            heading = 90.0,
            skipFade = false,
        }, function()
            Citizen.Wait(250)

            local ped = PlayerPedId()
            local spawnCoords = vector3(211.9867, -1368.7795, 30.5865)
            local spawnHeading = 229.8816
            SetCanAttackFriendly(ped, true, true)
            NetworkSetFriendlyFireOption(true)
            RequestCollisionAtCoord(spawnCoords)
            SetEntityCoords(ped, spawnCoords, false, false, false, false)
            SetEntityHeading(ped, spawnHeading)
            SetFullArmourWithRetry()

            Citizen.Wait(500)
            DoScreenFadeIn(1500)

            TriggerEvent('Erotic:LoadUser')
        end)
        collectgarbage()
    end)
end

CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

   
        if weapon == `WEAPON_UNARMED` then
            DisableControlAction(0, 25, true)  
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true)  
            DisableControlAction(0, 140, true) 

            -- Extra: ensure no lock-on occurs
            SetPlayerLockon(PlayerId(), false)
            SetPlayerLockonRangeOverride(PlayerId(), 0.0)
        else
          
            SetPlayerLockon(PlayerId(), true)
        end
    end
end)


print('VDM off')



-- Vehicle models that should NOT collide with players
local ghostVehicles = {
    "revolter",
    "issi7",
    "cyclone",
    "omnisegt",
    "jester",
    "bf400",
    "powersurge",
    "sultan",
    "nwkuruma"
}

-- Convert to hash table for fast lookups
local ghostHashes = {}
for _, model in ipairs(ghostVehicles) do
    ghostHashes[GetHashKey(model)] = true
end


CreateThread(function()
    while true do
        Wait(0)

        for veh in EnumerateVehicles() do
            local model = GetEntityModel(veh)

            if ghostHashes[model] then

                -- ONLY disable collisions between players and the vehicle
                for _, pid in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(pid)

                    -- Disable collision between THIS VEHICLE <-> PLAYER PED
                    SetEntityNoCollisionEntity(veh, ped, true)
                    SetEntityNoCollisionEntity(ped, veh, true)
                end

                -- IMPORTANT:
                -- We DO NOT disable vehicle-to-vehicle collisions
                -- We DO NOT disable world collisions
                -- Only vehicle <-> player collisions are removed.
            end
        end
    end
end)





-- Vehicle Enumerator Helpers
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        
        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end





Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Prevent crashing.

        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end

		-- Stop Spawn
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
		SetGarbageTrucks(false)
        -- Infinite stamina handling
        RestorePlayerStamina(PlayerId(), 1.0)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

		SetRandomBoats(false)
       		SetVehicleDensityMultiplierThisFrame(0.0)
       		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
        BlockWeaponWheelThisFrame(true)
        DisplayAmmoThisFrame(display, false)
		-- Clear NPC
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
    end
end)


CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            Initialize()
            break
        end
    end
end)

AddEventHandler('core:setFullArmour', function()
    SetFullArmourWithRetry()
end)

AddEventHandler('playerSpawned', function()
    SetFullArmourWithRetry()
end)

RegisterNetEvent('Erotic:LoadUser')
AddEventHandler('Erotic:LoadUser', function()
    TriggerEvent('drp_clothing:setclothes')
    -- Add your user loading logic here
        ShutdownLoadingScreen()

            ShutdownLoadingScreenNui()

    TriggerServerEvent('Erotic:LoadUser')
    SetFullArmourWithRetry()
    print('user loaded')
end)

RegisterNetEvent('Erotic:UnloadUser')
AddEventHandler('Erotic:UnloadUser', function(playerId)
    -- print(playerId, "has left the server")
end)
