local kvpValue = tonumber(GetResourceKvpString("graphics_time-gpvp")) or 900
local timeOffset = 0
local timer = 0
local freezeTime = true
local currentTime = kvpValue or 900

AddEventHandler('Erotic:LoadUser', function()
    SetGameTime(currentTime)
end)

RegisterNUICallback('effects:setTime', function(data, cb)
    local hour = tonumber(data.hour)
    if hour ~= nil and hour % 1 == 0 and hour >= 0 and hour <= 24 then
        currentTime = hour * 100
        SetGameTime(currentTime)
        -- SendUpdateTimeToNUI(currentTime /100)
    end
    cb(hour)
end)

function SendUpdateTimeToNUI(time)
    SendNUIMessage({
        type = "updateTime",
        time = time
    })
end

function SetGameTime(currentTime)
    NetworkOverrideClockTime(currentTime, 0, 0)
    SetResourceKvp("graphics_time-gpvp", tostring(currentTime))
end

RegisterNUICallback('getCurrentTimeSettings', function(data, cb)
    local CurrentTimeNow = tonumber(GetResourceKvpString("graphics_time-gpvp")) or 900
    -- Ensure CurrentTimeNow is within the range of 0 to 2400
    local clampedTime = math.min(math.max(CurrentTimeNow, 0), 2400)
    -- Convert the time to a whole number between 0 and 24
    local currentTimeInHours = math.floor(clampedTime / 100)
    cb(currentTimeInHours)
end)

RegisterNUICallback('getTimeSettings', function(data, cb)
    local timeSettings = {}
    for i = 0, 24 do
        table.insert(timeSettings, i)
    end
    cb(timeSettings)
end)

RegisterCommand("freezetime", function(source, args)
    freezeTime = not freezeTime
end, false)

CreateThread(function()
    while true do
        Wait(0)
        local newBaseTime = currentTime

        if GetGameTimer() - 500 > timer then
          newBaseTime = newBaseTime + 0.25
          timer = GetGameTimer()
        end
        if freezeTime then
          timeOffset = timeOffset + currentTime - newBaseTime
        end
        currentTime = newBaseTime

        hour = math.floor(((currentTime + timeOffset) / 60) % 24)
        NetworkOverrideClockTime(hour, 0, 0)
    end
end)
