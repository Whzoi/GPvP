local function SetWeaponDrops()
  local handle, ped = FindFirstPed()
  local finished = false

  repeat
      if not IsEntityDead(ped) then
          SetPedDropsWeaponsWhenDead(ped, false)
      end
      finished, ped = FindNextPed(handle)
  until not finished

  EndFindPed(handle)
end

local function DisableDispatch()
  for i = 1, 12 do
      EnableDispatchService(i, false)
  end
  local playerId = PlayerId()
  SetPlayerWantedLevel(playerId, 0, false)
  SetPlayerWantedLevelNow(playerId, false)
  SetPlayerWantedLevelNoDrop(playerId, 0, false)
end

local function DisableWeaponControls()
  local ped = PlayerPedId()
  if IsPedArmed(ped, 6) then
      DisableControlAction(1, 140, true)
      DisableControlAction(1, 141, true)
      DisableControlAction(1, 142, true)
  end
end

local function RemoveVehiclesFromArea(x, y, z, range)
  RemoveVehiclesFromGeneratorsInArea(x - range, y - range, z - range, x + range, y + range, z + range)
end

local function InitializeVehicleRemovals()
  local removalAreas = {
      {335.2616, -1432.455, 46.51, 300.0},
      {441.8465, -987.99, 30.68, 500.0},
      {316.79, -592.36, 43.28, 300.0},
      {-2150.44, 3075.99, 32.8, 500.0},
      {-1108.35, 4920.64, 217.2, 300.0},
      {-458.24, 6019.81, 31.34, 300.0},
      {1854.82, 3679.4, 33.82, 300.0},
      {-724.46, -1444.03, 5.0, 300.0}
  }

  for _, area in ipairs(removalAreas) do
      RemoveVehiclesFromArea(table.unpack(area))
  end
end

CreateThread(function() -- Drops
  while true do
      Wait(1000)
      SetWeaponDrops()
  end
end)

CreateThread(function() -- Disable Dispatch and Weapon Controls
  -- Dispatch can be disabled once at start.
  DisableDispatch()
  while true do
      Wait(150)
      DisableWeaponControls()
  end
end)

CreateThread(function() -- Audio and Vehicle Initialization
  SetAudioFlag("PoliceScannerDisabled", true)
  DistantCopCarSirens(false)
  DisableVehicleDistantlights(true)
  InitializeVehicleRemovals()
end)
