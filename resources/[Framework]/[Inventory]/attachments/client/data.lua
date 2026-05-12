WEAPON_TINTS = {
    [1] = { --[[@normal_weapons]]
        [1] = { label = "None", price = 0 },
        [2] = { label = "Green", price = 2000 },
        [3] = { label = "Gold", price = 2000 },
        [4] = { label = "Pink", price = 2000 },
        [5] = { label = "Army", price = 2000 },
        [6] = { label = "LSPD", price = 2000 },
        [7] = { label = "Orange", price = 2000 },
        [8] = { label = "Platinum", price = 2000 },
    },
    [2] = { --[[@mk2_weapons]]
        [1] = { label = "None", price = 0 },
        [2] = { label = "Gray", price = 2000 },
        [3] = { label = "Two-Tone", price = 2000 },
        [4] = { label = "White", price = 2000 },
        [5] = { label = "Beige", price = 2000 },
        [6] = { label = "Green", price = 2000 },
        [7] = { label = "Blue", price = 2000 },
        [8] = { label = "Earth", price = 2000 },
        [9] = { label = "Brown & Black", price = 3000 },
        [10] = { label = "Red Contrast", price = 2000 },
        [11] = { label = "Blue Contrast", price = 2000 },
        [12] = { label = "Yellow Contrast", price = 2000 },
        [13] = { label = "Orange Contrast", price = 2000 },
        [14] = { label = "Pink", price = 2000 },
        [15] = { label = "Purple & Yellow", price = 3000 },
        [16] = { label = "Orange", price = 2000 },
        [17] = { label = "Green & Purple", price = 2500 },
        [18] = { label = "Red Features", price = 2000 },
        [19] = { label = "Green Features", price = 2000 },
        [20] = { label = "Cyan Features", price = 2000 },
        [21] = { label = "Yellow Features", price = 2000 },
        [22] = { label = "Red & White", price = 3000 },
        [23] = { label = "Blue & White", price = 3000 },
        [24] = { label = "Gold", price = 2000 },
        [25] = { label = "Platinum", price = 2000 },
        [26] = { label = "Gray & Lilac", price = 3000 },
        [27] = { label = "Purple & Lime", price = 3000 },
        [28] = { label = "Red", price = 2000 },
        [29] = { label = "Green", price = 2000 },
        [30] = { label = "Blue", price = 2000 },
        [31] = { label = "White & Aqua", price = 3000 },
        [32] = { label = "Orange & Yellow", price = 3000 },
        [33] = { label = "Red & Yellow", price = 3000 },
    },
    [3] = { --[[@custom_weapons]]
            [1] = { label = "None", price = 0 },
            [2] = { label = "Green", price = 2000 },
            [3] = { label = "Gold", price = 2000 },
            [4] = { label = "Pink", price = 2000 },
            [5] = { label = "Army", price = 2000 },
            [6] = { label = "LSPD", price = 2000 },
            [7] = { label = "Orange", price = 2000 },
            [8] = { label = "Platinum", price = 2000 },
            [9] = { label = "Tactical Tan", price = 3000 },
            [10] = { label = "Tactical Tan Alt", price = 2000 },
            [11] = { label = "Tactical Green", price = 2000 },
            [12] = { label = "Tactical Green Alt", price = 2000 },
            [13] = { label = "Tactical Grey", price = 2000 },
            [14] = { label = "Tactical Grey Alt", price = 2000 },
            [15] = { label = "B&W Two-Tone", price = 2000 },
            [16] = { label = "Stainless V2", price = 2000 },
            [17] = { label = "Worn N' Torn", price = 2000 },
            [18] = { label = "Training Day - Blue", price = 2000 },
            [19] = { label = "Training Day - Green", price = 2000 },
            [20] = { label = "Training Day - Red", price = 2000 },
            [21] = { label = "Light Pink", price = 2000 },
    },


}

--[[
    WEAPON_LIST Structure:
    Each weapon entry contains attachment categories with the following optional fields:
    - label: Display name for the attachment category
    - bone: Bone name on the weapon model (e.g., "WAPClip", "WAPSupp", "WAPFlshLasr")
    - offset: Optional table with x, y, z values to adjust bone position (e.g., { x = 0.02, y = 0, z = 0.01 })
    - options: Array of attachment options for this category
    - customTints: (For "Tint" category only) Optional array of custom tint definitions with custom names
    
    Example with offset:
    {
        label = "Suppressor",
        bone = "WAPSupp",
        offset = { x = 0.01, y = 0, z = -0.02 }, -- Adjusts bone position for better UI alignment
        options = { ... }
    }
    
    Example with custom tints:
    {
        label = "Tint",
        bone = "gun_root",
        customTints = {
            { label = "None", price = 0, tintIndex = 0 }, -- tintIndex is 0-based (0 = None, 1 = first tint, etc.)
            { label = "Desert Camo", price = 5000, tintIndex = 1 },
            { label = "Urban Camo", price = 5000, tintIndex = 2 },
            { label = "Arctic White", price = 3000, tintIndex = 3 },
            { label = "Midnight Black", price = 4000, tintIndex = 4 },
        },
        options = {}, -- Will be populated automatically
    }
    Note: If tintIndex is not specified, it will use the array position (0-based)
]]

