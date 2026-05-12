config = {}

config.weather = {
    StartWeather = GetConvar("core_startingWeather", "EXTRASUNNY"),
    BaseTime = 8,
    TimeOffset = 0,
    FreezeTime = false,
}

local Weathers = {
    ["Neonsky"] = "FOGGY",
    ["Redsky"] = "OVERCAST",
    ["Noday"] = "NEUTRAL",
    ["Variable"] = "SMOG",
    ["Greysky"] = "CLEAR",
    ["Sunrise"] = "CLOUDS",
    ["Realism"] = "CLEARING",
    ["Xmas"] = "XMAS",
    ["Snow"] = "SNOWLIGHT",
    ["Blizzard"] = "BLIZZARD",
    ["Default"] = "EXTRASUNNY",
}


RegisterNUICallback('getWeatherSettings', function(data, cb)
    cb(Weathers)
end)

local weather = "EXTRASUNNY"
local baseTime = config.weather.BaseTime
local timeOffset = config.weather.TimeOffset
local timer = 0
local freezeTime = config.weather.FreezeTime
local runTimeSync = true
local overrideTime = { 12, 00 }

function setWeather(newWeather) -- Define the setWeather function
    if not newWeather then
        weather = "EXTRASUNNY"
        return
    end
    
    weather = newWeather
end


exports("getWeather", function()
    return weather
end)

local clear_override_weather = ClearOverrideWeather
local clear_weather_type_persist = ClearWeatherTypePersist
local set_weather_type_persist = SetWeatherTypePersist
local set_weather_type_now = SetWeatherTypeNow
local set_weather_type_now_persist = SetWeatherTypeNowPersist
local set_force_vehicle_trails = SetForceVehicleTrails
local set_force_ped_footsteps_track = SetForcePedFootstepsTracks
local wait = Wait

CreateThread(function()
    while true do
        wait(1000)
        clear_override_weather()
        clear_weather_type_persist()
        set_weather_type_persist(weather)
        set_weather_type_now(weather)
        set_weather_type_now_persist(weather)
        
        set_force_vehicle_trails(weather == 'XMAS')
        set_force_ped_footsteps_track(weather == 'XMAS')
    end
end)

function ChangeWeather(customName)
    local selectedWeather = Weathers[customName]
    
    if selectedWeather then
        setWeather(selectedWeather)
        -- print("Weather changed to:", selectedWeather)
    else
        -- print("Invalid weather name:", customName)
    end
end

RegisterNetEvent('set-weather')
AddEventHandler('set-weather', function(params)
    local customName = params.type
    local selectedWeather = Weathers[customName]
    
    if selectedWeather then
        SetResourceKvp("graphics_weather-gpvp", customName)
        -- print('KVP loaded:', customName)
        ChangeWeather(customName)
    else
        -- print("Invalid weather type.")
    end
end)

AddEventHandler('Erotic:LoadUser', function()
    local kvpValue = GetResourceKvpString("graphics_weather-gpvp")
    
    if kvpValue then
        -- print('KVP loaded:', kvpValue)
        ChangeWeather(kvpValue)
    else
        -- print("Player does not have KVP.")
    end
end)

RegisterNUICallback('getCurrentWeatherIndex', function(data, cb)
    cb(GetResourceKvpString("ggraphics_weather-gpvp") or "Default")
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local kvpValue = GetResourceKvpString("graphics_weather-gpvp")
        
        if kvpValue then
            print("Resource started. Player has KVP:", kvpValue)
            print('KVP loaded:', kvpValue)
            ChangeWeather(kvpValue)
        else
            print("Resource started. Player does not have KVP.")
        end
    end
end)

RegisterNUICallback('weather:changeEffect', function(data, cb)
    local weatherType = data.type
    local selectedWeather = Weathers[weatherType]
    
    if selectedWeather then
        SetResourceKvp("graphics_weather-gpvp", weatherType)
        TriggerEvent("set-weather", { type = weatherType })
    else
        print("Invalid weather type:", weatherType)
    end
end)