--  doesnt work
 local weaponConfig = {
    -- PISTOLS
    ["WEAPON_PISTOL"] = {
        recoil = { 50, 50 },
        shake = 1.0,
        spread = 1.5,
    },
    ["WEAPON_SNSPISTOL"] = {
        recoil = { 30, 30 },
        shake = 1.0,
        spread = 1.5,
    },
    ["WEAPON_COMBATPISTOL"] = {
        recoil = { 35, 35 },
        shake = 1.0,
        spread = 0.5
    },
    ["WEAPON_HEAVYPISTOL"] = {
        recoil = { 20, 20 },
        shake = 1.0,
        spread = 0.3
    },
    ["WEAPON_PISTOL_MK2"] = {
        recoil = { 35, 35 },
        shake = 1.0,
        spread = 0.5
    },
    -- SMGS
    ["WEAPON_COMBATPDW"] = {
        recoil = { 50, 50 },
        shake = 0.4,
        spread = 3.0
    },
    ["WEAPON_MACHINEPISTOL"] = {
        recoil = { 50, 50 },
        shake = 0.4,
        spread = 3.0
    },
    ["WEAPON_MINISMG"] = {
        recoil = { 10, 10 },
        shake = 0.75,
        spread = 1.5
    },
    ["WEAPON_MICROSMG"] = {
        recoil = { 10, 10 },
        shake = 0.33,
        spread = 1.5
    },
    ["WEAPON_SMG"] = {
        recoil = { 10, 10 },
        shake = 0.33,
        spread = 1.5
    },
    ["WEAPON_ASSAULTSMG"] = {
        recoil = { 5, 5 },
        shake = 0.33,
        spread = 1.0
    },
    -- SHOTGUNS
    ["WEAPON_DBSHOTGUN"] = {
        recoil = { 500, 500 },
    },
    ["WEAPON_SAWNOFFSHOTGUN"] = {
        recoil = { 500, 500 },
    },
    -- RIFLES
    ["WEAPON_COMPACTRIFLE"] = {
        recoil = { 20, 20 },
        shake = 0.4,
        spread = 1.0
    },
    ["WEAPON_BULLPUPRIFLE"] = {
        recoil = { 20, 20 },
        shake = 0.4,
        spread = 1.0
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        recoil = { 15, 15 },
        shake = 0.3,
        spread = 1.0
    },
    ["WEAPON_ADVANCEDRIFLE"] = {
        recoil = { 15, 15 },
        shake = 0.3,
        spread = 1.0
    },
    ["WEAPON_CARBINERIFLE"] = {
        recoil = { 10, 10 },
        shake = 0.2,
        spread = 1.0
    },
    ["WEAPON_SPECIALCARBINE"] = {
        recoil = { 10, 10 },
        shake = 0.2,
        spread = 1.0
    },
    ["WEAPON_HEAVYRIFLE"] = {
        recoil = { 20, 20 },
        shake = 0.2,
        spread = 1.0
    },
    ["WEAPON_TACTICALRIFLE"] = {
        recoil = { 20, 20 },
        shake = 0.2,
        spread = 1.0
    },

    ['WEAPON_DRILL'] = {
        recoil = { 1, 1 },
        shake = 0.5,
        spread = 0.1
    },
    ['WEAPON_DRILL_COBALT'] = {
        recoil = { 1, 1 },
        shake = 0.5,
        spread = 0.1
    },
    ['WEAPON_DRILL_HSS'] = {
        recoil = { 1, 1 },
        shake = 0.5,
        spread = 0.1
    },
    ['WEAPON_DRILL_DIAMOND'] = {
        recoil = { 1, 1 },
        shake = 0.5,
        spread = 0.1
    },
}

local hashMap = {}
for weaponName, _ in pairs(weaponConfig) do
    hashMap[GetHashKey(weaponName)] = weaponName
end

local recoilConfig = {}

local GetGameplayCamRelativePitch = GetGameplayCamRelativePitch
local SetGameplayCamRelativePitch = SetGameplayCamRelativePitch

local cachedRecoil = { 0, 0 }
local lastShot = 0.0


Recoil:RegisterMode('cmplx', function()
for weapon, data in pairs(weaponConfig) do
    assert(data.recoil, "missing recoil for weapon " .. weapon)
    local hash = GetHashKey(weapon)

    local shakeAmplitude = GetWeaponRecoilShakeAmplitude(hash)
    local accuracySpread = GetWeaponAccuracySpread(hash)

    shakeAmplitude = tonumber(string.format("%.2f", shakeAmplitude))
    accuracySpread = tonumber(string.format("%.2f", accuracySpread))

    if data.shake and shakeAmplitude ~= data.shake then
        print("^1shake^0 config mismatch for ", weapon, "meta: ", shakeAmplitude, "config: ", data.shake)
    end

    if data.spread and accuracySpread ~= data.spread then
        print("^2spread^0 config mismatch for ", weapon, "meta: ", accuracySpread, "config: ", data.spread)
    end

    recoilConfig[hash] = data.recoil
end

print("All weapons loaded correctly")




lib.onCache("weapon", function(new, old)
    if type(new) == "number" then
        print("Player has equipt a new weapon, updating their recoil cache...")

        if not recoilConfig[new] then
            cachedRecoil = { 0, 0 }
            return
        end

        local min, max = table.unpack(recoilConfig[new])

        cachedRecoil = { min, max }
        return
    end

    cachedRecoil = { 0, 0 }
end)

AddEventHandler('CEventGunShot', function(listeners, invoker)
    if invoker ~= cache.ped then
        return
    end

    if GetGameTimer() - lastShot > 0.5 then
        lastShot = GetGameTimer()

        local pitch = GetGameplayCamRelativePitch()
        local recoil = math.random(cachedRecoil[1], cachedRecoil[2]) / 100
        print(pitch, recoil)

        SetGameplayCamRelativePitch(pitch + recoil, 0.8)
    end
end)

AddEventHandler("onClientResourceStart", function(resource)
    if resource ~= cache.resource then
        return
    end

    local currentWeapon = cache.weapon
    if type(currentWeapon) ~= "number" then
        cachedRecoil = { 0, 0 }
        return
    end

    if not recoilConfig[currentWeapon] then
        print("Gun doesn't have a default recoil, resulting to no recoil...")
        cachedRecoil = { 0, 0 }
        return
    end

    local min, max = table.unpack(recoilConfig[currentWeapon])

    cachedRecoil = { min, max }
    print("Resource restarted - cached recoil for the currently held weapon...")
end)

CreateThread(function()
    while true do
        Wait(0)
        local plyPed = cache.ped
        local _, weapon = GetCurrentPedWeapon(plyPed, true)
        local vehicle = cache.vehicle
        local weaponName = hashMap[weapon]

        if not vehicle then
            if weaponConfig[weaponName] and weaponConfig[weaponName].shake then
                SetWeaponRecoilShakeAmplitude(weapon, weaponConfig[weaponName].shake)
            end
        else
            SetWeaponRecoilShakeAmplitude(weapon, GetConvarInt("cl_fpsRecoil", 4.5))
        end
    end
    end)
end)