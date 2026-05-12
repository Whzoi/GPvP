local hudEnabled = true
local hudMoveMode = false

RegisterNUICallback("saveHudPosition", function(data, cb)
    if data.x and data.y then
        SetResourceKvpFloat("hudPosX", data.x)
        SetResourceKvpFloat("hudPosY", data.y)
        print(("[HUD] Saved HUD position to KVP: %.2f, %.2f"):format(data.x, data.y))
    end
    cb("ok")
end)

RegisterNUICallback("enableMouse", function(_, cb)
    hudMoveMode = true
    -- Fully focus NUI (keyboard + mouse) and do NOT keep game input
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    cb("ok")
end)

RegisterNUICallback("disableMouse", function(_, cb)
    hudMoveMode = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    cb("ok")
end)

RegisterCommand("movehud", function()
    SendNUIMessage({ type = "movehud" })
end, false)

RegisterCommand("resethud", function()
    DeleteResourceKvp("hudPosX")
    DeleteResourceKvp("hudPosY")
    SendNUIMessage({ type = "resetHud" })
    print("[HUD] Reset HUD position to default")
end, false)

--RegisterNetEvent("gpvp-hud:updateLeaderboard", function(entries)
--    SendNUIMessage({
--        type = "leaderboard",
--        entries = entries
--    })
--end)
--
--CreateThread(function()
--    Wait(1000)
--    TriggerServerEvent("gpvp-hud:requestLeaderboard")
--end)

CreateThread(function()
    local x = GetResourceKvpFloat("hudPosX")
    local y = GetResourceKvpFloat("hudPosY")
    if x and y and x > 0 and y > 0 then
        SendNUIMessage({ type = "applyHudPosition", x = x, y = y })
    end
end)

RegisterNUICallback("requestHudPosition", function(_, cb)
    local x = GetResourceKvpFloat("hudPosX")
    local y = GetResourceKvpFloat("hudPosY")
    if x and y and x > 0 and y > 0 then
        SendNUIMessage({ type = "applyHudPosition", x = x, y = y })
    end
    SendNUIMessage({ type = "toggleHud", enabled = hudEnabled })
    cb("ok")
end)

local function GetWeaponData(weapon)
    return (Config and Config.Weapons and Config.Weapons[weapon]) or {
        name = "Unknown",
        icon = "images/default.png"
    }
end

local recentKillCache = {}

