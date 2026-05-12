local hudColours = {
    red = 6,
    blue = 9,
    yellow = 12,
    orange = 15,
    green = 18,
    pink = 30,
    purple = 29,
    cyan = 211,
    lime = 210,
    yellow_light = 13,
    white = 0,
}

local killEffectOptions = {
    {"White Flash (Default)", "FocusOut", "white", 1},
    {"Red Flash", "CrossLineOut", "red", 2},
    {"Green Flash", "MinigameEndFranklin", "green", 3},
    {"Blue Flash", "MinigameEndMichael", "blue", 4},
    {"Yellow Flash", "HeistLocate", "yellow_light", 5},
    {"Cyan Flash", "MP_SmugglerCheckpoint", "cyan", 6},
    {"Orange Flash", "PPOrangeOut", "orange", 7},
    {"Lime Flash", "PPGreenOut", "lime", 8},
    {"Pink Flash", "PPPinkOut", "pink", 9},
    {"Purple Flash", "PPPurpleOut", "purple", 10},
    {"Pink Short Flash", "TinyRacerPinkOut", "pink", 11},
    {"White Long Flash", "MP_Celeb_Lose_Out", "white", 12},
    {"Green Long Flash", "MP_Celeb_Preload_Fade", "green", 13},
    {"Orange Long Flash", "MP_Celeb_Win_Out", "orange", 14},
    {"Yellow Long Flash", "MP_corona_switch", "yellow", 15},
    {"Blue Long Flash", "WeaponUpgrade", "blue", 16},
    {"Green Fuzzy", "DefaultFlash", "green", 17},
    {"Red Lightning", "LostTimeDay", "red", 18},
    {"Peyote", "PeyoteOut", "pink", 19},
    {"Rampage", "RampageOut", "red", 20},
}

-- Create a lookup table to map effect names to their options
local effectIndexToOptions = {}
for index, option in ipairs(killEffectOptions) do
    effectIndexToOptions[index] = option
end

local killEffect = {
    name = "Kill Effect",
    options = {},
    selected = GetResourceKvpInt("graphics_killEffect-gpvp") or 1,
    onChange = function(self)
        if not effectIndexToOptions[self.selected] then
            self.selected = 1 -- Default to the first option if the selected effect index is invalid
        end
        SetResourceKvpInt("graphics_killEffect-gpvp", self.selected)
        playSelectedKillEffect()
    end,
}

for _, option in pairs(killEffectOptions) do
    table.insert(killEffect.options, option[1])
end

function playKillEffect(name)
    AnimpostfxStop(name)
    AnimpostfxPlay(name, 500, false)
end

function playSelectedKillEffect()
    local effectOption = effectIndexToOptions[killEffect.selected]
    if effectOption then
        local _, postFxName, hudColour = table.unpack(effectOption)
        playKillEffect(postFxName)
        FlashMinimapDisplayWithColor(hudColours[hudColour])
    else
        print("Error: Invalid kill effect selected.")
    end
end

-- Register a command to change the kill effect option by index
-- RegisterCommand('setkillEffect', function(source, args)
--     if #args == 1 then
--         local effectIndex = tonumber(args[1])
--         if effectIndexToOptions[effectIndex] then
--             killEffect.selected = effectIndex
--             killEffect:onChange()
--             -- Inform the user about the change
--             TriggerEvent('chat:addMessage', { args = { 'Kill Effect', 'Kill effect set to: ' .. effectIndexToOptions[effectIndex][1] } })
--         else
--             TriggerEvent('chat:addMessage', { args = { 'Kill Effect', 'Invalid kill effect option: ' .. effectIndex } })
--         end
--     else
--         TriggerEvent('chat:addMessage', { args = { 'Kill Effect', 'Usage: /setkillEffect <effectIndex>' } })
--     end
-- end, false)

-- -- Command handler for displaying the available kill effect options
-- RegisterCommand('showkillEffects', function(source, args)
--     TriggerEvent('chat:addMessage', { args = { 'Kill Effect Options', 'Available kill effects:' } })
--     for index, option in pairs(killEffectOptions) do
--         TriggerEvent('chat:addMessage', { args = { 'Kill Effect', index .. ": " .. option[1] .. " (" .. option[3] .. ")" } })
--     end
-- end, false)

-- Event handler for triggering the kill effect
RegisterNetEvent('effects:TriggerKillEffect')
AddEventHandler('effects:TriggerKillEffect', function()
    local savedEffect = GetResourceKvpInt("graphics_killEffect-gpvp") or 1

    if savedEffect == 0 then
        savedEffect = 1
    end

    if effectIndexToOptions[savedEffect] then
        killEffect.selected = savedEffect
        playSelectedKillEffect()
    else
        print("Error: Invalid kill effect option: " .. savedEffect)
    end
end)

RegisterNUICallback('getKillEffectSettings', function(data, cb)
    local killEffectsData = {}
    for index, option in ipairs(killEffectOptions) do
        table.insert(killEffectsData, { name = option[1], value = index })
    end
    cb(killEffectsData)
end)

RegisterNUICallback('killEffect:changeEffect', function(data, cb)
    local effectIndex = tonumber(data.effectIndex)
    effectIndex = effectIndex + 1

    if effectIndexToOptions[effectIndex] then
        SetResourceKvpInt("graphics_killEffect-gpvp", effectIndex)
        killEffect.selected = effectIndex
        killEffect:onChange()
        cb({ status = "success" })
    else
        cb({ status = "error", message = "Invalid effect index" })
    end
end)
