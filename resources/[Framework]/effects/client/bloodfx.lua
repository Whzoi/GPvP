local effects = {
    Confetti = "ent_dst_inflate_ball_clr",
    Hatchet = "td_blood_hatchet_back",
    Gumball = "ent_dst_gen_gobstop",
    Cash = "ent_brk_banknotes",
    Mud = "bang_mud",
    Metal = "bang_metal",
    Rocks = "ent_dst_rocks",
    Coins = "ent_brk_coins",
    Glass = "ent_dst_glass_bottles",
    Eletric = "ent_amb_elec_crackle_sp",
    Feathers = "ent_sht_feathers",
    BiggerBlood = "blood_wheel",
    Default = "blood_entry",
    Smoke = "blood_armour",
    Spark = "ent_brk_metal_frag"
}

RegisterNUICallback('getBloodFx', function(data, cb)
    cb(effects)
end)

RegisterNetEvent("core:bloodfx:change")
AddEventHandler("core:bloodfx:change", function(effectName)
    local particleDictionary = "core"

    local bloodfx = "blood_entry"

    local ped = PlayerPedId()

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end

    local particleName = effects[effectName] or effects["Default"]

    UseParticleFxAssetNextCall(particleDictionary)
    ResetParticleFxOverride(bloodfx)
    SetParticleFxOverride(bloodfx, particleName)
    StartParticleFxNonLoopedOnPedBone(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 31086, 1.0, false, false, false)

    Citizen.Wait(1000)

    RemoveNamedPtfxAsset("core")
end)

RegisterNUICallback('blood:changeEffect-gpvp', function(data, cb)
    local effectName = data.effectName
    local particleName = effects[effectName] or effects["Default"]
    
    if particleName then
        SetResourceKvp("graphics_bloodfx-gpvp", effectName)
        TriggerEvent("core:bloodfx:change-gpvp", effectName)
    else
        print("Invalid bloodfx type.")
    end
    -- print(json.encode(effectName))
end)

AddEventHandler('Erotic:LoadUser', function()
    local kvpValue = GetResourceKvpString("graphics_bloodfx-gpvp")
    if kvpValue then
        TriggerEvent("core:bloodfx:change", kvpValue)
    end
end)

RegisterNUICallback('getCurrentEffectSettings', function(data, cb)
    local CurrentBloodNow = GetResourceKvpString("graphics_bloodfx-gpvp") or "Default"
    cb(CurrentBloodNow)
    -- print(CurrentBloodNow)
end)

RegisterNUICallback('getCurrentEffectIndex', function(data, cb)
    cb(GetResourceKvpString("graphics_bloodfx-gpvp") or "Default")
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local kvpValue = GetResourceKvpString("graphics_bloodfx-gpvp")
            
        if kvpValue then
            print("Resource started. Player has KVP:", kvpValue)
            print('KVP loaded:', kvpValue)
            TriggerEvent("core:bloodfx:change-gpvp", kvpValue)
        else
            print("Resource started. Player does not have KVP.")
        end
    end
end)

-- RegisterCommand("blood", function(source, args)
--     local effectName = args[1] or "Default"

--     TriggerEvent("core:bloodfx:change", effectName)
-- end, false)