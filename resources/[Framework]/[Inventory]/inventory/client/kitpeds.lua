local locations = {
    {coords = vector3(210, -1371.7, 29.59), heading = 317.89, pedcoords = vector3(211.16, -1372.96, 29.59), pedheading = 230.3},
    {coords = vector3(1155.77, -462.03, 65.83), heading = 257.98, pedcoords = vector3(1155.36, -463.69, 65.78), pedheading = 167.0},
    {coords = vector3(1283.65, -2560.82, 42.98), heading = 171.17, pedcoords = vector3(1281.75, -2560.59, 42.85), pedheading = 84.84},
    {coords = vector3(1584.45, 2893.63, 56.09), heading = 115.13, pedcoords = vector3(1583.69, 2895.07, 56.07), pedheading = 21.57 },
    {coords = vector3(-230.56, -2435.35, 5.0), heading = 145.68, pedcoords = vector3(-232.62, -2433.64, 5.0 ), pedheading = 54.09 },
    {coords = vector3(-326.81, 6093.21, 30.46), heading = 46.91, pedcoords = vector3(-325.41, 6094.43, 30.46), pedheading = 308.10},
    {coords = vector3(1530.17, 6340.21, 23.15), heading = 328.67, pedcoords = vector3(1532.95, 6339.8, 23.2),  pedheading = 240.66},
    {coords = vector3(-272.19, 6336.46, 31.43), heading = 314.76, pedcoords = vector3(-270.86, 6334.93, 31.43), pedheading = 230.0},
    {coords = nil, heading = nil, pedcoords = vector3(-654.39, 1963.07, 499.49), pedheading = 21.94},
    {coords = vector3(3390.74, 4094.93, 223.54), heading = 219.9, pedcoords = vector3(3391.43, 4096.71, 223.71), pedheading = 323.43},
    {pedcoords = vector3(-1247.065, -1398.573, 3.171693), pedheading = 172.28923034668},
    {pedcoords = vector3(-1481.769, -656.9156, 27.94311), pedheading = 213.67013549805 },
    {pedcoords = vector3(-1576.209, -566.868, 115.3284), pedheading = 116.06464385986 }
}

local entities = {}
local kitShop = {
    items = {},
    lookup = {},
    active = false,
}
local kitPeds = {}
local kitDecor = "kitped_protect"

local code = "bruiser2"
local pedspawn = "s_m_y_marine_03"
local spawnedAlready = false 

