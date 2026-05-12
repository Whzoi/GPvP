local CAR_LIST = {
    [1] = {
        ['model'] = 'Revolter',
        ['image'] = 'https://cdn.global-rp.com/i/3741e47f7530ee4b7c5e7d592e20c62d.webp',
    },
    [2] = {
        ['model'] = 'issi7',
        ['image'] = 'https://cdn.global-rp.com/i/63ac5dd7024e8e922c7a00bc5637ae9b.webp',
    },
    [3] = {
        ['model'] = 'cyclone',
        ['image'] = 'https://cdn.global-rp.com/i/3263073800bc7831d736d2f8293a2cde.webp',
    },
    [4] = {
        ['model'] = 'omnisegt',
        ['image'] = 'https://cdn.global-rp.com/i/856503a38fd76cdf56795be2ef0b747a.png',
    },
    [5] = {
        ['model'] = 'jester',
        ['image'] = 'https://cdn.global-rp.com/i/2acf2968c5f1bd9118932294e447c5b1.webp',
    },
    [6] = {
        ['model'] = 'bf400',
        ['image'] = 'https://cdn.global-rp.com/i/1db5a9e85a52598ae4d811b59e556dd8.webp',
    },
    [7] = {
        ['model'] = 'powersurge',
        ['image'] = 'https://cdn.global-rp.com/i/40b5e3203c419fda3f2c23dafa1f2c4a.webp',
    },
    [8] = {
        ['model'] = 'sultan',
        ['image'] = 'https://cdn.global-rp.com/i/4cc39acdc599c781734714f7daed0fa8.webp',
    },
    [9] = {
        ['model'] = 'nwkuruma',
        ['image'] = 'https://cdn.global-rp.com/i/2555241164d5da3d1c8b1fadccb2680b.png',
    },

}

local backgroundActive = false
local function background()
    Citizen.CreateThread(function()
        while backgroundActive do
            Citizen.Wait()
            DrawSprite("", "", 0.5, 0.5, 1.0, 1.0, 0, 144, 138, 255, 100)
        end
    end)
end

local function toggleNuiFrame(shouldShow)
    if shouldShow then
        TriggerScreenblurFadeIn(50)
    else
        TriggerScreenblurFadeOut(50)
    end
    backgroundActive = shouldShow
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)
end

RegisterCommand('show-nui', function()
    toggleNuiFrame(true)
    debugPrint('Show NUI frame')
end)

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    debugPrint('Hide NUI frame')
    cb({})
end)

RegisterCommand('+car_menu', function()
    toggleNuiFrame(true)
    background()
end)

RegisterNUICallback('carspawner:spawnVehicle', function(data, cb)
    toggleNuiFrame(false)
    TriggerEvent('drp:spawnvehicle', data.model)
    cb({})
end)

RegisterNUICallback('getCarData', function(data, cb)
    cb(CAR_LIST)
end)

RegisterKeyMapping('+car_menu', 'Open Car Menu', 'keyboard', 'm')