WEAPON_LIST = {
    --[[@PISTOLS]]
    [`WEAPON_PISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_PISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 5000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOL_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 3500
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SNSPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_SNSPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SNSPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 6000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_COMBATPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_COMBATPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 7000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
                    label = "Deluxe",
                    price = 1000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_1911`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH_02",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
    },
    [`WEAPON_REVOLVER`] = {
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_REVOLVER_VARMOD_BOSS",
                    label = "Boss",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_REVOLVER_VARMOD_GOON",
                    label = "Goon",
                    price = 4000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_CERAMICPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_CERAMICPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CERAMICPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 6000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CERAMICPISTOL_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_FNX45`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH_02",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
    },
    [`WEAPON_SP45`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH_02",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 8000
                },
            },
        },
    },
    [`WEAPON_2011`] = {
        {
            label = "Flashlight",
            offset = { x = 0.06, y = 3, z = -0.0 },
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_FLSH_01",
                    label = "Flashlight 1",
                    price = 1500
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_FLSH_02",
                    label = "Flashlight 2",
                    price = 1500
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_FLSH_03",
                    label = "Flashlight 3",
                    price = 1500
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_FLSH_04",
                    label = "Flashlight 4",
                    price = 1500
                },
            },
        },
        {
            label = "Slide",
            bone = "WAPScop_2",
            offset = { x = 0.02, y = 0, z = 0.06 },
            options = {
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_01",
                    label = "Slide 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_02",
                    label = "Slide 2",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_03",
                    label = "Slide 3",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_04",
                    label = "Slide 4",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_05",
                    label = "Slide 5",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_06",
                    label = "Slide 6",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_07",
                    label = "Slide 7",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_SLIDE_08",
                    label = "Slide 8",
                    price = 8000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            offset = { x = 0.1, y = 0, z = 0.04 },
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_MUZZLE_02",
                    label = "Suppressor 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_MUZZLE_03",
                    label = "Suppressor 2",
                    price = 8000
                },
            },
        },
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_MARKOMODS2011_CLIP_01",
                    label = "Mag 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_CLIP_02",
                    label = "Mag 2",
                    price = 8000
                },
            },
        },
        {
            label = "Barrel",
            bone = "WAPGrip",
            options = {
                {
                    attachment = "COMPONENT_MARKOMODS2011_BARREL_01",
                    label = "Barrel 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_BARREL_02",
                    label = "Barrel 2",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS2011_BARREL_03",
                    label = "Barrel 3",
                    price = 8000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            customTints = {
                { label = "None", price = 0, tintIndex = 0 },
                { label = "Tactical Black", price = 3000, tintIndex = 1 },
                { label = "Desert Tan", price = 3500, tintIndex = 2 },
                { label = "OD Green", price = 3500, tintIndex = 3 },
                { label = "FDE", price = 4000, tintIndex = 4 },
                { label = "Midnight Blue", price = 4500, tintIndex = 5 },
                { label = "Stealth Gray", price = 4000, tintIndex = 6 },
                { label = "Carbon Fiber", price = 5000, tintIndex = 7 },
            },
            options = {},
        },
    },
    [`WEAPON_UBR_CQB`] = {
        {
            label = "Barrel",
--            offset = { x = 0.06, y = 3, z = -0.0 },
            bone = "gun_root",
            options = {
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_CQB_BARREL_01",
                    label = "Barrel 1",
                    price = 1500
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_CQB_BARREL_02",
                    label = "Barrel 2",
                    price = 1500
                },
            },
        },
        {
            label = "Slide",
            bone = "WAPScop_2",
--            offset = { x = 0.02, y = 0, z = 0.06 },
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MARKOMODS_SHARED_SCOPE_01_LIGHT",
                    label = "Scope 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_SHARED_SCOPE_02_LIGHT",
                    label = "Scope 2",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_SHARED_SCOPE_03_LIGHT",
                    label = "Scope 3",
                    price = 8000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
--            offset = { x = 0.1, y = 0, z = 0.04 },
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_SUPPRESSOR_01",
                    label = "Suppressor 1",
                    price = 8000
                },
            },
        },
        {
            label = "Body",
            bone = "WAPGrip_2",
            offset = { x = -0.1, y = 0, z = 0.04 },
            options = {
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_CQB_BODY_01",
                    label = "Body 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_CQB_BODY_02",
                    label = "Body 2",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_CQB_BODY_03",
                    label = "Body 3",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_CQB_BODY_04",
                    label = "Body 4",
                    price = 8000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_01",
                    label = "Grip 1",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_02",
                    label = "Grip 2",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_04",
                    label = "Grip 4",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_05",
                    label = "Grip 5",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_06",
                    label = "Grip 6",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_07",
                    label = "Grip 7",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_08",
                    label = "Grip 8",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_09",
                    label = "Grip 9",
                    price = 8000
                },
                {
                    attachment = "COMPONENT_MARKOMODS_UBR_GRIP_10",
                    label = "Grip 10",
                    price = 8000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            customTints = {
                { label = "None", price = 0, tintIndex = 0 },
                { label = "Ranger Green", price = 4000, tintIndex = 1 },
                { label = "Wolf Gray", price = 4000, tintIndex = 2 },
                { label = "Coyote Brown", price = 4500, tintIndex = 3 },
                { label = "Blackout", price = 3500, tintIndex = 4 },
                { label = "Arctic", price = 5000, tintIndex = 5 },
                { label = "Woodland", price = 4500, tintIndex = 6 },
                { label = "Urban Gray", price = 4000, tintIndex = 7 },
            },
            options = {},
        },
    },
    [`WEAPON_PISTOLXM3`] = {
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOLXM3_SUPP",
                    label = "Suppressor",
                    price = 7000
                },
            },
        },
    },
    [`WEAPON_PISTOL50`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_PISTOL50_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOL50_CLIP_02",
                    label = "Extended Mag",
                    price = 20000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 10000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOL50_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_DEAGLE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_deserteagle_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_deserteagle_CLIP_02",
                    label = "Extended Mag",
                    price = 20000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_VINTAGEPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_VINTAGEPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_VINTAGEPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 6000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_GLOCK17`] = {
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_SUPP",
                    label = "Suppressor",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_COMP",
                    label = "Comp",
                    price = 2500
                },
            },
        },
        {
            label = "Scopes",
            bone = "WAPscop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_NIGHTSIGHT",
                    label = "Nightsight",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_SIGHT",
                    label = "Sight",
                    price = 2500
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            customTints = {
                { label = "None", price = 0, tintIndex = 0 },
                { label = "Green", price = 5000, tintIndex = 1 },
                { label = "Gold", price = 5000, tintIndex = 2 },
                { label = "Pink", price = 3000, tintIndex = 3 },
                { label = "Tan", price = 4000, tintIndex = 4 },
                { label = "LSPD", price = 4000, tintIndex = 5 },
                { label = "Orange", price = 4000, tintIndex = 6 },
                { label = "Platinum", price = 4000, tintIndex = 7 },
                { label = "Two Tone Tan", price = 4000, tintIndex = 8 },
                { label = "Tactical Tan", price = 4000, tintIndex = 9 },
                { label = "Two Tone Green", price = 4000, tintIndex = 10 },
                { label = "Tactical Green", price = 4000, tintIndex = 11 },
                { label = "Two Tone Gray", price = 4000, tintIndex = 12 },
                { label = "Tactical Gray", price = 4000, tintIndex = 13 },
                { label = "Tactical White", price = 4000, tintIndex = 14 },
                { label = "Tactical", price = 4000, tintIndex = 15 },
                { label = "Worn n Tore", price = 4000, tintIndex = 16 },
                { label = "Training Blue", price = 4000, tintIndex = 17 },
                { label = "Training Green", price = 4000, tintIndex = 18 },
                { label = "Training Red", price = 4000, tintIndex = 19 },
                { label = "Nerf", price = 4000, tintIndex = 20 },
            },
            options = {},
        },
    },
    [`WEAPON_GLOCK18`] = {
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_SUPP",
                    label = "Suppressor",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_COMP",
                    label = "Comp",
                    price = 2500
                },
            },
        },
        {
            label = "Scopes",
            bone = "WAPscop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_NIGHTSIGHT",
                    label = "Nightsight",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SERVICEPISTOL_SIGHT",
                    label = "Sight",
                    price = 2500
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            customTints = {
                { label = "None", price = 0, tintIndex = 0 },
                { label = "Green", price = 5000, tintIndex = 1 },
                { label = "Gold", price = 5000, tintIndex = 2 },
                { label = "Pink", price = 3000, tintIndex = 3 },
                { label = "Tan", price = 4000, tintIndex = 4 },
                { label = "LSPD", price = 4000, tintIndex = 5 },
                { label = "Orange", price = 4000, tintIndex = 6 },
                { label = "Platinum", price = 4000, tintIndex = 7 },
                { label = "Two Tone Tan", price = 4000, tintIndex = 8 },
                { label = "Tactical Tan", price = 4000, tintIndex = 9 },
                { label = "Two Tone Green", price = 4000, tintIndex = 10 },
                { label = "Tactical Green", price = 4000, tintIndex = 11 },
                { label = "Two Tone Gray", price = 4000, tintIndex = 12 },
                { label = "Tactical Gray", price = 4000, tintIndex = 13 },
                { label = "Tactical White", price = 4000, tintIndex = 14 },
                { label = "Tactical", price = 4000, tintIndex = 15 },
                { label = "Worn n Tore", price = 4000, tintIndex = 16 },
                { label = "Training Blue", price = 4000, tintIndex = 17 },
                { label = "Training Green", price = 4000, tintIndex = 18 },
                { label = "Training Red", price = 4000, tintIndex = 19 },
                { label = "Nerf", price = 4000, tintIndex = 20 },
            },
            options = {},
        },
    },
    [`WEAPON_APPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_APPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_APPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 15000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 10000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_APPISTOL_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_HEAVYPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_HEAVYPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 15000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 10000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@SMG]]
    [`WEAPON_MACHINEPISTOL`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_MACHINEPISTOL_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MACHINEPISTOL_CLIP_02",
                    label = "Extended Mag",
                    price = 12000
                },
                {
                    attachment = "COMPONENT_MACHINEPISTOL_CLIP_03",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SMG`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_SMG_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SMG_CLIP_02",
                    label = "Extended Mag",
                    price = 20000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_02",
                    label = "Red Dot",
                    price = 2500
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SMG_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_MINISMG`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_MINISMG_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MINISMG_CLIP_02",
                    label = "Extended Mag",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_MICROSMG`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_MICROSMG_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MICROSMG_CLIP_02",
                    label = "Extended Mag",
                    price = 20000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO",
                    label = "Red Dot",
                    price = 2500
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MICROSMG_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SMG_MK2`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_SMG_MK2_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CLIP_02",
                    label = "Extended Mag",
                    price = 20000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_01",
                    label = "Flat Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_02",
                    label = "Tactical Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_03",
                    label = "Fat Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_04",
                    label = "Precision Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_05",
                    label = "Heavy Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_06",
                    label = "Slanted Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_07",
                    label = "Split Muzzle",
                    price = 15000
                },
            },
        },
        -- {
        --     label = "Barrel",
        --     bone = "WAPBarrel",
        --     options = {
        --         {
        --             attachment = "COMPONENT_AT_SB_BARREL_01",
        --             label = "Standard Barrel",
        --             price = 0
        --         },
        --         -- {
        --         --     attachment = "COMPONENT_AT_SB_BARREL_02",
        --         --     label = "Heavy Barrel",
        --         --     price = 20000
        --         -- },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SIGHTS_SMG",
                    label = "Reflex Sight",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
                    label = "Red Dot",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
                    label = "ACOG Scope",
                    price = 3000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO",
                    label = "Digital",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_02",
                    label = "Brushstroke",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_03",
                    label = "Woodland",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_04",
                    label = "Skull",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_05",
                    label = "Sessanta",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_06",
                    label = "Perseus",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_07",
                    label = "Leopard",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_08",
                    label = "Zebra",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_09",
                    label = "Geometric",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_10",
                    label = "Boom!",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_IND_01",
                    label = "Patriotic",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@SHOTGUNS]]
    [`WEAPON_DBSHOTGUN`] = {
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SAWNOFFSHOTGUN`] = {
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
    },
    --[[@RIFLES]]
    [`WEAPON_CARBINERIFLE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_CARBINERIFLE_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_CLIP_02",
                    label = "Extended Mag",
                    price = 30000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 2500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 12000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_GUSENBERG`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_GUSENBERG_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_GUSENBERG_CLIP_02",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_COMBATPDW`] = {
        {
            label = "Mag",
            bone = "WAPClip_2",
            options = {
                {
                    attachment = "COMPONENT_COMBATPDW_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATPDW_CLIP_02",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 20000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 12000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },

    [`WEAPON_MPX`] = {
        {
            label = "Mag",
            bone = "WAPClip",
             offset = { x = 0.06, y = 0, z = -0.03 }, -- Adjusts bone position for better UI alignment

            options = {
                {
                    attachment = "COMPONENT_MPX_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MPX_CLIP_02",
                    label = "Ext Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_MPX_CLIP_03",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlsh",
            offset = { x = 0.2, y = 0, z = 0.07 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MPX_FLSH_01",
                    label = "Flashlight",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_MPX_FLSH_02",
                    label = "Flashlight 2",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_MPX_FLSH_03",
                    label = "Flashlight 3",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_MPX_FLSH_04",
                    label = "Flashlight 4",
                    price = 3000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_01",
                    label = "Scope 1",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_02",
                    label = "Scope 2",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_03",
                    label = "Scope 3",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_04",
                    label = "Scope 4",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_05",
                    label = "Scope 5",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_06",
                    label = "Scope 6",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_07",
                    label = "Scope 7",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_08",
                    label = "Scope 8",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MPX_SCOPE_09",
                    label = "Scope 9",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            offset = { x = 0.4, y = 0, z = 0.03 },
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MPX_BARREL_01",
                    label = "Suppressor 1",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_MPX_BARREL_02",
                    label = "Suppressor 2",
                    price = 25000
                },
            },
        },
        
        {
            label = "Stock",
            bone = "WAPStock",
            offset = { x = -0.1, y = 0, z = 0.03 },

            options = {
                {
                    attachment = "COMPONENT_MPX_STOCK_01",
                    label = "Stock 1",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_02",
                    label = "Stock 2",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_03",
                    label = "Stock 3",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_04",
                    label = "Stock 4",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_05",
                    label = "Stock 5",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_06",
                    label = "Stock 6",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_07",
                    label = "Stock 7",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_08",
                    label = "Stock 8",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_09",
                    label = "Stock 9",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MPX_STOCK_10",
                    label = "Stock 10",
                    price = 2000
                },
            },
        },
        -- {
        --     label = "Tint",
        --     bone = "gun_root",
        --     options = {},
        -- },
    },

        [`WEAPON_PP19`] = {
        {
            label = "Mag",
            bone = "WAPClip",
             offset = { x = 0.06, y = 0, z = -0.03 }, -- Adjusts bone position for better UI alignment

            options = {
                {
                    attachment = "COMPONENT_PP19_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PP19_CLIP_02",
                    label = "Ext Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_PP19_CLIP_03",
                    label = "Drum Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_PP19_CLIP_04",
                    label = "Drum Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_PP19_CLIP_05",
                    label = "Drum Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_PP19_CLIP_06",
                    label = "Drum Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_PP19_CLIP_07",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },

         {
            label = "Grip",
            bone = "WAPGrip",
            offset = { x = 0.2, y = 0, z = 0.03 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_01",
                    label = "Foregrip 1",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_02",
                    label = "Foregrip 2",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_03",
                    label = "Foregrip 3",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_04",
                    label = "Foregrip 4",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_05",
                    label = "Foregrip 5",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_06",
                    label = "Foregrip 6",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_07",
                    label = "Foregrip 7",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_08",
                    label = "Foregrip 8",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_PP19_HANDGUARD_09",
                    label = "Foregrip 9",
                    price = 15000
                },
               
                
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlsh",
            offset = { x = 0.2, y = 0, z = 0.07 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PP19_LASER_01",
                    label = "Flashlight",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_PP19_LASER_02",
                    label = "Flashlight 2",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_PP19_LASER_03",
                    label = "Flashlight 3",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_PP19_LASER_04",
                    label = "Flashlight 4",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_PP19_LASER_05",
                    label = "Flashlight 4",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_PP19_LASER_06",
                    label = "Flashlight 4",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_PP19_LASER_07",
                    label = "Flashlight 4",
                    price = 3000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_01",
                    label = "Scope 1",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_02",
                    label = "Scope 2",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_03",
                    label = "Scope 3",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_04",
                    label = "Scope 4",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_05",
                    label = "Scope 5",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_06",
                    label = "Scope 6",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_07",
                    label = "Scope 7",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_08",
                    label = "Scope 8",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_09",
                    label = "Scope 9",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_PP19_SCOPE_10",
                    label = "Scope 9",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            offset = { x = 0.4, y = 0, z = 0.03 },
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PP19_MUZZLE_01",
                    label = "Suppressor 1",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_PP19_MUZZLE_02",
                    label = "Suppressor 2",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_PP19_MUZZLE_03",
                    label = "Suppressor 2",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_PP19_MUZZLE_04",
                    label = "Suppressor 2",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_PP19_MUZZLE_05",
                    label = "Suppressor 2",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_PP19_MUZZLE_06",
                    label = "Suppressor 2",
                    price = 25000
                },
            },
        },
        
        {
            label = "Stock",
            bone = "WAPStock",
            offset = { x = -0.1, y = 0, z = 0.03 },

            options = {
                {
                    attachment = "COMPONENT_PP19_STOCK_01",
                    label = "Stock 1",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_02",
                    label = "Stock 2",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_03",
                    label = "Stock 3",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_04",
                    label = "Stock 4",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_05",
                    label = "Stock 5",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_06",
                    label = "Stock 6",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_07",
                    label = "Stock 7",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_08",
                    label = "Stock 8",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_PP19_STOCK_09",
                    label = "Stock 9",
                    price = 2000
                },
            },
        },
        -- {
        --     label = "Tint",
        --     bone = "gun_root",
        --     options = {},
        -- },
    },


    [`WEAPON_HKUMP`] = {
        {
            label = "Mag",
            bone = "WAPClip",

            options = {
                {
                    attachment = "COMPONENT_UMP_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_CLIP_02",
                    label = "Extended Mag",
                    price = 30000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            offset = { x = 0.2, y = 0, z = 0.07 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_01",
                    label = "Flashlight 1",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_02",
                    label = "Flashlight 2",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_03",
                    label = "Flashlight 3",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_04",
                    label = "Flashlight 4",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_05",
                    label = "Flashlight 5",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_06",
                    label = "Flashlight 6",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_07",
                    label = "Flashlight 7",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_UMP_FLSH_08",
                    label = "Flashlight 8",
                    price = 3000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            offset = { x = 0.2, y = 0, z = 0.03 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_01",
                    label = "Foregrip 1",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_02",
                    label = "Foregrip 2",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_03",
                    label = "Foregrip 3",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_04",
                    label = "Foregrip 4",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_05",
                    label = "Foregrip 5",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_06",
                    label = "Foregrip 6",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_07",
                    label = "Foregrip 7",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_08",
                    label = "Foregrip 8",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_09",
                    label = "Foregrip 9",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_UMP_GRIP_10",
                    label = "Foregrip 10",
                    price = 15000
                },
                
            },
        },
        {
            label = "Barrel",
            bone = "WAPBarrel",
            offset = { x = 0.3, y = 0, z = 0.07 },

            options = {
                {
                    attachment = "COMPONENT_UMP_MOUNT_01",
                    label = "Standard Barrel",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_MOUNT_02",
                    label = "Heavy Barrel",
                    price = 40000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            offset = { x = 0.1, y = 0, z = 0.07 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_01",
                    label = "Scope 1",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_02",
                    label = "Scope 2",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_03",
                    label = "Scope 3",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_04",
                    label = "Scope 4",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_05",
                    label = "Scope 5",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_06",
                    label = "Scope 6",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_07",
                    label = "Scope 7",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_08",
                    label = "Scope 8",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_09",
                    label = "Scope 9",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_UMP_SCOPE_10",
                    label = "Scope 10",
                    price = 3500
                },
            },
        },
        {
            label = "Stock",
            bone = "WAPStock",
            offset = { x = -0.1, y = 0, z = 0.04 },

            options = {
                {
                    attachment = "COMPONENT_UMP_STOCK_01",
                    label = "Stock 1",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_STOCK_02",
                    label = "Stock 2",
                    price = 2000
                },
            },
        },
      
        {
            label = "Suppressor",
            bone = "WAPSupp",
            offset = { x = 0.5, y = 0, z = 0.04 },


            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_UMP_SUPP_01",
                    label = "Suppressor 1",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_UMP_SUPP_02",
                    label = "Suppressor 2",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_UMP_SUPP_03",
                    label = "Suppressor 3",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_UMP_SUPP_04",
                    label = "Suppressor 4",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_UMP_SUPP_05",
                    label = "Suppressor 5",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_UMP_SUPP_06",
                    label = "Suppressor 6",
                    price = 25000
                },
            },
        },

        -- {
        --     label = "Tint",
        --     bone = "gun_root",
        --     options = {},
        -- },
    },

    [`WEAPON_AKS74U`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_AKS74U_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_02",
                    label = "Extended Mag",
                    price = 30000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_03",
                    label = "Drum Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_04",
                    label = "Special Mag 1",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_05",
                    label = "Special Mag 2",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_06",
                    label = "Special Mag 3",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_07",
                    label = "Special Mag 4",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_08",
                    label = "Special Mag 5",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_AKS74U_CLIP_09",
                    label = "Special Mag 6",
                    price = 100000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            offset = { x = 0.2, y = 0, z = 0.07 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_01",
                    label = "Flashlight",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_02",
                    label = "Flashlight 2",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_03",
                    label = "Flashlight 3",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_04",
                    label = "Flashlight 4",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_05",
                    label = "Flashlight 5",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_06",
                    label = "Flashlight 6",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_07",
                    label = "Flashlight 7",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AKS74U_FLSH_08",
                    label = "Flashlight 8",
                    price = 3000
                },
            },
        },
        -- {
        --     label = "Grip",
        --     bone = "WAPGrip",
        --     offset = { x = 0.2, y = 0, z = 0.03 },
        --     options = {
        --         {
        --             label = "None",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_AKS74U_GRIP_01",
        --             label = "Foregrip",
        --             price = 15000
        --         },
        --         {
        --             attachment = "COMPONENT_AKS74U_GRIP_02",
        --             label = "Foregrip 2",
        --             price = 15000
        --         },
        --         {
        --             attachment = "COMPONENT_AKS74U_GRIP_03",
        --             label = "Foregrip 3",
        --             price = 15000
        --         },
        --     },
        -- },
        {
            label = "Barrel",
            bone = "WAPBarrel",
            offset = { x = 0.3, y = 0, z = 0.07 },
            options = {
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_01",
                    label = "Standard Barrel",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_02",
                    label = "Heavy Barrel",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_03",
                    label = "Heavy Barrel 3",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_04",
                    label = "Heavy Barrel 4",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_05",
                    label = "Heavy Barrel 5",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_06",
                    label = "Heavy Barrel 6",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_07",
                    label = "Heavy Barrel 7",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_AKS74U_HANDGUARD_08",
                    label = "Heavy Barrel 8",
                    price = 40000
                },
            },
        },

        {
            label = "Stock",
            bone = "WAPScop_2",
            offset = { x = -0.1, y = 0, z = 0.03 },
            options = {
                {
                    attachment = "COMPONENT_AKS74U_STOCK_01",
                    label = "Stock 1",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AKS74U_STOCK_02",
                    label = "Stock 2",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_AKS74U_STOCK_03",
                    label = "Stock 3",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_AKS74U_STOCK_04",
                    label = "Stock 4",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_AKS74U_STOCK_05",
                    label = "Stock 5",
                    price = 2000
                },
            },
        },

         {
            label = "Suppressor",
            bone = "WAPSupp",
            offset = { x = 0.5, y = 0, z = 0.04 },
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_01",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_02",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_03",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_04",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_05",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_06",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_07",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AKS74U_MUZ_08",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            offset = { x = 0.1, y = 0, z = 0.07 },

            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_01",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_02",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_03",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_04",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_05",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_06",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_07",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_08",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_09",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_10",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_11",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_12",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_13",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_14",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_15",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_16",
                    label = "Acog Scope",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_AKS74U_SCOPE_17",
                    label = "Acog Scope",
                    price = 3500
                },
                
            },
        },

        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },


    [`WEAPON_COMPACTRIFLE`] = {
        {
            label = "Mag",
            bone = "WAPClip_2",
            options = {
                {
                    attachment = "COMPONENT_COMPACTRIFLE_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMPACTRIFLE_CLIP_02",
                    label = "Extended Mag",
                    price = 30000
                },
                {
                    attachment = "COMPONENT_COMPACTRIFLE_CLIP_03",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SPECIALCARBINE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_SPECIALCARBINE_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SPECIALCARBINE_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_HEAVYRIFLE`] = {
        {
            label = "Mag",
            bone = "WAPClip_2",
            options = {
                {
                    attachment = "COMPONENT_HEAVYRIFLE_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYRIFLE_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYRIFLE_SIGHT_01",
                    label = "Iron Sights",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYRIFLE_CAMO1",
                    label = "GSF",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_ASSAULTRIFLE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_ASSAULTRIFLE_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_ASSAULTRIFLE_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
                {
                    attachment = "COMPONENT_ASSAULTRIFLE_CLIP_03",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO",
                    label = "Red Dot",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_TACTICALRIFLE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_TACTICALRIFLE_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_TACTICALRIFLE_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH_REH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_NAVYCARBINE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_01",
                    label = "Flat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_02",
                    label = "Tactical Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_03",
                    label = "Fat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_04",
                    label = "Precision Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_05",
                    label = "Heavy Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_06",
                    label = "Slanted Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_07",
                    label = "Split Muzzle",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP_02",
                    label = "Foregrip",
                    price = 40000
                },
            },
        },
        -- {
        --     label = "Barrel",
        --     bone = "WAPBarrel",
        --     options = {
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_01",
        --             label = "Standard Barrel",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_02",
        --             label = "Heavy Barrel",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SIGHTS",
                    label = "Holographic Sight",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_MK2",
                    label = "Red Dot",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
                    label = "Acog Scope",
                    price = 4000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_PROTORIFLE`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_01",
                    label = "Flat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_02",
                    label = "Tactical Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_03",
                    label = "Fat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_04",
                    label = "Precision Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_05",
                    label = "Heavy Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_06",
                    label = "Slanted Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_07",
                    label = "Split Muzzle",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP_02",
                    label = "Foregrip",
                    price = 40000
                },
            },
        },
        -- {
        --     label = "Barrel",
        --     bone = "WAPBarrel",
        --     options = {
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_01",
        --             label = "Standard Barrel",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_02",
        --             label = "Heavy Barrel",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SIGHTS",
                    label = "Holographic Sight",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_MK2",
                    label = "Red Dot",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
                    label = "Acog Scope",
                    price = 4000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_CARBINERIFLE_MK2`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
                    label = "Extended Mag",
                    price = 40000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_01",
                    label = "Flat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_02",
                    label = "Tactical Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_03",
                    label = "Fat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_04",
                    label = "Precision Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_05",
                    label = "Heavy Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_06",
                    label = "Slanted Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_07",
                    label = "Split Muzzle",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP_02",
                    label = "Foregrip",
                    price = 40000
                },
            },
        },
        -- {
        --     label = "Barrel",
        --     bone = "WAPBarrel",
        --     options = {
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_01",
        --             label = "Standard Barrel",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_02",
        --             label = "Heavy Barrel",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SIGHTS",
                    label = "Holographic Sight",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_MK2",
                    label = "Red Dot",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
                    label = "Acog Scope",
                    price = 4000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO",
                    label = "Digital",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_02",
                    label = "Brushstroke",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_03",
                    label = "Woodland",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_04",
                    label = "Skull",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_05",
                    label = "Sessanta",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_06",
                    label = "Perseus",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_07",
                    label = "Leopard",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_08",
                    label = "Zebra",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_09",
                    label = "Geometric",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_10",
                    label = "Boom!",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01",
                    label = "Patriotic",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_MK18`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_MK18_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_CLIP_02",
                    label = "Black Scale Mag",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_CLIP_03",
                    label = "Tan Scale Mag",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_CLIP_04",
                    label = "Black Tac Mag",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_CLIP_05",
                    label = "Tan Tac Mag",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_CLIP_06",
                    label = "Box Mag",
                    price = 100000
                },
                {
                    attachment = "COMPONENT_MK18_CLIP_07",
                    label = "Drum Mag",
                    price = 100000
                },
            },
        },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_01",
                    label = "Tan Laser",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_02",
                    label = "Small Tan Laser",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_03",
                    label = "Grey Laser",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_04",
                    label = "Large Black Laser",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_05",
                    label = "Flashlight",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_06",
                    label = "Tan Flash + Laser",
                    price = 3500
                },
                {
                    attachment = "COMPONENT_MK18_FLASH_07",
                    label = "Tan Flash + S Laser",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    attachment = "COMPONENT_MK18_SCOPE_01",
                    label = "Iron Sights",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_02",
                    label = "Tan Holo",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_03",
                    label = "Tan Holo/Acog - off",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_04",
                    label = "Tan Holo/Acog - on",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_05",
                    label = "Black Holo",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_06",
                    label = "Red Dot",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_07",
                    label = "Black Holo 2",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_08",
                    label = "Short Scope",
                    price = 2500
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_09",
                    label = "Long Scope",
                    price = 2500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_SUPPRESSOR_01",
                    label = "Suppressor 1",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_MK18_SUPPRESSOR_02",
                    label = "Suppressor 2",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_MK18_SUPPRESSOR_03",
                    label = "Suppressor 3",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_MK18_SUPPRESSOR_04",
                    label = "Suppressor 4",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_MK18_SUPPRESSOR_05",
                    label = "Suppressor 5",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_MK18_SUPPRESSOR_06",
                    label = "Suppressor 6",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_GRIP_05",
                    label = "Foregrip 1",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_GRIP_01",
                    label = "Foregrip 2",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_GRIP_02",
                    label = "Foregrip 3",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_GRIP_03",
                    label = "Foregrip 4",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_GRIP_04",
                    label = "Foregrip 5",
                    price = 2000
                },
            },
        },
        {
            label = "Stock",
            bone = "WAPGrip_2",
            options = {
                {
                    attachment = "COMPONENT_MK18_STOCK_01",
                    label = "Stock 1",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_STOCK_02",
                    label = "Stock 2",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_STOCK_03",
                    label = "Stock 3",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_STOCK_04",
                    label = "Stock 4",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_STOCK_05",
                    label = "Stock 5",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_STOCK_06",
                    label = "Stock 6",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_STOCK_07",
                    label = "Stock 7",
                    price = 2000
                },
            },
        },
        {
            label = "Frame",
            bone = "WAPFrame",
            options = {
                {
                    attachment = "COMPONENT_MK18_FRAME_01",
                    label = "Black Frame",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_FRAME_02",
                    label = "Blk + Tan Frame",
                    price = 2000
                },
                {
                    attachment = "COMPONENT_MK18_FRAME_03",
                    label = "Tan Frame",
                    price = 2000
                },
            },
        },
    },
    --[[@MGs]]
    [`WEAPON_COMBATMG`] = {
        {
            label = "Mag",
            bone = "WAPClip",
            options = {
                {
                    attachment = "COMPONENT_COMBATMG_CLIP_01",
                    label = "Standard Mag",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATMG_CLIP_02",
                    label = "Extended Mag",
                    price = 50000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 4000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 14000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATMG_VARMOD_LOWRIDER",
                    label = "Deluxe",
                    price = 10000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@SNIPERS]]
    [`WEAPON_SNIPERRIFLE`] = {
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_LARGE",
                    label = "Large Scope",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MAX",
                    label = "Max Scope",
                    price = 15000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 50000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SNIPERRIFLE_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@Melee]]
    [`WEAPON_KNUCKLE`] = {
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_PIMP",
                    label = "The Pimp",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_BALLAS",
                    label = "The Ballas",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_DOLLAR",
                    label = "The Hustler",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_HATE",
                    label = "The Hater",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_LOVE",
                    label = "The Lover",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_PLAYER",
                    label = "The Player",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_KING",
                    label = "The King",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_VAGOS",
                    label = "The Vagos",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SWITCHBLADE`] = {
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    attachment = "COMPONENT_SWITCHBLADE_VARMOD_BASE",
                    label = "Base",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SWITCHBLADE_VARMOD_VAR1",
                    label = "VIP",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SWITCHBLADE_VARMOD_VAR2",
                    label = "Bodyguard",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
}
