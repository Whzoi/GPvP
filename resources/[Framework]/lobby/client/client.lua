local PISTOL_LOBBY_ID = 2
local PISTOL_ONLY_WEAPONS = {
  `WEAPON_PISTOL_MK2`,
  `WEAPON_PISTOL50`,
  `WEAPON_HEAVYPISTOL`,
  `WEAPON_2011`,
  `WEAPON_SP45`,
  `WEAPON_COMBATPISTOL`,
  `WEAPON_VINTAGEPISTOL`,
  `WEAPON_USP45`,
  `WEAPON_1911`,
  `WEAPON_FNX45`,
  `WEAPON_GLOCK17`,
  `WEAPON_GLOCK18C`,
  `WEAPON_PISTOLXM3`,
  `WEAPON_CERAMICPISTOL`,
  `WEAPON_APPISTOL`,
}
local PISTOL_ONLY_WEAPON_WHITELIST = {}
for _, hash in ipairs(PISTOL_ONLY_WEAPONS) do
  PISTOL_ONLY_WEAPON_WHITELIST[hash] = true
end

LOBBY = {
  user_id = nil,
  user_level = 0,
  user_lobby = 0,
  currentLobbyID = 0,
  isPistolLobby = false,
  user_stats = {
      name = "",
      kills = 0,
      damage = 0,
  },
  NUI_OPEN = false,

  getCurrentLobbyID = function(self)
    return self.user_lobby
  end,

AddEventHandler('Erotic:LoadUser', function()
    -- SetSkin()
    TriggerEvent('clothing:checkIfNew')
    TriggerServerEvent('Erotic:SendUserID')
end),

  lobbyPage = function(self, shouldShow)
      SetNuiFocus(shouldShow, shouldShow)
      SendReactMessage('setVisible', shouldShow)

      self.NUI_OPEN = shouldShow

      SendReactMessage("SetActiveNavItem", "Servers")

      if shouldShow then
        -- exports['hud']:toggleNui(false)
        -- DoScreenFadeOut(0)
      elseif not shouldShow then
        Citizen.Wait(500)
        -- DoScreenFadeIn(100)
        -- exports['hud']:toggleNui(true)
      end
  end,

  LoadUser = function(self)
      lib:summonProps()
      TriggerServerEvent('Erotic:UpdateUserData:Server', self.user_id, self.user_level, self.user_lobby, self.user_stats)
      self:lobbyPage(true)
      TriggerServerEvent('Lobby:SetLobby', 1, self.user_id)
      debugPrint('LOADED', self.user_id)
  end,

  UpdateUserDataClient = function(self, userData)
      SendReactMessage('setPlayers', userData)
      
      self.user_id = userData.user_id
      self.user_lobby = userData.user_lobby
      self.user_stats = userData.user_stats
  end,

  LobbyUpdate = function(self, lobbies)
      SendReactMessage("setLobbies", lobbies)
  end,

  TeleportUser = function(self, x, y, z, heading)
    local playerPed = PlayerPedId()

    if playerPed and x and y and z and heading then
      SetEntityCoords(playerPed, x, y, z, false, false, false, true)
      SetEntityHeading(playerPed, heading)
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end
  end,

  LobbyJoin = function(self, data)
    local userID = data.user_id
    local PlayerId = PlayerPedId()
    local worldID = data.lobbyId

    self:lobbyPage(false)
    TriggerServerEvent('Lobby:SetLobby', worldID, userID)
  end,

  LobbyCreate = function(self, data)
    local lobbyMap = data.map
    local userid = LOBBY.user_id
    -- print(json.encode(data), "Data")
  
    LOBBY:lobbyPage(false)
  
    TriggerServerEvent('createLobby', data, userid, lobbyMap)
  end,

  InteractWithPed = function(self, ped)
    if not lib.spawnedAlready or #lib.entities == 0 then
      print('nil enititys on Interact Ped')
      return
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed, false)
    for _, pedEntity in pairs(lib.entities) do
      if DoesEntityExist(pedEntity) then
        local pedCoords = GetEntityCoords(pedEntity)
        if #(playerCoords - pedCoords) < 2.0 then
          LOBBY:lobbyPage(true)
          break
        end
      end
    end
  end,

  DrawInteractionMarker = function(self)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
  
    for _, pedEntity in pairs(lib.entities) do
      if DoesEntityExist(pedEntity) then
        local pedCoords = GetEntityCoords(pedEntity)
        if #(playerCoords - pedCoords) < 2.0 then
          local x, y, z = table.unpack(pedCoords)
          -- drawText3D(pedCoords + vector3(0.0, 0.0, 1.275), "E", 155, 160, 182, 255)
          DrawMarker(6, x, y, z + 1.2, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 155, 160, 182, 255, false, true, 2, false, false, false, false)
        end
      end
    end
  end,
}

