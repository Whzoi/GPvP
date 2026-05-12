local namesOn = false
local noClipOn = false
local skeletonsEnabled = false
local isVisible = true

local function thread()
	while true do
		Wait(0)

		if namesOn or noClipOn or skeletonsEnabled or not isVisible then
			DisablePlayerFiring(PlayerId(), true)
		end
	end
end

local function invisible()
	if isVisible then
--		exports["ox_lib"]:SendAlert("error", "Invisibility Disabled", 5000)
		SetEntityVisible(PlayerPedId(), true)
		SetEntityAlpha(PlayerPedId(), 255, false)
	else
--		exports["ox_lib"]:SendAlert("success", "Invisibility Enabled", 5000)
	end
	while not isVisible do
		SetEntityVisible(PlayerPedId(), false)
		SetEntityAlpha(PlayerPedId(), 0, false)
		Wait(0)
	end
end

RegisterNetEvent("txcl:showPlayerIDs", function(enabled)
	namesOn = enabled

	if namesOn then
		CreateThread(thread)
	end
end)

RegisterNetEvent("txcl:setPlayerMode", function(mode, enabled)
	if mode == "noclip" then
--		exports["ox_lib"]:SendAlert("success", "Noclip Enabled", 5000)
 	 exports['notifications']:SendAlert('success', 'Toggled Noclip', 1500)

		noClipOn = enabled
	elseif mode == "none" then
--		exports["ox_lib"]:SendAlert("error", "Noclip Disabled", 5000)
 	 exports['notifications']:SendAlert('error', 'Toggled Noclip', 1500)

		noClipOn = false
		return
	end

	noClipOn = enabled
end)


--RegisterNetEvent("zbpvp:admin:Invis", function()
--	isVisible = not isVisible
--	CreateThread(invisible)
--end)
