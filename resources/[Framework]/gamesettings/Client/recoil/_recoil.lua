---@diagnostic disable: param-type-mismatch, undefined-global

Recoil = {
    modes = {},
    activeMode = false,
    onResetCallbacks = {}
}

function Recoil:SetMode(mode)
    if type(mode) == "string" and mode:lower() == "disabled" then mode = false end
    assert(not mode or self.modes[mode], 'Mode ' .. tostring(mode) .. ' is not registered')
    self.activeMode = mode
    for _, v in pairs(self.onResetCallbacks) do
        v(mode)
    end
end

exports("setRecoilMode", function(mode)
    Recoil:SetMode(mode)
end)

function Recoil:RegisterMode(modeName, onTickCallback)
    assert(not self.modes[modeName], 'Mode ' .. tostring(modeName) .. ' is already registered')
    self.modes[modeName] = { callback = onTickCallback }
end

function Recoil:GetModes(includeDisabled)
    local modes = {}
    if includeDisabled then modes[1] = "DISABLED" end
    for modeName, _ in pairs(self.modes) do
        table.insert(modes, modeName)
    end
    return modes
end

function Recoil:OnModeChange(cb)
    if not self.onResetCallbacks then
        self.onResetCallbacks = {}
    end
    table.insert(self.onResetCallbacks, cb)
end

CreateThread(function()
    while true do
        Wait(1)
        if Recoil.activeMode and Recoil.modes[Recoil.activeMode] then
            Recoil.modes[Recoil.activeMode].callback(Recoil.activeMode)
        end
    end
end)

local recoilModes = {
    DISABLED = { commands = { "DISABLED" } },
    nonstop = { commands = { "nonstop" } },
    hardcore = { commands = { "hardcore" } },
    qb = { commands = { "qb" } },
    pma = { commands = { "pma" } },
    roleplay = { commands = { "roleplay" } },
    roleplay2 = { commands = { "roleplay2" } },
    roleplay3 = { commands = { "roleplay3" } },
    envy = { commands = { "envy" } },
    cmplx = { commands = { "cmplx" } },
}

function SetRecoilMode(player, mode)
    mode = mode:lower()
    if not recoilModes[mode] then return end
    Recoil:SetMode(mode)
end

RegisterNetEvent('settings:ChangeRecoilMode', function(mode)
    SetRecoilMode(source, mode)
end)

exports('SetRecoilMode', function(mode)
    SetRecoilMode(source, mode)
end)

Recoil:RegisterMode("nonstop", function() end)
Recoil:RegisterMode("hardcore", function() end)
Recoil:RegisterMode("qb", function() end)
Recoil:RegisterMode("pma", function() end)
Recoil:RegisterMode("roleplay", function() end)
Recoil:RegisterMode("roleplay2", function() end)
Recoil:RegisterMode("roleplay3", function() end)
Recoil:RegisterMode("envy", function() end)
Recoil:RegisterMode("cmplx", function() end)
Recoil:RegisterMode("disabled", function() end)

CreateThread(function()
    Wait(1000)
    Recoil:SetMode("envy")
end)

table.keys = function(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end
