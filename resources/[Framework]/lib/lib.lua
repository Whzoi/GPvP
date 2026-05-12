if not _VERSION:find('5.4') then
	error('^1Lua 5.4 must be enabled in the resource manifest!^0', 2)
end

local lib = {}

lib.spawnedAlready = false
_G.lib = lib

lib.entities = {}

lib.Config = { 
    Props = {
    southside = {
        pedcoords = vector3(215.9673, -1388.8949, 29.59),
        pedheading = 321.6726,
        pedspawn = "a_m_m_acult_01",
        blip = {
          color = 13,
          sprite = 40,
          text = "Morgue Menu",
          name = "menu"
        }
      },
      littleseoul = {
          pedcoords = vector3(-892.2238, -854.3285, 19.5661),
          pedheading = 283.7997,
          pedspawn = "a_m_m_acult_01",
          blip = {
            color = 13,
            sprite = 40,
            text = "Southside2 Park Menu",
            name = "menu"
          }
        },
      mirrorpark = {
          pedcoords = vector3(1046.2018, -769.8401, 57.0109),
          pedheading = 150.6649,
          pedspawn = "a_m_m_acult_01",
          blip = {
            color = 13,
            sprite = 40,
            text = "Mirror Park Menu",
            name = "menu"
          }
        },
        sandy = {
          pedcoords = vector3(1982.0719, 3706.9614, 31.2250),
          pedheading = 150.6649,
          pedspawn = "a_f_y_scdressy_01",
          blip = {
            color = 13,
            sprite = 40,
            text = "Sandy Menu",
            name = "menu"
          }
        },
        vinewood = {
          pedcoords = vector3(69.1803, 127.7612, 78.2140),
          pedheading = 164.1864,
          pedspawn = "mp_g_m_pros_01",
          blip = {
            color = 13,
            sprite = 40,
            text = "Sandy Menu",
            name = "menu"
          }
        },

        -- 69.1803, 127.7612, 79.2140, 164.1864
     morningwood = {
          pedcoords = vector3(-1157.7400, -219.3678, 36.9600),
          pedheading = 240.6188,
          pedspawn = "a_m_o_soucent_03",
          blip = {
            color = 13,
            sprite = 40,
            text = "Morningwood Menu",
            name = "menu"
          }
        },
    }
}

function lib:CreatePed(hash, atCoords, atHeading, blipSettings)
    RequestModel(hash)
    local pedweapon = GetHashKey("WEAPON_CARBINERIFLE_MK2")
    while not HasModelLoaded(hash) do Citizen.Wait(0) end
    local ped = CreatePed(0, hash, atCoords.x, atCoords.y, atCoords.z, atHeading, false, false)
    GiveWeaponToPed(ped, pedweapon, 0, false, true)
    SetCurrentPedWeapon(ped, pedweapon, true)
    SetPedWeaponTintIndex(ped, pedweapon, math.random(0, 32))
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    table.insert(self.entities, ped)

    self:CreateBlipOnEntity(ped, blipSettings)
end

function lib:summonProps()
    if self.spawnedAlready then return end
    self.spawnedAlready = true

    CreateThread(function()
        for _, entity in ipairs(self.entities) do
            if DoesEntityExist(entity) then 
                DeleteEntity(entity) 
            end
        end

        self.entities = {}

        for propName, prop in pairs(self.Config.Props) do
            local blipSettings = prop.blip
            self:CreatePed(GetHashKey(prop.pedspawn), prop.pedcoords, prop.pedheading, blipSettings)
        end
    end)
end

function lib:CreateBlipOnEntity(ped, blipSettings)
    if blipSettings then
        local blip = AddBlipForEntity(ped)
        SetBlipSprite(blip, blipSettings.sprite)
        SetBlipColour(blip, blipSettings.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(blipSettings.text)
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 4)
    else
        print('nil settings')
    end
end

-- function lib:DrawText3D(coords, text, colourData)
--     colourData = colourData or { 155, 160, 182, 255 }
--     local size = 4
--     local font = 4
--     local scale = 1
--     SetTextScale(0.0 * scale, 0.55 * scale)
--     SetTextFont(font)
--     SetTextColour(255, 255, 255, 255)
--     SetTextDropshadow(255, 255, 255, 255, 255)
--     SetTextDropShadow()
--     SetTextCentre(true)
--     SetTextProportional(1)
--     SetDrawOrigin(coords, 0)
--     BeginTextCommandDisplayText('STRING')
--     AddTextComponentSubstringPlayerName(text)
--     EndTextCommandDisplayText(0.0, 0.0)
--     ClearDrawOrigin()
-- end

-- function lib:TeleportUser(self, x, y, z, heading)
--     local playerPed = PlayerPedId()

--     if playerPed and x and y and z and heading then
--       SetEntityCoords(playerPed, x, y, z, false, false, false, true)
--       SetEntityHeading(playerPed, heading)
--       SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
--     end
-- end

function lib:notify(playerId, message, length, type)
    -- Implement notification logic here
end

return lib