local function getEntityCacheKey(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end
    if NetworkGetEntityIsNetworked(entity) then
        return ("net:%s"):format(NetworkGetNetworkIdFromEntity(entity))
    end
    return ("ent:%s"):format(entity)
end

local function markKillHandled(entity)
    local key = getEntityCacheKey(entity)
    if key then
        recentKillCache[key] = GetGameTimer()
    end
end

local function wasKillRecentlyHandled(entity, window)
    local key = getEntityCacheKey(entity)
    if not key then return false end
    local last = recentKillCache[key]
    if not last then return false end
    if GetGameTimer() - last <= (window or 2500) then
        return true
    end
    recentKillCache[key] = nil
    return false
end

local function cleanupOldKills()
    local now = GetGameTimer()
    for key, tick in pairs(recentKillCache) do
        if now - tick > 10000 then
            recentKillCache[key] = nil
        end
    end
end

CreateThread(function()
    while true do
        Wait(5000)
        cleanupOldKills()
    end
end)

local function pushKillfeedEntry(victim, weaponHash)
    local killerName = GetPlayerName(PlayerId()) or "You"
    local killerSubtitle = "You"
    local victimName = "Unknown"
    local victimSubtitle = "Target"

    if IsPedAPlayer(victim) then
        local victimPlayer = NetworkGetPlayerIndexFromPed(victim)
        if victimPlayer ~= nil and victimPlayer ~= -1 then
            victimName = GetPlayerName(victimPlayer) or victimName
            victimSubtitle = "Player"
        else
            victimSubtitle = "Player"
        end
    else
        victimSubtitle = "NPC"
    end

    local wData = GetWeaponData(weaponHash)

    SendNUIMessage({
        type = "killfeed",
        killerName = killerName,
        killerSubtitle = killerSubtitle,
        victimName = victimName,
        victimSubtitle = victimSubtitle,
        weaponImage = wData.icon ~= "" and wData.icon or "images/default.png"
    })
end

CreateThread(function()
    local lastWeapon = `WEAPON_UNARMED`
    local lastClip = -1
    local lastReserve = -1

    while true do
        Wait(100)
        local ped = PlayerPedId()
        if not DoesEntityExist(ped) then goto continue end

        local weapon = GetSelectedPedWeapon(ped)
        local health = math.floor(GetEntityHealth(ped) / 2)
        local armor = math.floor(GetPedArmour(ped))

        if weapon == `WEAPON_UNARMED` then
            if lastWeapon ~= `WEAPON_UNARMED` then
                SendNUIMessage({ type = "hideWeapon" })
                lastWeapon = `WEAPON_UNARMED`
            end
            SendNUIMessage({
                showHud = hudEnabled,
                health = health,
                armor = armor,
            })
            goto continue
        end

        local _, clipAmmo = GetAmmoInClip(ped, weapon)
        local totalAmmo = GetAmmoInPedWeapon(ped, weapon)
        local reserve = math.max(0, totalAmmo - clipAmmo)
        if reserve > 9999 then reserve = 9999 end

        if weapon ~= lastWeapon then
            lastWeapon = weapon
            local wData = GetWeaponData(weapon)
            SendNUIMessage({
                type = "updateWeapon",
                weaponImage = wData.icon,
                ammoClip = clipAmmo,
                ammoTotal = reserve
            })
            lastClip = clipAmmo
            lastReserve = reserve
        else
            if clipAmmo ~= lastClip or reserve ~= lastReserve then
                SendNUIMessage({
                    type = "updateWeapon",
                    ammoClip = clipAmmo,
                    ammoTotal = reserve
                })
                lastClip = clipAmmo
                lastReserve = reserve
            end
        end

        SendNUIMessage({
            showHud = hudEnabled,
            health = health,
            armor = armor,
        })

        ::continue::
    end
end)

AddEventHandler("gameEventTriggered", function(name, data)
    if name ~= "CEventNetworkEntityDamage" then return end
    if type(data) ~= "table" then return end

    local victim = data[1]
    local attacker = data[2]
    local weaponHash = data[7]

    if attacker ~= PlayerPedId() then return end
    if victim == PlayerPedId() then return end
    if not victim or victim == 0 or not DoesEntityExist(victim) then return end
    if not IsEntityAPed(victim) then return end
    if wasKillRecentlyHandled(victim, 2500) then return end

    CreateThread(function()
        local preHealth = GetEntityHealth(victim)
        local preArmor = GetPedArmour(victim)

        -- Wait a tick to allow fatal damage state to settle
        Wait(0)
        if not IsPedDeadOrDying(victim, true) and not IsPedFatallyInjured(victim) then
            Wait(100)
        end

        if not IsPedDeadOrDying(victim, true) and not IsPedFatallyInjured(victim) then
            return
        end

        markKillHandled(victim)
        local damageContribution = math.max(0, math.floor((preHealth / 2) + preArmor + 0.5))
        pushKillfeedEntry(victim, weaponHash)
        local victimServerId = nil
        if IsPedAPlayer(victim) then
            local victimPlayer = NetworkGetPlayerIndexFromPed(victim)
            if victimPlayer ~= nil and victimPlayer ~= -1 then
                victimServerId = GetPlayerServerId(victimPlayer)
            end
        end
        TriggerServerEvent("gpvp-hud:registerKill", {
            victim = victimServerId,
            weapon = weaponHash,
            damage = damageContribution
        })
    end)
end)

-- When HUD move mode is enabled, block player movement/aim/shoot/camera
CreateThread(function()
    while true do
        if hudMoveMode then
            -- Disable look/camera
            DisableControlAction(0, 1, true)   -- LookLeftRight
            DisableControlAction(0, 2, true)   -- LookUpDown
            -- Disable movement
            DisableControlAction(0, 30, true)  -- MoveLeftRight
            DisableControlAction(0, 31, true)  -- MoveUpDown
            DisableControlAction(0, 32, true)  -- MoveUpOnly (W)
            DisableControlAction(0, 33, true)  -- MoveDownOnly (S)
            DisableControlAction(0, 34, true)  -- MoveLeftOnly (A)
            DisableControlAction(0, 35, true)  -- MoveRightOnly (D)
            DisableControlAction(0, 21, true)  -- Sprint
            DisableControlAction(0, 22, true)  -- Jump
            DisableControlAction(0, 36, true)  -- Duck
            -- Disable combat
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 45, true)  -- Reload
            DisableControlAction(0, 37, true)  -- SelectWeapon
            DisableControlAction(0, 44, true)  -- Cover
            DisableControlAction(0, 140, true) -- MeleeAttackLight
            DisableControlAction(0, 141, true) -- MeleeAttackHeavy
            DisableControlAction(0, 142, true) -- MeleeAlternate
            DisableControlAction(0, 257, true) -- Attack2
            DisableControlAction(0, 263, true) -- MeleeBlock
            -- Prevent firing as a safeguard
            DisablePlayerFiring(PlayerId(), true)
            Wait(0)
        else
            Wait(250)
        end
    end
end)