Citizen.CreateThread(function()
  while true do
      if LOBBY.NUI_OPEN then
          Wait(1000)
      else
          local playerCoords = GetEntityCoords(PlayerPedId())
          local nearEntity = false

          for _, entity in pairs(lib.entities) do
              if entity and DoesEntityExist(entity) then
                  local entityCoords = GetEntityCoords(entity)
                  if #(playerCoords - entityCoords) < 2.0 then
                      nearEntity = true
                      LOBBY:DrawInteractionMarker()
                      Wait(0)
                      break
                  end
              end
          end

          if not nearEntity then
              Wait(1000)
          end
      end
  end
end)

RegisterCommand('-interactWithPed', function()
  LOBBY:InteractWithPed()
end, false)

RegisterKeyMapping('-interactWithPed', 'Interact with Ped', 'keyboard', 'E')

-- Helper function to enumerate vehicles
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
      local iter, id = initFunc()
      if not id or id == 0 then
          disposeFunc(iter)
          return
      end

      local enum = {handle = iter, destructor = disposeFunc}
      setmetatable(enum, {
          __gc = function()
              if enum.destructor and enum.handle then
                  enum.destructor(enum.handle)
              end
              enum.destructor = nil
              enum.handle = nil
          end
      })

      local next = true
      repeat
          coroutine.yield(id)
          next, id = moveFunc(iter)
      until not next

      enum.destructor, enum.handle = nil, nil
      disposeFunc(iter)
  end)
end

local function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

-- Function to check if vehicle has any players inside
local function HasPlayerInVehicle(vehicle)
  if not DoesEntityExist(vehicle) then
    return false
  end
  
  -- Check driver seat (-1)
  local ped = GetPedInVehicleSeat(vehicle, -1)
  if ped ~= 0 and IsPedAPlayer(ped) then
    return true
  end
  
  -- Check all passenger seats
  local maxPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
  for seat = 0, maxPassengers do
    ped = GetPedInVehicleSeat(vehicle, seat)
    if ped ~= 0 and IsPedAPlayer(ped) then
      return true
    end
  end
  
  return false
end

-- /dvall command - deletes all vehicles without players inside (only in custom lobbies)
RegisterCommand('dvall', function()
  -- Check if user is in a custom lobby (user_lobby > 1)
  if LOBBY.user_lobby <= 1 then
    TriggerEvent('chat:addMessage', {
      color = {255, 0, 0},
      args = {'System', 'This command can only be used in custom lobbies!'}
    })
    return
  end
  
  local deletedCount = 0
  
  -- Enumerate and delete all vehicles without players
  for vehicle in EnumerateVehicles() do
    if DoesEntityExist(vehicle) and not HasPlayerInVehicle(vehicle) then
      SetVehicleHasBeenOwnedByPlayer(vehicle, false)
      SetEntityAsMissionEntity(vehicle, false, false)
      DeleteVehicle(vehicle)
      if DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
      end
      deletedCount = deletedCount + 1
    end
  end
  
  TriggerEvent('chat:addMessage', {
    color = {0, 255, 0},
    args = {'System', 'Deleted ' .. deletedCount .. ' empty vehicle(s).'}
  })
end, false)

RegisterNUICallback('hideFrame', function(_, cb)
  LOBBY:lobbyPage(false)
  TriggerEvent('closeClothingMenu')
  debugPrint('Hide NUI frame')
  cb({})
end)

RegisterNetEvent('Erotic:ReceiveUserID')
AddEventHandler('Erotic:ReceiveUserID', function(user_id)
    LOBBY.user_id = user_id

    LOBBY.user_level = 0
    LOBBY.user_lobby = 0
    LOBBY.user_stats = {
        name = GetPlayerName(PlayerId()),
        kills = 0,
        damage = 0,
    }
    LOBBY.NUI_OPEN = false

    Citizen.Wait(1)

    LOBBY:LoadUser()
end)



RegisterNetEvent('Erotic:UnloadUser')
AddEventHandler('Erotic:UnloadUser', function()
    LOBBY.user_id = nil
    LOBBY.user_level = 0
    LOBBY.user_lobby = 0
    LOBBY.user_stats = { name = "", kills = 0, damage = 0 }
    LOBBY.NUI_OPEN = false

    print('User data unloaded')
end)

RegisterNetEvent('User:Teleport')
AddEventHandler('User:Teleport', function(...)
  LOBBY:TeleportUser(...)
end)

