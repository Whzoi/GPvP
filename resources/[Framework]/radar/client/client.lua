local send_nui_message = SendNUIMessage

RegisterNetEvent('global:changeWatermark')
AddEventHandler('global:changeWatermark', function(lobbyName)
    send_nui_message({ type = "updateWatermark", value = lobbyName})
end)

-- Request player profile/stats shortly after load.
CreateThread(function()
    Wait(3000)
    TriggerServerEvent('radar:requestPlayerProfile')
end)

-- Receive profile payload from server and forward to lobby NUI.
RegisterNetEvent('radar:receivePlayerProfile', function(profile)
    if not profile then return end
    send_nui_message({
        action = "setPlayers",
        data = profile
    })
end)
