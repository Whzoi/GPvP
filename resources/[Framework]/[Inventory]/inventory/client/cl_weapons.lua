local cooldown = false
local clipCache = {}

RegisterNetEvent('erotic:useWeapon')
AddEventHandler('erotic:useWeapon', function(weaponName)
    local ped = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)
    local currentWeapon = GetSelectedPedWeapon(ped)
    
    if weaponHash == currentWeapon then
        putawayGun(weaponName)
    elseif not cooldown then
        cooldown = true
        local bulletType = findAmmoType(weaponHash)
        local ammoCount = ammoCount(bulletType)

        local currentAmmo = GetAmmoInClip(ped, currentWeapon)
        clipCache[tostring(currentWeapon)] = currentAmmo

        GiveWeaponToPed(ped, weaponHash, tonumber(ammoCount), false, true)
        exports["attachments"]:applyComponents(weaponName)
        SetCurrentPedVehicleWeapon(ped, weaponHash)
        SetCurrentPedWeapon(ped, weaponHash, true)
        ClearPedTasks(ped)

        local cachedClip = clipCache[tostring(weaponHash)]
        if cachedClip ~= nil then
            SetAmmoInClip(ped, weaponHash, cachedClip)
        else
            SetAmmoInClip(ped, weaponHash, 999)
        end
        Citizen.SetTimeout(250, function()
            cooldown = false
        end)
    end
end)

function playerHasWeapon()
    local ped = PlayerPedId()
    return IsPedArmed(ped, 1) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        playerArmed = IsPedArmed(PlayerPedId(), 4)
    end
end)

CreateThread(function()
    while true do
        Wait(250)
        if not quickSelectEnabled and playerArmed then
            local playerPed = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(playerPed)
            local found, clipSize = GetAmmoInClip(playerPed, currentWeapon)
            if found and currentWeapon ~= `WEAPON_UNARMED` then
                clipCache[tostring(currentWeapon)] = clipSize
            end
        end
    end
end)

function ammoCount(bullet)
    local count = 0
    if inventoryData and type(inventoryData) == 'table' then
        for k, v in pairs(inventoryData) do
            if v and v.item == bullet then
                count = count + v.quantity
            end
        end
    end
    return count
end

function setDefaultAmmo(forbullet, count)
    if inventoryData and type(inventoryData) == 'table' then
        for k, v in pairs(inventoryData) do
            if v and v.item == bullet then
                v.quantity = count
            end
        end
    end
end

function findAmmoType(weaponHash)
    for weaponName, bullet in pairs(Config.Weapons) do
        if GetHashKey(weaponName) == weaponHash then
            if type(bullet) == 'string' then
                return bullet
            end
        end
    end
    return nil
end

AddEventHandler('erotic:updatePlayerInventory', function(inventory)
    local localPlayer = PlayerPedId()
    if IsPedArmed(localPlayer, 4) then
        local currentWeapon = GetSelectedPedWeapon(localPlayer)
        local ammoType = findAmmoType(currentWeapon)
        local ammoCount = ammoCount(ammoType)
        SetPedAmmo(localPlayer, currentWeapon, ammoCount)
        
        local hasWeapon = false
        for k, v in pairs(inventory) do
            if v and v.item and GetHashKey(v.item) == currentWeapon then
                hasWeapon = true
            end
        end
        
        if not hasWeapon then
            local foundClip, clipSize = GetAmmoInClip(localPlayer, currentWeapon)
            if foundClip and currentWeapon ~= `WEAPON_UNARMED` then
                clipCache[tostring(currentWeapon)] = clipSize
            end
            RemoveAllPedWeapons(localPlayer, false)
        end
    end
end)

function putawayGun(weaponName)
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(ped)
        
        if currentWeapon == GetHashKey(weaponName) then
            if currentWeapon ~= `WEAPON_UNARMED` then
                local foundClip, clipSize = GetAmmoInClip(ped, currentWeapon)
                if foundClip then
                    clipCache[tostring(currentWeapon)] = clipSize
                end
            end
            ClearPedTasks(ped)
            RemoveAllPedWeapons(ped, true)
        end
    end)
end