RegisterNetEvent('Erotic:UpdateUserData:Client')
AddEventHandler('Erotic:UpdateUserData:Client', function(...)
  LOBBY:UpdateUserDataClient(...)
end)

RegisterNetEvent("Lobby:Update")
AddEventHandler("Lobby:Update", function(...)
  LOBBY:LobbyUpdate(...)
end)

RegisterNUICallback('Lobby:Join', function(data, cb)
  LOBBY:LobbyJoin(data)
  cb({ success = true })
end)

RegisterNUICallback('Lobby:Create', function(data, cb)
  LOBBY:LobbyCreate(data)
  cb({ success = true })
end)

RegisterNUICallback('Page:Join', function(data, cb)
  if data and data.page then
    -- print('Joined page: ' .. tostring(data.page))  -- Use print instead of debugPrint for testing
    -- if data.page == "Locker" then

    --   SendReactMessage("toggleBackgroundImage", false)
    --   SendClothingDataToNUI()
    --   TriggerEvent('openClothingMenu')
    -- end
  else
    print('Joined page: Unknown')  -- Use print instead of debugPrint for testing
  end
  cb({ success = true })
end)

RegisterNUICallback('Page:Leave', function(data, cb)
  if data and data.page then
    -- print('Left page: ' .. tostring(data.page))  -- Use print instead of debugPrint for testing
    -- if data.page == "Locker" then

    --   SendReactMessage("toggleBackgroundImage", true)
    --   TriggerEvent('closeClothingMenu')
    -- end
  else
    print('Left page: Unknown')  -- Use print instead of debugPrint for testing
  end
  cb({ success = true })
end)

RegisterNetEvent('Erotic:SetLobbySettings')
AddEventHandler('Erotic:SetLobbySettings', function(lobbyID, settings)
    LOBBY.currentLobbySettings = settings
    LOBBY.currentLobbyID = lobbyID or 0
    LOBBY.isPistolLobby = (lobbyID == PISTOL_LOBBY_ID)
    -- print("Received lobby settings for lobby ID: " .. lobbyID)
    local LobbySettings = settings

    if LobbySettings then
      if LOBBY.isPistolLobby then
        exports['inventory']:DoKitStuff('pistols', 'pistolmk2')
      else
        exports['inventory']:DoKitStuff('ars', 'hopout')
      end
      exports['gamesettings']:spawningcars(false or LobbySettings.spawningcars == nil, LobbySettings.onlyInSafezone or false)

      exports['gamesettings']:setHelmetsEnabled(LobbySettings.Helmets or false)
      exports['gamesettings']:setspeedBoostingOff(LobbySettings.SpeedBoosting or true)
      exports['gamesettings']:setCarRagdoll(LobbySettings.noRagdoll or false)
      exports['gamesettings']:SetRecoilMode(LobbySettings.recoilMode or "roleplay")
      exports['gamesettings']:SetIntenseCamEnabled(LobbySettings.recoilMode == "gpvp")
      exports['gamesettings']:setFirstPersonVehicleEnabled(LobbySettings.firstPersonVehicle or false)
      exports['gamesettings']:setHsMulti(LobbySettings.hsMulti or false)
      exports['gamesettings']:disableFirstPerson(LobbySettings.disableFP or false)
      exports['gamesettings']:setCarRagdoll(LobbySettings.setCarRagdoll or false)
      exports['gamesettings']:disableLadderClimbing(LobbySettings.disableLadders or false)
      exports['gamesettings']:disableQPeeking(LobbySettings.disableQPeeking or false)
      exports['gamesettings']:disableRoofs(LobbySettings.disableHighRoofs or false)
      exports['core']:safezoneDelay(LobbySettings.safezoneDelay or false)
      exports['gamesettings']:enableSkeletons(LobbySettings.skeletons or false)
      SetWeaponsNoAimBlocking(LobbySettings.barrelStuffing or false)
      SetWeaponsNoAutoreload(LobbySettings.noAutoReload or false)
    else
      print("Nil Settings shitty booty script broke")
    end
end)

exports('GetCurrentLobbyID', function()
  return LOBBY:getCurrentLobbyID()
end)

Citizen.CreateThread(function()
  while true do
    if LOBBY.isPistolLobby then
      local ped = PlayerPedId()
      if DoesEntityExist(ped) and not IsEntityDead(ped) then
        local currentWeapon = GetSelectedPedWeapon(ped)
        if currentWeapon ~= `WEAPON_UNARMED` and not PISTOL_ONLY_WEAPON_WHITELIST[currentWeapon] then
          RemoveWeaponFromPed(ped, currentWeapon)
          SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
      end
      Wait(500)
    else
      Wait(1000)
    end
  end
end)
