---@diagnostic disable: param-type-mismatch

CURRENT_LOCATION = nil
LOADING_VARIATION = false

benchCoords = vec4(232.4490, -1389.3483, 29.4709+1.2, -295)
isOpen = false

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        revertToOriginal()
        DeleteEntity(EDIT_GUN)
    end
end)

exports("applyComponents", function(weaponName)
    local weaponHash = GetHashKey(weaponName)
    local weaponMeta = GetResourceKvpString(tostring(weaponHash).."_components")
    applyAttachmentsFromMeta(json.decode(weaponMeta))
end)

RegisterNetEvent("erp-weaponbench:openMenu", function(data)
    CURRENT_LOCATION = data
    local gun = GetSelectedPedWeapon(PlayerPedId())
    if not WEAPON_LIST[gun] then return end
    SetEntityCoords(PlayerPedId(), vec3(231.9152, -1389.8375, 30.4810))
    local coords = CURRENT_LOCATION.editCoords
    local gunData = getAttachmentsForCurrentWeapon(gun, true)
    prewarmAttachmentModels(gun)
    loadGun(gun, coords)
    SendNUIMessage({ type = "openUI", toggle = true, gunData = gunData })
    isOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    handleBackground()
end)


function kvpKey(hash)
    return tostring(hash).."_components"
end

function kvpSave(hash, meta)
    if not hash or not meta then return end
    SetResourceKvp(kvpKey(hash), json.encode(meta))
end

function kvpLoad(hash)
    if not hash then return {} end
    local s = GetResourceKvpString(kvpKey(hash))
    if not s or s == "" then return {} end
    local ok = json.decode(s)
    return ok or {}
end

function extractNewMetaFromData(attData)
    local meta = {}
    for _, comp in pairs(attData) do
        if comp.component and comp.component ~= 0 then
            meta[#meta+1] = comp.component
        end
    end
    return meta
end

function applyAttachmentsFromMeta(meta)
    local ped = PlayerPedId()
    local gun = GetSelectedPedWeapon(ped)
    if not gun or gun == `WEAPON_UNARMED` then return end
    for _, compHash in ipairs(meta) do
        if not HasPedGotWeaponComponent(ped, gun, compHash) then
            GiveWeaponComponentToPed(ped, gun, compHash)
        end
        if DoesEntityExist(EDIT_GUN) then
            GiveWeaponComponentToWeaponObject(EDIT_GUN, compHash)
        end
    end
end

function saveWeaponAttachments(gun)
    if not gun or gun == `WEAPON_UNARMED` then return end
    local attData = getAttachmentsForCurrentWeapon(gun)
    kvpSave(gun, extractNewMetaFromData(attData))
end


CreateThread(function()
    local lastGun = nil
    while true do
        Wait(150)
        local ped = PlayerPedId()
        local gun = GetSelectedPedWeapon(ped)
        if gun ~= lastGun then
            lastGun = gun
            if gun and gun ~= `WEAPON_UNARMED` then
                local meta = kvpLoad(gun)
                applyAttachmentsFromMeta(meta)
            end
        end
    end
end)

CreateThread(function()
    local inVeh = false
    while true do
        Wait(300)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 and not inVeh then
            inVeh = true
            local gun = GetSelectedPedWeapon(ped)
            if gun and gun ~= `WEAPON_UNARMED` then
                applyAttachmentsFromMeta(kvpLoad(gun))
            end
        elseif veh == 0 then
            inVeh = false
        end
    end
end)


RegisterNUICallback("changeAttachment", function(data, cb)
    if LOADING_VARIATION then cb(true) return end
    local ped = PlayerPedId()
    local gun = GetSelectedPedWeapon(ped)
    local isTint = type(data.attachment) == "number"


    if isTint then
        SetPedWeaponTintIndex(ped, gun, data.attachment - 1)
        SetWeaponObjectTintIndex(EDIT_GUN, data.attachment - 1)
        saveWeaponAttachments(gun)
        exports['notifications']:SendAlert('success', 'Tint Equipped', 1500)

        cb(true)
        return
    end

    exports['notifications']:SendAlert('success', 'Attachment Equipped', 1500)

    local comp = data.attachment and joaat(data.attachment)
    local last = data.lastAttachment and joaat(data.lastAttachment)

    if not data.attachment then
        if HasPedGotWeaponComponent(ped, gun, last) then
            RemoveWeaponComponentFromPed(ped, gun, last)
            RemoveWeaponComponentFromWeaponObject(EDIT_GUN, last)
        end
    else
        local model = GetWeaponComponentTypeModel(comp)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        GiveWeaponComponentToPed(ped, gun, comp)
        GiveWeaponComponentToWeaponObject(EDIT_GUN, comp)
    end
    if type(playAttachmentFX) == "function" then
        playAttachmentFX()
    end

    if data.label == "Variation" then
        LOADING_VARIATION = true
        SendNUIMessage({ type = "toggleButtonLock", toggle = LOADING_VARIATION })
        SetEntityVisible(EDIT_GUN, false, false)
        Wait(300)
        refreshEditGun(gun)
    end

    saveWeaponAttachments(gun)
    cb(true)
end)

RegisterNUICallback("onExit", function(data, cb)
    isOpen = false
    destroyWeaponCamera()
    FreezeEntityPosition(PlayerPedId(), false)
    DeleteEntity(EDIT_GUN)
    EDIT_GUN = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    cb(true)
end)

RegisterNUICallback("onCancel", function(data, cb)
    isOpen = false
    cancelEditGun()
    cb(true)
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end
