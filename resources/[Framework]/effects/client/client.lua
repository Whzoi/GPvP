local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterCommand('show-nui', function()
  SendUpdateTimeToNUI(time)
  toggleNuiFrame(true)
  debugPrint('Show NUI frame')
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

RegisterCommand('+effects_menu', function()
  toggleNuiFrame(true)
end)

RegisterCommand('settings', function()
  toggleNuiFrame(true)
end)

RegisterKeyMapping('+effects_menu', 'Open Graphics Menu', 'keyboard', 'f1')