function SpawnCar(hash, atCoords, atHeading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end 
    local veh = CreateVehicle(hash, atCoords, atHeading, false, false)
    SetVehicleCustomPrimaryColour(veh, 0, 0 ,0)
    SetVehicleCustomSecondaryColour(veh, 255,15,139)
    SetVehicleDirtLevel(veh, 0.0)
    Wait(500)
    FreezeEntityPosition(veh, true)
    SetBlockingOfNonTemporaryEvents(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleDoorsLocked(veh, 2)
    if not DecorIsRegisteredAsType(kitDecor, 2) then
        DecorRegister(kitDecor, 2)
    end
    DecorSetBool(veh, kitDecor, true)
    local vehEntity = Entity(veh)
    if vehEntity and vehEntity.state then
        vehEntity.state:set("isKitPedVehicle", true, true)
    end
    table.insert(entities, veh)
end

function SpawnPed(hash, atCoords, atHeading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end 
    local ped = CreatePed(0, hash, atCoords, atHeading, false, false)
    GiveWeaponToPed(ped, GetHashKey("WEAPON_MINIGUN"), 255, false, true)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MINIGUN"), true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    table.insert(entities, ped)
    table.insert(kitPeds, ped)
end


function SpawnTruck()
    if spawnedAlready then return end 
    spawnedAlready = true 
CreateThread(function()
    for k,v in pairs(entities) do 
        if DoesEntityExist(entities[k]) then DeleteEntity(entities[k])  end
    end
    for k,v in pairs(locations) do 
        if v.coords ~= nil then
            SpawnCar(GetHashKey(code), v.coords, v.heading)
        end
        SpawnPed(GetHashKey(pedspawn), v.pedcoords, v.pedheading)
    end
end) end Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 5) -- Check every 5 minutes
        if spawnedAlready then
            local allExist = true
            for _, entity in ipairs(entities) do
                if not DoesEntityExist(entity) then
                    allExist = false
                    break
                end
            end
            if not allExist then
                print("Some kitped entities were deleted, re-spawning.")
                spawnedAlready = false -- Allow re-spawning
                SpawnTruck()
            end
        end
    end
end)

local function drawPrompt(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function registerKitItems()
    if not Kits or not Item or not Item.Register or not API or not API.GiveItem or not DoKitStuff or not RegisteredItems then
        return false
    end

    if #kitShop.items > 0 then
        return true
    end

    local slot = 1
    for genre, kits in pairs(Kits) do
        
        for kitName, _ in pairs(kits) do
            local itemName = ("KIT_%s_%s"):format(string.upper(genre), string.upper(kitName))
            kitShop.lookup[itemName] = { genre = genre, kit = kitName }

            if not RegisteredItems[itemName] then
                Item.Register(itemName, {
                    func = function(item)
                        if Player.InVehicle() then return false end
                        local finished = exports["taskbar"]:taskBar({
                            length = 1000,
                            text = "Opening Kit",
                            animation = { dict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a" },
                            canShoot = true
                        })
                        if finished ~= 100 then return false end
                        DoKitStuff(genre, kitName)
                        API.RemoveItem(item, 1)
                        return true
                    end,
                })
            end

            kitShop.items[slot] = {
                item = itemName,
                quantity = 1,
                slot = slot,
                itemdata = {
                    item = itemName,
                    formatname = ("%s %s Kit"):format(genre:upper(), kitName:upper()),
                    description = "Drag this kit to your inventory and use it to equip the loadout.",
                    weight = 0.0,
                    stackable = false,
                    type = "kit",
                    image = ("kit_%s_%s"):format(genre:lower(), kitName:lower()),
                    genre = genre,
                    kit = kitName,
                }
            }
            slot = slot + 1
        end
    end

    return true
end

local function ensureKitAssets(forceRespawn)
    local missing = forceRespawn and true or false
    if not missing then
        for _, entity in ipairs(entities) do
            if not DoesEntityExist(entity) then
                missing = true
                break
            end
        end
    end

    if missing then
        spawnedAlready = false
        SpawnTruck()
    end
end

local function closeKitShop()
    kitShop.active = false
    TriggerEvent('zbrp:updateSecondInventory', {}, 0, {name = nil, hideHeader = true, showWeight = false})
end

function KitShopClose()
    closeKitShop()
end

local function openKitShop()
    if not registerKitItems() then return end
    kitShop.active = true
    if type(openInventory) == "function" then
        openInventory()
    else
        SendNUIMessage({ action = 'openInventory', isMale = IsPedMale(PlayerPedId()) })
    end
    TriggerEvent('zbrp:updateSecondInventory', kitShop.items, 1000, {name = nil, hideHeader = true, showWeight = false})
end

function KitShopTakeItem(index)
    if not kitShop.active then return end
    local idx = tonumber(index)
    if not idx then return end
    local item = kitShop.items[idx]
    if not item then return end
    API.GiveItem(item.item, 1)
end

function KitShopIsActive()
    return kitShop.active
end

CreateThread(function()
    while not registerKitItems() do
        Wait(250)
    end
    ensureKitAssets(true)
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearPed = false

        for _, ped in ipairs(kitPeds) do
            if DoesEntityExist(ped) then
                local dist = #(playerCoords - GetEntityCoords(ped))
                if dist < 10.0 then
                    nearPed = true
                    local closeEnough = dist <= 2.0
                    if closeEnough then
                        -- drawPrompt(GetEntityCoords(ped) + vector3(0.0, 0.0, 1.0), "[E] Open Kit Shop")
                    exports["gpvp-textui"]:showTextUI('kitped', 'Kit Shop', 'E') 
                    else
                        exports["gpvp-textui"]:hideTextUI('kitped')
                    end
                    if closeEnough and IsControlJustPressed(0, 38) then
                        openKitShop()
                    end
                end
            end
        end

        if not nearPed then
            Wait(500)
        end
    end
end)

AddEventHandler('drp:script:vehwipe', function()
    print("Attempted to wipe vehicles, refreshing kit assets.")
    Citizen.SetTimeout(1000, function()
        ensureKitAssets(true)
    end)
end)

RegisterNetEvent("kitpeds:ensure")
AddEventHandler("kitpeds:ensure", function()
    ensureKitAssets(false)
end)


RegisterNetEvent("zbrp:JoinedLobby", SpawnTruck)
