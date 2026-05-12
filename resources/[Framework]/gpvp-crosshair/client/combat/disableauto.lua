local blockedWeapons = {
    WEAPON_APPISTOL = true,
    WEAPON_MICROSMG = true,
    WEAPON_COMPACTRIFLE = true,
    WEAPON_MINISMG = true,
    WEAPON_GLOCK18 = true,
    WEAPON_MACHINEPISTOL = true,
}

-- Convert names → hashes
local blockedHashes = {}
for name,_ in pairs(blockedWeapons) do
    blockedHashes[GetHashKey(name)] = true
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 then  -- Only when IN a vehicle
            local weapon = GetSelectedPedWeapon(ped)

            if blockedHashes[weapon] then
                -- Prevent shooting ONLY in vehicle
                DisablePlayerFiring(PlayerId(), true)

                DisableControlAction(0, 257, true) -- Attack (vehicle)
                DisableControlAction(0, 142, true) -- Melee alternate
                DisableControlAction(0, 69, true)  -- Drive-by
                DisableControlAction(0, 70, true)  -- Vehicle attack
                DisableControlAction(0, 92, true)  -- Vehicle aim
            end
        end

        Wait(0)
    end
end)