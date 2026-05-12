---@diagnostic disable: param-type-mismatch, undefined-global

grp = {
    verticalRecoil = true,  -- Toggle recoil system
    disableAimPunching = true, -- Prevent pistol whipping
    whitelistedWeapons = {
        [`WEAPON_KNIFE`] = true,
        [`WEAPON_BAT`] = true,
    },

    recoilMultipliers = {
        -- Pistols
        [`WEAPON_PISTOL`] = { vertical = 1.2, horizontal = 0.5 },
        [`WEAPON_COMBATPISTOL`] = { vertical = 1.3, horizontal = 0.6 },
        [`WEAPON_HEAVYPISTOL`] = { vertical = 0.5, horizontal = 0.1 },
        [`WEAPON_PISTOLXM3`] = { vertical = 1.0, horizontal = 0.3 },
        [`WEAPON_VINTAGEPISTOL`] = { vertical = 0.3, horizontal = 0.3 },
        [`WEAPON_SNSPISTOL`] = { vertical = 0.5, horizontal = 0.3 },
        [`WEAPON_PISTOL_MK2`] = { vertical = 0.9, horizontal = 0.1 },
        [`WEAPON_GLOCK17`] = { vertical = 0.4, horizontal = 0.2 },
        [`WEAPON_GLOCK20`] = { vertical = 0.6, horizontal = 0.1 },
        [`WEAPON_SP45`] = { vertical = 0.8, horizontal = 0.2 },

        -- Rifles
        [`WEAPON_ASSAULTRIFLE`] = { vertical = 0.8, horizontal = 0.5 },
        [`WEAPON_CARBINERIFLE`] = { vertical = 0.6, horizontal = 0.2 },
        [`WEAPON_HEAVYRIFLE`] = { vertical = 1.0, horizontal = 0.7 },
        [`WEAPON_CARBINERIFLE_MK2`] = { vertical = 0.4, horizontal = 0.3 },
        [`WEAPON_TACTICALRIFLE`] = { vertical = 0.6, horizontal = 0.5 },
        [`WEAPON_COMPACTRIFLE`] = { vertical = 0.8, horizontal = 0.5 },
        [`WEAPON_BULLPUPRIFLE`] = { vertical = 0.6, horizontal = 0.5 },
        [`WEAPON_M4`] = { vertical = 0.6, horizontal = 0.4 },
        [`WEAPON_HK416`] = { vertical = 0.4, horizontal = 0.4 },
        [`WEAPON_MK18`] = { vertical = 0.4, horizontal = 0.4 },
        [`WEAPON_PP19`] = { vertical = 0.4, horizontal = 0.4 },

        -- SMGs
        [`WEAPON_MINISMG`] = { vertical = 1.6, horizontal = 0.6 },
        [`WEAPON_MICROSMG`] = { vertical = 0.5, horizontal = 0.6 },
        [`WEAPON_MACHINEPISTOL`] = { vertical = 0.6, horizontal = 0.5 },
        [`WEAPON_APPISTOL`] = { vertical = 0.7, horizontal = 0.5 },
        [`WEAPON_SMG`] = { vertical = 0.5, horizontal = 0.3 },
        [`WEAPON_SMG_MK2`] = { vertical = 0.7, horizontal = 0.5 },
        [`WEAPON_COMBATPDW`] = { vertical = 0.5, horizontal = 0.3 },
        [`WEAPON_MPX`] = { vertical = 1.0, horizontal = 0.8 },

        -- Defaults
        VEHICLE = { vertical = 1.5, horizontal = 0.6 },
        DEFAULT = { vertical = 1.0, horizontal = 0.5 },
    }
}

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local isArmed = IsPedArmed(plyPed, 4)
        local _, weapon = GetCurrentPedWeapon(plyPed, true)
        local vehicle = GetVehiclePedIsIn(plyPed, false)
        local inVehicle = vehicle ~= 0

        Wait(isArmed and 0 or 1000)

        -- Disable aim punching (melee while aiming)
        if grp.disableAimPunching and isArmed then
            DisableControlAction(0, 140, true) -- Melee attack light
            DisableControlAction(0, 141, true) -- Melee attack heavy
            DisableControlAction(0, 142, true) -- Melee alternate
        end

        -- Handle recoil only when shooting
        if grp.verticalRecoil and isArmed and IsPedShooting(plyPed) and not grp.whitelistedWeapons[weapon] then
            local movementSpeed = math.ceil(GetEntitySpeed(plyPed))
            local camHeading = GetGameplayCamRelativeHeading()
            local headingFactor = math.random(10, 40 + movementSpeed) / 100

            local weaponRecoil = grp.recoilMultipliers[weapon] or grp.recoilMultipliers.DEFAULT
            local verticalRecoil = weaponRecoil.vertical
            local horizontalRecoil = weaponRecoil.horizontal

            -- Scale recoil when in vehicle
            if inVehicle then
                verticalRecoil = verticalRecoil * grp.recoilMultipliers.VEHICLE.vertical
                horizontalRecoil = horizontalRecoil * grp.recoilMultipliers.VEHICLE.horizontal
            end

            -- Horizontal recoil
            local rightLeft = math.random(1, 2)
            local adjustedHeading = (rightLeft == 1) 
                and camHeading + (horizontalRecoil * headingFactor) 
                or camHeading - (horizontalRecoil * headingFactor)
            SetGameplayCamRelativeHeading(adjustedHeading)

            -- Vertical recoil (with vehicle/bike compensation)
            local vehicleClass = inVehicle and GetVehicleClass(vehicle) or 0
            local isWeirdRecoil = (vehicleClass == 13 or vehicleClass == 8) -- Bikes, quads

            local recoilAmount = math.random(50, 100 + movementSpeed) / 100 * verticalRecoil
            local currentRecoil = 0.0

            repeat
                Wait(0)
                local pitchIncrease = isWeirdRecoil and (math.random(28, 32) / 10) or 0.1
                SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + pitchIncrease, 0.2)
                currentRecoil = currentRecoil + 0.1
            until currentRecoil >= recoilAmount
        end
    end
end)

-- if you need help with this script dm me @tim_ed
