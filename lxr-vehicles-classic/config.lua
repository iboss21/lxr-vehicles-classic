--[[
    ██╗     ██╗  ██╗██████╗        ██╗   ██╗███████╗██╗  ██╗██╗ ██████╗██╗     ███████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██║   ██║██╔════╝██║  ██║██║██╔════╝██║     ██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗ ██║   ██║█████╗  ███████║██║██║     ██║     █████╗  ███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚██╗ ██╔╝██╔══╝  ██╔══██║██║██║     ██║     ██╔══╝  ╚════██║
    ███████╗██╔╝ ██╗██║  ██║        ╚████╔╝ ███████╗██║  ██║██║╚██████╗███████╗███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚══════╝╚══════╝

    ██████╗██╗      █████╗ ███████╗███████╗██╗ ██████╗
    ██╔════╝██║     ██╔══██╗██╔════╝██╔════╝██║██╔════╝
    ██║     ██║     ███████║███████╗███████╗██║██║
    ██║     ██║     ██╔══██║╚════██║╚════██║██║██║
    ╚██████╗███████╗██║  ██║███████║███████║██║╚██████╗
     ╚═════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝

    🐺 LXR Vehicles Classic — Unified Configuration
    wolves.land | The Land of Wolves | The Lux Empire

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted

    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb

    ═══════════════════════════════════════════════════════════════════════════════

    Version: 2.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact

    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Primary)
    - VORP Core (Compatible / Legacy)

    Features:
    - Unified Dealership / Shop system (togglable)
    - Admin spawn command (togglable, permission-based)
    - Database ownership verification (togglable)
    - Multi-framework auto-detection
    - Sound engine (NUI)
    - All vehicle types: cars, bikes, boats, helis, planes, tanks, special

    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════

    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Base Vehicle System: Silonugget
    Dealership Base: VORP Community

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION — RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-vehicles-classic"
local currentResourceName    = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[

        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════

        Expected : %s
        Got      : %s

        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.

        🐺 wolves.land — The Land of Wolves

        ═══════════════════════════════════════════════════════════════════════════════

    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name        = 'The Land of Wolves 🐺',
    tagline     = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type        = 'Serious Hardcore Roleplay',
    access      = 'Discord & Whitelisted',
    website     = 'https://www.wolves.land',
    discord     = 'https://discord.gg/CrKcWdfd3A',
    github      = 'https://github.com/iBoss21',
    store       = 'https://theluxempire.tebex.io',
    serverList  = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer   = 'iBoss21 / The Lux Empire',
    tags        = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Vehicles', 'Dealership', 'Economy'},
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK SETTINGS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
--
--  "auto"   — Detects LXR-Core → RSG-Core → VORP in that priority order
--  "lxr"    — Force LXR-Core
--  "rsg"    — Force RSG-Core
--  "vorp"   — Force VORP Core
--
Config.Framework = "auto"

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FEATURE TOGGLES ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Features = {
    -- ── Dealership ──────────────────────────────────────────────────────────────
    -- When true, NPC dealers appear at configured locations. Players can browse
    -- and purchase vehicles stored in the database. Set false for free-spawn only.
    Dealership         = true,

    -- ── Database Ownership Check ─────────────────────────────────────────────────
    -- When true, players can only spawn vehicles they have purchased/own in the DB.
    -- When false, anyone can spawn any vehicle (useful for test/freeplay servers).
    DatabaseOwnership  = true,

    -- ── Admin Spawn Command ──────────────────────────────────────────────────────
    -- When true, players in Config.AdminGroups can use /vspawn <vehicle> to spawn
    -- any vehicle bypassing ownership. Set false to disable admin spawn entirely.
    AdminSpawn         = true,

    -- ── Public Spawn Command ─────────────────────────────────────────────────────
    -- When true, /balboni <vehicle> is available to ALL players (ignores DB).
    -- Useful for FreeRoam / test servers. Set false for serious RP.
    PublicSpawn        = false,

    -- ── VORP-Style Notifications ─────────────────────────────────────────────────
    -- When true, uses VORPcore NotifyAdvanced for in-world notifications.
    -- When false, uses the built-in LXR notification export.
    VorpNotif          = false,

    -- ── Alt Handling (Ped Scale Fix) ─────────────────────────────────────────────
    AltHandling        = true,
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ADMIN CONFIGURATION ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.AdminGroups = {
    'admin',
    'superadmin',
    'mod',
    'owner',
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ KEY BINDINGS ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Keys = {
    Engine      = 0x8AAA0AD4,  -- LEFT ALT  — toggle engine on/off
    DeleteVeh   = "delete_vehicle", -- /delete_vehicle command name
    SpawnCmd    = "balboni",        -- /balboni <type> — public spawn (if enabled)
    AdminCmd    = "vspawn",         -- /vspawn <type>  — admin spawn (if enabled)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NOTIFICATION TEXTS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Texts = {
    -- Dealership / Ownership
    DealerTitle     = "🐺 Vehicle Dealer",
    NotOwned        = "You do not own this vehicle.",
    PurchaseSuccess = "Purchase successful! Vehicle added to your garage.",
    PurchaseFail    = "An error occurred during purchase.",
    CantAfford      = "You cannot afford this vehicle.",
    SellSuccess     = "Vehicle sold!",
    DeleteSuccess   = "Vehicle removed from garage.",
    TransferSent    = "Transfer offer sent.",
    TransferAccept  = "Transfer accepted!",
    TransferDecline = "Transfer declined.",
    Changed         = "Default vehicle updated.",
    ErrorUpdate     = "An error occurred updating your garage.",
    -- Spawn / Water
    WaterOnly       = "You must be IN WATER to spawn this vehicle!",
    SpawnTitle      = "Vehicle Spawn",
    -- Admin
    AdminOnly       = "This command requires admin permissions.",
    NoVehicle       = "Unknown vehicle type. Check Config.Vehicles.",
}

Config.Textures = {
    cross  = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures",       "stamp_locked_rank"},
    tick   = {"scoretimer_textures", "scoretimer_generic_tick"},
    money  = {"inventory_items",     "money_moneystack"},
    alert  = {"menu_textures",       "menu_icon_alert"},
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEALERSHIP LOCATIONS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
--
--  Each entry defines one NPC dealer location.
--  Fields:
--    Name          — Display name shown in the HUD prompt
--    BlipIcon      — Hash for the map blip icon
--    EnterStable   — {x, y, z, radius} — trigger zone coords + radius
--    StableNPC     — {x, y, z, heading} — NPC spawn position
--    SpawnPos      — {x, y, z, heading} — where purchased vehicle preview spawns
--    CamPos        — {x, y, z, rotX, rotY, rotZ} — cinematic cam for preview
--    vehicles      — table of { modelKey = price }
--
Config.Dealerships = {
    -- ── St Denis Car Dealership ─────────────────────────────────────────────────
    {
        Name        = "St Denis Car Dealership",
        BlipIcon    = -1989306548,
        EnterStable = {2441.28, -1311.70, 45.69, 2.0},
        StableNPC   = {2441.3,  -1311.46, 44.65, 165.69},
        SpawnPos    = {2449.19, -1318.56,  45.23, 160.28},
        CamPos      = {2454.49, -1319.56,  47.43,  -16.0, 0.0, 70.0},
        vehicles = {
            lancer       = 18000,
            g37          = 8000,
            ironmalibu   = 8000,
            ironsport    = 50000,
            hellcat      = 89000,
            ironroadster = 95000,
            policesuv    = 32000,
            irongtr      = 92000,
            ironlambo    = 200000,
        },
    },
    -- ── St Denis Heli Pad ───────────────────────────────────────────────────────
    {
        Name        = "St Denis Heli Pad",
        BlipIcon    = -1989306548,
        EnterStable = {2674.80, -822.21, 41.69, 3.0},
        StableNPC   = {2674.80, -822.21, 41.53, 25.69},
        SpawnPos    = {2672.47, -799.09, 42.69, 0.0},
        CamPos      = {2669.08, -780.87, 44.69, -172.0, 180.0, 0.0},
        vehicles = {
            heli    = 18000,
            polheli = 8000,
            cargobob = 8000,
            heli2   = 50000,
        },
    },
    -- ── Valentine Motor Vehicles ────────────────────────────────────────────────
    {
        Name        = "Valentine Motor Vehicles",
        BlipIcon    = -1989306548,
        EnterStable = {-250.07,  700.52, 112.59, 2.0},
        StableNPC   = {-250.07,  700.52, 112.30, 37.93},
        SpawnPos    = {-259.22,  708.53, 113.51, 100.09},
        CamPos      = {-258.88,  700.41, 116.10, 350.83, 0.0, 0.0},
        vehicles = {
            truck        = 3000,
            sandrail     = 28500,
            muscle       = 11900,
            micahcycle   = 10500,
            vapidfordor  = 1000,
            vapidtudor   = 1500,
            classic      = 2000,
            classic2     = 2000,
            irontruck    = 1000,
            policebike   = 25000,
            ironimpala   = 18000,
            ironcharger  = 25000,
            ironstang    = 40000,
        },
    },
    -- ── Blackwater Customs ──────────────────────────────────────────────────────
    {
        Name        = "Blackwater Customs",
        BlipIcon    = 1989306548,
        EnterStable = {-877.45, -1368.36, 42.53, 2.0},
        StableNPC   = {-878.55, -1368.36, 42.53, 266.28},
        SpawnPos    = {-872.58, -1366.57, 42.53, 270.35},
        CamPos      = {-869.79, -1361.10, 45.27,  -17.12, 0.0, 161.40},
        vehicles = {
            cyberhorse    = 10000,
            truckLifted   = 22000,
            bat           = 20000,
            batclassic    = 15000,
            ninetystang   = 40000,
            ironcamaro    = 35000,
            franklin      = 5000,
            trevor        = 1000,
            michael       = 1000,
        },
    },
    -- ── Emerald Airfield ────────────────────────────────────────────────────────
    {
        Name        = "Emerald Airfield",
        BlipIcon    = 1989306548,
        EnterStable = {1402.09, 263.94, 88.55, 3.0},
        StableNPC   = {1402.09, 263.94, 88.55, 169.01},
        SpawnPos    = {1396.41, 227.85,  91.31, 0.0},
        CamPos      = {1393.52, 210.03,  93.55,  -8.43, 0.0, 0.48},
        vehicles = {
            aten      = 100000,
            fireplane = 10000,
            biplane   = 200,
            biplane2  = 200,
            triplane  = 300,
            xwing     = 5000,
            osprey    = 1000000,
        },
    },
    -- ── Flat Iron Lake Marina ────────────────────────────────────────────────────
    {
        Name        = "Flat Iron Lake Marina",
        BlipIcon    = 1989306548,
        EnterStable = {-1403.0, -1849.0, 5.5, 3.0},
        StableNPC   = {-1403.0, -1849.0, 5.5, 90.0},
        SpawnPos    = {-1403.0, -1855.0, 3.0, 90.0},
        CamPos      = {-1395.0, -1849.0, 7.0, 0.0, 0.0, 180.0},
        vehicles = {
            jetski      = 5000,
            speedboat   = 15000,
            bigboat     = 25000,
            lamboboat   = 80000,
            biggerboat  = 120000,
        },
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ VEHICLE DEFINITIONS ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
--
--  Each key must match an entry in Config.Dealerships[n].vehicles
--  type options: "car", "bike", "boat", "plane", "jet", "heli", "tank", "osprey", "cargobob"
--
Config.Vehicles = {

    -- ══════════════════════════════════════════════════════════════════
    -- TRUCKS & OFFROAD
    -- ══════════════════════════════════════════════════════════════════
    truck = {
        type = "car", soundType = "truck",
        objectModel = "f15078", frontWheelModel = "f15078wheel", rearWheelModel = "f15078wheel",
        AltTopSpeed = 50.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.5, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.95, y=1.32, z=-0.19 }, { x=-0.95, y=1.32, z=-0.19 }},
        frontDistanceToGrnd=0.4, frontSuspensionUpperLimit=-0.02, frontSuspensionLowerLimit=-0.3,
        rearWheelOffsets  = {{ x=0.95, y=-2.05, z=-0.18 }, { x=-0.95, y=-2.05, z=-0.18 }},
        rearDistanceToGrnd=0.41, rearSuspensionUpperLimit=0.02,  rearSuspensionLowerLimit=-0.3,
        headlightOffsets  = {{ x=0.8,  y=1.9,  z=0.5, rx=-0.0, ry=0.0, rz=0 }, { x=-0.8, y=1.9, z=0.5, rx=-0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.22, y=-4.0, z=-1.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=1.2, y=-2.73, z=0.3 }},
        cloneOffsets = { x=-0.48, y=-0.35, z=0.55, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    truckLifted = {
        type = "car", soundType = "bigtruck",
        objectModel = "irontrucklifted", frontWheelModel = "irontruckliftedwheel", rearWheelModel = "irontruckliftedwheel",
        AltTopSpeed = 50.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.5, 0.9, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.40, y=2.4, z=-1.1 }, { x=-1.38, y=2.4, z=-1.1 }},
        frontDistanceToGrnd=0.6, frontSuspensionUpperLimit=-0.4, frontSuspensionLowerLimit=-1.35,
        rearWheelOffsets  = {{ x=1.40, y=-2.1, z=-1.1 }, { x=-1.38, y=-2.1, z=-1.1 }},
        rearDistanceToGrnd=0.6, rearSuspensionUpperLimit=-0.4,  rearSuspensionLowerLimit=-1.35,
        headlightOffsets  = {{ x=-0.9, y=2.95, z=0.5, rx=0.0, ry=0.0, rz=0 }, { x=0.9, y=2.95, z=0.5, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=1.1, y=-3.4, z=0.0 }, { x=-1.1, y=-3.4, z=0.0 }},
        cloneOffsets = { x=-0.48, y=0.5, z=0.49, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    irontruck = {
        type = "car", soundType = "truck",
        objectModel = "irontruck", frontWheelModel = "irontruckliftedwheel", rearWheelModel = "irontruckliftedwheel",
        AltTopSpeed = 50.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.5, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.95, y=1.32, z=-0.19 }, { x=-0.95, y=1.32, z=-0.19 }},
        frontDistanceToGrnd=0.4, frontSuspensionUpperLimit=-0.02, frontSuspensionLowerLimit=-0.3,
        rearWheelOffsets  = {{ x=0.95, y=-2.05, z=-0.18 }, { x=-0.95, y=-2.05, z=-0.18 }},
        rearDistanceToGrnd=0.41, rearSuspensionUpperLimit=0.02,  rearSuspensionLowerLimit=-0.3,
        headlightOffsets  = {{ x=0.8, y=1.9, z=0.5, rx=0.0, ry=0.0, rz=0 }, { x=-0.8, y=1.9, z=0.5, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.22, y=-4.0, z=-1.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=1.2, y=-2.73, z=0.3 }},
        cloneOffsets = { x=-0.48, y=-0.35, z=0.55, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    atv = {
        type = "car", soundType = "dirtbike",
        objectModel = "ironatv", frontWheelModel = "ironatvwheel", rearWheelModel = "ironatvwheel",
        AltTopSpeed = 75.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 1.0, -0.13, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.58, y=0.85, z=-0.3 }, { x=-0.58, y=0.85, z=-0.3 }},
        frontDistanceToGrnd=0.3, frontSuspensionUpperLimit=-0.24, frontSuspensionLowerLimit=-0.4,
        rearWheelOffsets  = {{ x=0.59, y=-0.73, z=-0.3 }, { x=-0.58, y=-0.73, z=-0.3 }},
        rearDistanceToGrnd=0.31, rearSuspensionUpperLimit=-0.15, rearSuspensionLowerLimit=-0.4,
        headlightOffsets  = {{ x=-0.25, y=0.8, z=0.0, rx=0.0, ry=0.0, rz=0 }, { x=0.25, y=0.8, z=0.0, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=0.0, y=-0.25, z=0.4, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 15.0},
    },
    sandrail = {
        type = "car", soundType = "dirtbike",
        objectModel = "sandrail", frontWheelModel = "sandrailwheel", rearWheelModel = "sandrailwheel",
        AltTopSpeed = 100.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 1.0, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.85, y=1.2, z=-0.35 }, { x=-0.85, y=1.2, z=-0.35 }},
        frontDistanceToGrnd=0.35, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.85, y=-1.2, z=-0.35 }, { x=-0.85, y=-1.2, z=-0.35 }},
        rearDistanceToGrnd=0.35, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.4, y=1.2, z=0.2, rx=0.0, ry=0.0, rz=0 }, { x=0.4, y=1.2, z=0.2, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.0, y=-0.2, z=0.5, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    cyberhorse = {
        type = "car", soundType = "electric",
        objectModel = "cyberhorse", frontWheelModel = "cyberhorsewheel", rearWheelModel = "cyberhorsewheel",
        AltTopSpeed = 200.0, AltAccelMultiplier = 0.4,
        attachOffsets = {-0.01, 1.0, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.85, y=1.4, z=-0.3 }, { x=-0.85, y=1.4, z=-0.3 }},
        frontDistanceToGrnd=0.38, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.85, y=-1.3, z=-0.3 }, { x=-0.85, y=-1.3, z=-0.3 }},
        rearDistanceToGrnd=0.38, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.6, y=1.8, z=0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.6, y=1.8, z=0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.25, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- BIKES
    -- ══════════════════════════════════════════════════════════════════
    dirtbike = {
        type = "bike", soundType = "dirtbike",
        objectModel = "dirtbike", frontWheelModel = "dirtbikewheelfront", rearWheelModel = "dirtbikewheelrear",
        AltTopSpeed = 80.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.1, 1.85, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=-0.021, y=0.95, z=-0.2 }},
        frontDistanceToGrnd=0.39, frontSuspensionUpperLimit=-0.15, frontSuspensionLowerLimit=-0.25,
        rearWheelOffsets  = {{ x=0.0, y=-0.73, z=-0.25 }},
        rearDistanceToGrnd=0.36, rearSuspensionUpperLimit=-0.15, rearSuspensionLowerLimit=-0.3,
        headlightOffsets  = {{ x=-0.1, y=0.40, z=0.55, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=0.0, y=0.0, z=0.0, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.15, y=-0.8, z=0.8 }},
        cloneOffsets = { x=0.0, y=-0.2, z=0.65, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 15.0},
    },
    micahcycle = {
        type = "bike", soundType = "chopper",
        objectModel = "micahcycle", frontWheelModel = "micahcyclewheel", rearWheelModel = "micahcyclewheel",
        AltTopSpeed = 100.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 1.5, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.0, y=1.1, z=-0.3 }},
        frontDistanceToGrnd=0.37, frontSuspensionUpperLimit=-0.15, frontSuspensionLowerLimit=-0.3,
        rearWheelOffsets  = {{ x=0.0, y=-0.9, z=-0.3 }},
        rearDistanceToGrnd=0.37, rearSuspensionUpperLimit=-0.15, rearSuspensionLowerLimit=-0.3,
        headlightOffsets  = {{ x=0.0, y=1.0, z=0.3, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=0.0, y=-1.2, z=0.3, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.2, y=-1.0, z=0.3 }},
        cloneOffsets = { x=0.0, y=-0.2, z=0.5, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 15.0},
    },
    policebike = {
        type = "bike", soundType = "dirtbike",
        objectModel = "policebike", frontWheelModel = "policebikefrontwheel", rearWheelModel = "policebikerearwheel",
        AltTopSpeed = 120.0, AltAccelMultiplier = 0.25,
        attachOffsets = {-0.01, 1.6, -0.25, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.0, y=1.1, z=-0.3 }},
        frontDistanceToGrnd=0.37, frontSuspensionUpperLimit=-0.15, frontSuspensionLowerLimit=-0.3,
        rearWheelOffsets  = {{ x=0.0, y=-0.9, z=-0.3 }},
        rearDistanceToGrnd=0.37, rearSuspensionUpperLimit=-0.15, rearSuspensionLowerLimit=-0.3,
        headlightOffsets  = {{ x=0.0, y=1.0, z=0.4, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=0.0, y=-1.2, z=0.35, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.2, y=-1.0, z=0.3 }},
        cloneOffsets = { x=0.0, y=-0.2, z=0.55, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 15.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- CLASSIC CARS & STREET MACHINES
    -- ══════════════════════════════════════════════════════════════════
    delorean = {
        type = "car", soundType = "lancer",
        objectModel = "delorean", frontWheelModel = "deloreanwheel", rearWheelModel = "deloreanwheel",
        AltTopSpeed = 88.0, AltAccelMultiplier = 0.4,
        attachOffsets = {-0.01, 1.2, -0.1, 0.0, -0.1, 0.0},
        frontWheelOffsets = {{ x=1.00, y=1.54, z=-0.43 }, { x=-1.00, y=1.54, z=-0.43 }},
        frontDistanceToGrnd=0.35, frontSuspensionUpperLimit=-0.28, frontSuspensionLowerLimit=-0.45,
        rearWheelOffsets  = {{ x=1.00, y=-1.4, z=-0.39 }, { x=-1.00, y=-1.4, z=-0.39 }},
        rearDistanceToGrnd=0.33, rearSuspensionUpperLimit=-0.25, rearSuspensionLowerLimit=-0.45,
        headlightOffsets  = {{ x=-0.8, y=2.1, z=-0.14, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.1, z=-0.14, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.5, z=0.1 }, { x=-0.6, y=-2.5, z=0.1 }},
        cloneOffsets = { x=-0.48, y=-0.3, z=-0.13, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 15.0},
    },
    classic = {
        type = "car", soundType = "vintage",
        objectModel = "classic", frontWheelModel = "classicfront", rearWheelModel = "classicrear",
        AltTopSpeed = 80.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.5, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.9, y=1.5, z=-0.3 }, { x=-0.9, y=1.5, z=-0.3 }},
        frontDistanceToGrnd=0.38, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.4,
        rearWheelOffsets  = {{ x=0.9, y=-1.5, z=-0.3 }, { x=-0.9, y=-1.5, z=-0.3 }},
        rearDistanceToGrnd=0.38, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.4,
        headlightOffsets  = {{ x=-0.6, y=1.9, z=0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.6, y=1.9, z=0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.2, z=0.0 }},
        cloneOffsets = { x=-0.48, y=-0.2, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    classic2 = {
        type = "car", soundType = "vintage",
        objectModel = "classic2", frontWheelModel = "classicfront", rearWheelModel = "classicrear",
        AltTopSpeed = 80.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.5, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.9, y=1.5, z=-0.3 }, { x=-0.9, y=1.5, z=-0.3 }},
        frontDistanceToGrnd=0.38, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.4,
        rearWheelOffsets  = {{ x=0.9, y=-1.5, z=-0.3 }, { x=-0.9, y=-1.5, z=-0.3 }},
        rearDistanceToGrnd=0.38, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.4,
        headlightOffsets  = {{ x=-0.6, y=1.9, z=0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.6, y=1.9, z=0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.2, z=0.0 }},
        cloneOffsets = { x=-0.48, y=-0.2, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    vapidfordor = {
        type = "car", soundType = "vintage",
        objectModel = "vapidfordor", frontWheelModel = "ironfranklinwheel", rearWheelModel = "ironfranklinwheel",
        AltTopSpeed = 70.0, AltAccelMultiplier = 0.15,
        attachOffsets = {-0.01, 0.5, -0.05, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.85, y=1.4, z=-0.25 }, { x=-0.85, y=1.4, z=-0.25 }},
        frontDistanceToGrnd=0.36, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.4,
        rearWheelOffsets  = {{ x=0.85, y=-1.4, z=-0.25 }, { x=-0.85, y=-1.4, z=-0.25 }},
        rearDistanceToGrnd=0.36, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.4,
        headlightOffsets  = {{ x=-0.6, y=1.9, z=0.0, rx=0.0, ry=0.0, rz=0 }, { x=0.6, y=1.9, z=0.0, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.2, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    vapidtudor = {
        type = "car", soundType = "vintage",
        objectModel = "vapidtudor", frontWheelModel = "ironfranklinwheel", rearWheelModel = "ironfranklinwheel",
        AltTopSpeed = 70.0, AltAccelMultiplier = 0.15,
        attachOffsets = {-0.01, 0.5, -0.05, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.85, y=1.4, z=-0.25 }, { x=-0.85, y=1.4, z=-0.25 }},
        frontDistanceToGrnd=0.36, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.4,
        rearWheelOffsets  = {{ x=0.85, y=-1.4, z=-0.25 }, { x=-0.85, y=-1.4, z=-0.25 }},
        rearDistanceToGrnd=0.36, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.4,
        headlightOffsets  = {{ x=-0.6, y=1.9, z=0.0, rx=0.0, ry=0.0, rz=0 }, { x=0.6, y=1.9, z=0.0, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.2, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    muscle = {
        type = "car", soundType = "camaro",
        objectModel = "muscle", frontWheelModel = "musclewheel", rearWheelModel = "musclewheel",
        AltTopSpeed = 160.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 0.9, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.0, y=1.7, z=-0.35 }, { x=-1.0, y=1.7, z=-0.35 }},
        frontDistanceToGrnd=0.43, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=1.0, y=-1.7, z=-0.35 }, { x=-1.0, y=-1.7, z=-0.35 }},
        rearDistanceToGrnd=0.43, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=0.0, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=0.0, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.5, z=0.0 }, { x=-0.5, y=-2.5, z=0.0 }},
        cloneOffsets = { x=-0.48, y=-0.2, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- SPORTS & SUPERCARS
    -- ══════════════════════════════════════════════════════════════════
    roadster = {
        type = "car", soundType = "electric",
        objectModel = "ironroadster", frontWheelModel = "ironroadsterwheel", rearWheelModel = "ironroadsterwheel",
        AltTopSpeed = 250.0, AltAccelMultiplier = 0.4,
        attachOffsets = {-0.01, 1.2, -0.0, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.00, y=1.7, z=-0.38 }, { x=-1.00, y=1.7, z=-0.38 }},
        frontDistanceToGrnd=0.47, frontSuspensionUpperLimit=-0.3, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=1.00, y=-1.85, z=-0.30 }, { x=-1.00, y=-1.85, z=-0.30 }},
        rearDistanceToGrnd=0.41, rearSuspensionUpperLimit=-0.1, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.8, y=2.1, z=-0.14, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.1, z=-0.14, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.25, z=-0.13, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    franklin = {
        type = "car", soundType = "hellcat",
        objectModel = "ironfranklin", frontWheelModel = "ironfranklinwheel", rearWheelModel = "ironfranklinwheel",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 1.0, -0.02, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.95, z=-0.32 }, { x=-0.97, y=1.95, z=-0.32 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.63, z=-0.32 }, { x=-0.97, y=-1.63, z=-0.32 }},
        rearDistanceToGrnd=0.42, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.8, y=2.4, z=-0.0, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.4, z=-0.0, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.8, z=-0.1 }, { x=-0.6, y=-2.8, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.12, z=0.00, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    michael = {
        type = "car", soundType = "sport",
        objectModel = "ironmichael", frontWheelModel = "ironmichaelwheel", rearWheelModel = "ironmichaelwheel",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 1.0, -0.02, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.75, z=-0.32 }, { x=-0.97, y=1.75, z=-0.32 }},
        frontDistanceToGrnd=0.47, frontSuspensionUpperLimit=-0.3, frontSuspensionLowerLimit=-0.45,
        rearWheelOffsets  = {{ x=0.97, y=-1.6, z=-0.32 }, { x=-0.97, y=-1.6, z=-0.32 }},
        rearDistanceToGrnd=0.47, rearSuspensionUpperLimit=-0.3, rearSuspensionLowerLimit=-0.45,
        headlightOffsets  = {{ x=-0.7, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.6, z=-0.1 }, { x=-0.6, y=-2.6, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.12, z=0.00, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    trevor = {
        type = "car", soundType = "truck",
        objectModel = "irontrevor", frontWheelModel = "irontrevorwheel", rearWheelModel = "irontrevorwheel",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.59, 0.18, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.23, y=2.0, z=-0.52 }, { x=-1.23, y=2.0, z=-0.52 }},
        frontDistanceToGrnd=0.47, frontSuspensionUpperLimit=-0.48, frontSuspensionLowerLimit=-0.7,
        rearWheelOffsets  = {{ x=1.23, y=-1.9, z=-0.52 }, { x=-1.23, y=-1.9, z=-0.52 }},
        rearDistanceToGrnd=0.47, rearSuspensionUpperLimit=-0.1, rearSuspensionLowerLimit=-0.7,
        headlightOffsets  = {{ x=-0.7, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.8, y=-3.3, z=-0.1 }, { x=-0.8, y=-3.3, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    hellcat = {
        type = "car", soundType = "hellcat",
        objectModel = "hellcat", frontWheelModel = "hellcatwheel", rearWheelModel = "hellcatwheel",
        AltTopSpeed = 200.0, AltAccelMultiplier = 0.4,
        attachOffsets = {-0.01, 1.0, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.95, y=1.8, z=-0.35 }, { x=-0.95, y=1.8, z=-0.35 }},
        frontDistanceToGrnd=0.44, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.95, y=-1.7, z=-0.35 }, { x=-0.95, y=-1.7, z=-0.35 }},
        rearDistanceToGrnd=0.44, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.8, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.8, z=-0.1 }, { x=-0.6, y=-2.8, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    g37 = {
        type = "car", soundType = "sport",
        objectModel = "g37", frontWheelModel = "g37wheel", rearWheelModel = "g37wheel",
        AltTopSpeed = 180.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 1.0, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.95, y=1.7, z=-0.35 }, { x=-0.95, y=1.7, z=-0.35 }},
        frontDistanceToGrnd=0.43, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.95, y=-1.6, z=-0.35 }, { x=-0.95, y=-1.6, z=-0.35 }},
        rearDistanceToGrnd=0.43, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.5, z=-0.1 }, { x=-0.6, y=-2.5, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironlambo = {
        type = "car", soundType = "lambo",
        objectModel = "ironlambo", frontWheelModel = "ironlambowheel", rearWheelModel = "ironlambowheel",
        AltTopSpeed = 250.0, AltAccelMultiplier = 0.4,
        attachOffsets = {-0.01, 1.0, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.95, y=1.6, z=-0.3 }, { x=-0.95, y=1.6, z=-0.3 }},
        frontDistanceToGrnd=0.38, frontSuspensionUpperLimit=-0.15, frontSuspensionLowerLimit=-0.35,
        rearWheelOffsets  = {{ x=0.95, y=-1.55, z=-0.3 }, { x=-0.95, y=-1.55, z=-0.3 }},
        rearDistanceToGrnd=0.38, rearSuspensionUpperLimit=-0.15, rearSuspensionLowerLimit=-0.35,
        headlightOffsets  = {{ x=-0.8, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.2, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironsport = {
        type = "car", soundType = "lambo",
        objectModel = "ironsport", frontWheelModel = "ironsportwheel", rearWheelModel = "ironsportwheel",
        AltTopSpeed = 220.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 1.0, -0.29, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.95, y=1.46, z=-0.17 }, { x=-0.95, y=1.46, z=-0.17 }},
        frontDistanceToGrnd=0.34, frontSuspensionUpperLimit=-0.13, frontSuspensionLowerLimit=-0.25,
        rearWheelOffsets  = {{ x=0.95, y=-1.43, z=-0.15 }, { x=-0.95, y=-1.43, z=-0.15 }},
        rearDistanceToGrnd=0.37, rearSuspensionUpperLimit=-0.11, rearSuspensionLowerLimit=-0.25,
        headlightOffsets  = {{ x=-0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.40, y=-0.20, z=0.00, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    irongtr = {
        type = "car", soundType = "hellcat",
        objectModel = "irongtr", frontWheelModel = "irongtrwheel", rearWheelModel = "irongtrwheel",
        AltTopSpeed = 230.0, AltAccelMultiplier = 0.4,
        attachOffsets = {-0.01, 1.0, -0.15, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.75, z=-0.35 }, { x=-0.97, y=1.75, z=-0.35 }},
        frontDistanceToGrnd=0.44, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.65, z=-0.35 }, { x=-0.97, y=-1.65, z=-0.35 }},
        rearDistanceToGrnd=0.44, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.8, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.3, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironcharger = {
        type = "car", soundType = "vintage",
        objectModel = "ironcharger", frontWheelModel = "ironchargerfrontwheel", rearWheelModel = "ironchargerrearwheel",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.8, -0.4, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.00, y=2.0, z=0.1 }, { x=-1.00, y=2.0, z=0.1 }},
        frontDistanceToGrnd=0.44, frontSuspensionUpperLimit=0.2, frontSuspensionLowerLimit=-0.2,
        rearWheelOffsets  = {{ x=1.00, y=-1.8, z=0.1 }, { x=-1.00, y=-1.8, z=0.1 }},
        rearDistanceToGrnd=0.44, rearSuspensionUpperLimit=0.2, rearSuspensionLowerLimit=-0.2,
        headlightOffsets  = {{ x=-0.7, y=2.3, z=-0.05, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.3, z=-0.05, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.6, z=-0.1 }, { x=-0.5, y=-2.6, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.1, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironstang = {
        type = "car", soundType = "mustang",
        objectModel = "ironstang", frontWheelModel = "ironsportwheel", rearWheelModel = "ironsportwheel",
        AltTopSpeed = 200.0, AltAccelMultiplier = 0.35,
        attachOffsets = {-0.01, 0.9, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.75, z=-0.32 }, { x=-0.97, y=1.75, z=-0.32 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.65, z=-0.32 }, { x=-0.97, y=-1.65, z=-0.32 }},
        rearDistanceToGrnd=0.42, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.5, z=-0.1 }, { x=-0.5, y=-2.5, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ninetystang = {
        type = "car", soundType = "mustang",
        objectModel = "ninetystang", frontWheelModel = "ninetystangfrontwheel", rearWheelModel = "ninetystangrearwheel",
        AltTopSpeed = 190.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 0.9, -0.2, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.7, z=-0.32 }, { x=-0.97, y=1.7, z=-0.32 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.65, z=-0.32 }, { x=-0.97, y=-1.65, z=-0.32 }},
        rearDistanceToGrnd=0.42, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.5, z=-0.1 }, { x=-0.5, y=-2.5, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironcamaro = {
        type = "car", soundType = "camaro",
        objectModel = "ironcamaro", frontWheelModel = "ironsportwheel", rearWheelModel = "ironsportwheel",
        AltTopSpeed = 180.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 0.9, -0.15, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.75, z=-0.32 }, { x=-0.97, y=1.75, z=-0.32 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.65, z=-0.32 }, { x=-0.97, y=-1.65, z=-0.32 }},
        rearDistanceToGrnd=0.42, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.5, z=-0.1 }, { x=-0.5, y=-2.5, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    lancer = {
        type = "car", soundType = "lancer",
        objectModel = "lancer", frontWheelModel = "ironsportwheel", rearWheelModel = "ironsportwheel",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 1.0, 0.05, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.9, y=1.5, z=-0.45 }, { x=-0.9, y=1.5, z=-0.45 }},
        frontDistanceToGrnd=0.4, frontSuspensionUpperLimit=-0.4, frontSuspensionLowerLimit=-0.6,
        rearWheelOffsets  = {{ x=0.9, y=-1.53, z=-0.46 }, { x=-0.9, y=-1.53, z=-0.46 }},
        rearDistanceToGrnd=0.4, rearSuspensionUpperLimit=-0.4, rearSuspensionLowerLimit=-0.6,
        headlightOffsets  = {{ x=-0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.5, z=-0.2 }},
        cloneOffsets = { x=-0.38, y=-0.20, z=-0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironmalibu = {
        type = "car", soundType = "sport",
        objectModel = "ironmalibu", frontWheelModel = "ironmalibuwheel", rearWheelModel = "ironmalibuwheel",
        AltTopSpeed = 160.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 0.9, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.7, z=-0.32 }, { x=-0.97, y=1.7, z=-0.32 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.6, z=-0.32 }, { x=-0.97, y=-1.6, z=-0.32 }},
        rearDistanceToGrnd=0.42, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.5, z=-0.1 }, { x=-0.5, y=-2.5, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironimpala = {
        type = "car", soundType = "sport",
        objectModel = "ironimpala", frontWheelModel = "ironimpalawheel", rearWheelModel = "ironimpalawheel",
        AltTopSpeed = 160.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 0.9, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.7, z=-0.32 }, { x=-0.97, y=1.7, z=-0.32 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.6, z=-0.32 }, { x=-0.97, y=-1.6, z=-0.32 }},
        rearDistanceToGrnd=0.42, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=2.2, z=-0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.5, y=-2.5, z=-0.1 }, { x=-0.5, y=-2.5, z=-0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    policesuv = {
        type = "car", soundType = "sport",
        objectModel = "policesuv", frontWheelModel = "policesuvwheel", rearWheelModel = "policesuvwheel",
        AltTopSpeed = 170.0, AltAccelMultiplier = 0.3,
        attachOffsets = {-0.01, 0.9, 0.0, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.0, y=1.8, z=-0.35 }, { x=-1.0, y=1.8, z=-0.35 }},
        frontDistanceToGrnd=0.45, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=1.0, y=-1.7, z=-0.35 }, { x=-1.0, y=-1.7, z=-0.35 }},
        rearDistanceToGrnd=0.45, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.8, y=2.3, z=0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.3, z=0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironsuv = {
        type = "car", soundType = "sport",
        objectModel = "ironsuv", frontWheelModel = "ironsuvwheel", rearWheelModel = "ironsuvwheel",
        AltTopSpeed = 160.0, AltAccelMultiplier = 0.25,
        attachOffsets = {-0.01, 0.9, 0.0, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.0, y=1.8, z=-0.35 }, { x=-1.0, y=1.8, z=-0.35 }},
        frontDistanceToGrnd=0.45, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=1.0, y=-1.7, z=-0.35 }, { x=-1.0, y=-1.7, z=-0.35 }},
        rearDistanceToGrnd=0.45, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.8, y=2.3, z=0.1, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.3, z=0.1, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironrancher = {
        type = "car", soundType = "oldtruck",
        objectModel = "ironrancher", frontWheelModel = "ironrancherwheel", rearWheelModel = "ironrancherwheel",
        AltTopSpeed = 120.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 0.6, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=0.97, y=1.6, z=-0.35 }, { x=-0.97, y=1.6, z=-0.35 }},
        frontDistanceToGrnd=0.44, frontSuspensionUpperLimit=-0.2, frontSuspensionLowerLimit=-0.5,
        rearWheelOffsets  = {{ x=0.97, y=-1.5, z=-0.35 }, { x=-0.97, y=-1.5, z=-0.35 }},
        rearDistanceToGrnd=0.44, rearSuspensionUpperLimit=-0.2, rearSuspensionLowerLimit=-0.5,
        headlightOffsets  = {{ x=-0.7, y=1.9, z=0.2, rx=0.0, ry=0.0, rz=0 }, { x=0.7, y=1.9, z=0.2, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        exhaustOffsets    = {{ x=0.6, y=-2.5, z=0.1 }},
        cloneOffsets = { x=-0.48, y=-0.15, z=0.1, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- SPECIAL / ICONIC
    -- ══════════════════════════════════════════════════════════════════
    bat = {
        type = "car", soundType = "bat",
        objectModel = "ironmobile", frontWheelModel = "ironmobilewheelfront", rearWheelModel = "ironmobilewheelrear",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.2,
        attachOffsets = {-0.01, 1.0, -0.1, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.27, y=1.95, z=-0.28 }, { x=-1.27, y=1.95, z=-0.28 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=-0.24, frontSuspensionLowerLimit=-0.4,
        rearWheelOffsets  = {{ x=1.12, y=-1.95, z=-0.2 }, { x=-1.15, y=-1.95, z=-0.2 }},
        rearDistanceToGrnd=0.51, rearSuspensionUpperLimit=-0.15, rearSuspensionLowerLimit=-0.4,
        headlightOffsets  = {{ x=-0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.1, y=-0.38, z=-0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    batclassic = {
        type = "car", soundType = "bat",
        objectModel = "ironmobile2", frontWheelModel = "ironmobile2wheelfront", rearWheelModel = "ironmobile2wheelrear",
        AltTopSpeed = 150.0, AltAccelMultiplier = 0.5,
        attachOffsets = {-0.01, 1.0, -0.3, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.05, y=1.67, z=-0.08 }, { x=-1.05, y=1.67, z=-0.08 }},
        frontDistanceToGrnd=0.42, frontSuspensionUpperLimit=0.02, frontSuspensionLowerLimit=-0.15,
        rearWheelOffsets  = {{ x=1.1, y=-2.43, z=-0.0 }, { x=-1.1, y=-2.43, z=-0.0 }},
        rearDistanceToGrnd=0.51, rearSuspensionUpperLimit=0.1, rearSuspensionLowerLimit=-0.15,
        headlightOffsets  = {{ x=-0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }, { x=0.8, y=2.2, z=-0.03, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.1, y=-1.1, z=0.1, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    ironprime = {
        type = "car", soundType = "bigtruck",
        objectModel = "ironprime", frontWheelModel = "irontruckliftedwheel", rearWheelModel = "irontruckliftedwheel",
        AltTopSpeed = 80.0, AltAccelMultiplier = 0.15,
        attachOffsets = {-0.01, 0.0, 0.5, 0.0, 0.0, 0.0},
        frontWheelOffsets = {{ x=1.3, y=2.5, z=-0.8 }, { x=-1.3, y=2.5, z=-0.8 }},
        frontDistanceToGrnd=0.5, frontSuspensionUpperLimit=-0.3, frontSuspensionLowerLimit=-1.0,
        rearWheelOffsets  = {{ x=1.3, y=-2.0, z=-0.8 }, { x=-1.3, y=-2.0, z=-0.8 }},
        rearDistanceToGrnd=0.5, rearSuspensionUpperLimit=-0.3, rearSuspensionLowerLimit=-1.0,
        headlightOffsets  = {{ x=-1.0, y=3.0, z=0.5, rx=0.0, ry=0.0, rz=0 }, { x=1.0, y=3.0, z=0.5, rx=0.0, ry=0.0, rz=0 }},
        brakelightOffsets = {{ x=-0.2, y=-3.0, z=-2.2, rx=-40.0, ry=0.0, rz=180 }},
        cloneOffsets = { x=-0.5, y=0.5, z=0.5, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- BOATS & WATER VEHICLES
    -- ══════════════════════════════════════════════════════════════════
    jetski = {
        type = "boat", soundType = "jetski",
        objectModel = "jetski",
        attachOffsets = {-0.01, 0.0, -0.4, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.0, y=-0.35, z=1.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    speedboat = {
        type = "boat", soundType = "speedboat",
        objectModel = "speedboat",
        attachOffsets = {-0.01, -0.2, -0.4, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.75, y=1.3, z=1.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    bigboat = {
        type = "boat", soundType = "speedboat",
        objectModel = "bigboat",
        attachOffsets = {-0.01, 0.0, -0.4, 0.0, 0.0, 0.0},
        cloneOffsets = { x=1.6, y=1.9, z=2.9, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    lamboboat = {
        type = "boat", soundType = "speedboat",
        objectModel = "lamboboat",
        attachOffsets = {-0.01, 0.0, -0.4, 0.0, 0.0, 0.0},
        cloneOffsets = { x=1.6, y=1.9, z=2.9, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    biggerboat = {
        type = "boat", soundType = "speedboat",
        objectModel = "biggerboat",
        attachOffsets = {-0.01, 0.0, -0.4, 0.0, 0.0, 0.0},
        cloneOffsets = { x=1.8, y=2.0, z=3.0, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {13.0, 16.0, 20.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- HELICOPTERS
    -- ══════════════════════════════════════════════════════════════════
    heli = {
        type = "heli", soundType = "heli",
        objectModel = "heli",
        topbladeModel = "helitopblade", rearbladeModel = "helirearblade",
        topbladeOffsets = {x=0.0, y=0.0, z=2.3},
        rearbladeOffsets = {x=-0.3, y=-4.5, z=1.5},
        attachOffsets = {-0.0, 0.0, 0.4, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.6, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    polheli = {
        type = "heli", soundType = "heli",
        objectModel = "polheli",
        topbladeModel = "polhelitopblade", rearbladeModel = "polhelirearblade",
        topbladeOffsets = {x=0.0, y=0.3, z=2.2},
        rearbladeOffsets = {x=-0.3, y=-4.2, z=1.4},
        attachOffsets = {-0.0, 0.3, 0.35, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.5, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    heli2 = {
        type = "heli", soundType = "heli",
        objectModel = "heli2",
        topbladeModel = "heli2topblade", rearbladeModel = "heli2rearblade",
        topbladeOffsets = {x=0.0, y=2.5, z=2.15},
        rearbladeOffsets = {x=-0.3, y=-4.95, z=1.8},
        attachOffsets = {-0.0, 2.5, 0.35, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.6, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
    cargobob = {
        type = "cargobob", soundType = "heli",
        objectModel = "cargobob",
        bladeModel = "helitopblade", doorModel = "cargobobdoor",
        frontbladeOffsets = {x=-0.3, y=3.9, z=5.1},
        rearbladeOffsets  = {x=-0.1, y=-7.5, z=5.6},
        doorattachOffsets = {-0.2, -5.65, 0.05, 15.0, 0.0, 0.0},
        attachOffsets     = {-0.2, -1.0, 1.1, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.7, y=6.5, z=0.45, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },
    osprey = {
        type = "osprey", soundType = "heli",
        objectModel = "osprey",
        bladeModel = "ospreyblade", doorModel = "ospreydoor",
        leftthrusterModel  = "ospreyleftthruster", rightthrusterModel = "ospreyrightthruster",
        attachOffsets     = {-0.2, -1.8, 1.7, 0.0, 0.0, 0.0},
        leftbladeOffsets  = {x=0.0, y=-0.05, z=1.9},
        rightbladeOffsets = {x=-0.0, y=-0.05, z=1.9},
        doorattachOffsets = {-0.2, -5.3, 0.42, 0.0, 0.0, 0.0},
        leftthrusterattachOffsets  = {x=-8.55, y=0.3, z=4.23},
        rightthrusterattachOffsets = {x=8.3,   y=0.3, z=4.28},
        cloneOffsets = { x=-0.7, y=5.9, z=0.15, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {10.0, 15.0, 20.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- PLANES & AIRCRAFT
    -- ══════════════════════════════════════════════════════════════════
    biplane = {
        type = "plane", soundType = "plane",
        objectModel = "biplane", propellerModel = "biplaneprop",
        propellerOffsets = {x=0.0, y=2.5, z=0.4},
        attachOffsets = {-0.0, 0.0, -0.2, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.0, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },
    biplane2 = {
        type = "plane", soundType = "plane",
        objectModel = "biplane2", propellerModel = "biplaneprop",
        propellerOffsets = {x=0.0, y=2.5, z=0.4},
        attachOffsets = {-0.0, 0.0, -0.2, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.0, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },
    triplane = {
        type = "plane", soundType = "plane",
        objectModel = "triplane", propellerModel = "triplaneprop",
        propellerOffsets = {x=0.0, y=2.8, z=0.3},
        attachOffsets = {-0.0, 0.0, -0.2, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.0, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },
    fireplane = {
        type = "plane", soundType = "plane",
        objectModel = "fireplane", propellerModel = "fireplaneprop",
        propellerOffsets = {x=0.0, y=3.0, z=0.2},
        attachOffsets = {-0.0, 0.0, -0.2, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.5, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },
    xwing = {
        type = "jet", soundType = "xwing",
        objectModel = "xwing",
        exhaustOffsets = {{ x=0.5, y=-3.5, z=-0.3 }, { x=-0.5, y=-3.5, z=-0.3 }},
        attachOffsets = {-0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.5, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },
    aten = {
        type = "jet", soundType = "jet",
        objectModel = "aten",
        exhaustOffsets = {{ x=0.5, y=-3.5, z=-0.3 }, { x=-0.5, y=-3.5, z=-0.3 }},
        attachOffsets = {-0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        cloneOffsets = { x=-0.5, y=1.5, z=0.3, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {8.0, 12.0, 18.0},
    },

    -- ══════════════════════════════════════════════════════════════════
    -- TANK
    -- ══════════════════════════════════════════════════════════════════
    irontank = {
        type = "tank", soundType = "bigtruck",
        objectModel = "irontank", tanktopModel = "irontanktop",
        attachOffsets  = {-0.01, 0.0, 0.15, 0.0, 0.0, 0.0},
        tanktopOffsets = { x=-0.0, y=-0.0, z=0.15, rx=0.0, ry=0.0, rz=0.0 },
        cloneOffsets   = { x=-0.0, y=-1.5, z=0.65, rx=0.0, ry=0.0, rz=0.0 },
        ThirdPersonCamDistances = {5.0, 8.0, 12.0},
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Enable verbose debug output to console

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ STARTUP BANNER ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

CreateThread(function()
    Wait(1000)
    local totalVehicles = 0
    for _ in pairs(Config.Vehicles) do totalVehicles = totalVehicles + 1 end
    local totalDealerships = #Config.Dealerships
    print([[

        ═══════════════════════════════════════════════════════════════════════════════

            ██╗     ██╗  ██╗██████╗        ██╗   ██╗███████╗██╗  ██╗██╗ ██████╗██╗     ███████╗███████╗
            ██║     ╚██╗██╔╝██╔══██╗       ██║   ██║██╔════╝██║  ██║██║██╔════╝██║     ██╔════╝██╔════╝
            ██║      ╚███╔╝ ██████╔╝█████╗ ██║   ██║█████╗  ███████║██║██║     ██║     █████╗  ███████╗
            ██║      ██╔██╗ ██╔══██╗╚════╝ ╚██╗ ██╔╝██╔══╝  ██╔══██║██║██║     ██║     ██╔══╝  ╚════██║
            ███████╗██╔╝ ██╗██║  ██║        ╚████╔╝ ███████╗██║  ██║██║╚██████╗███████╗███████╗███████║
            ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚══════╝╚══════╝

            ██████╗██╗      █████╗ ███████╗███████╗██╗ ██████╗
            ██╔════╝██║     ██╔══██╗██╔════╝██╔════╝██║██╔════╝
            ██║     ██║     ███████║███████╗███████╗██║██║
            ██║     ██║     ██╔══██║╚════██║╚════██║██║██║
            ╚██████╗███████╗██║  ██║███████║███████║██║╚██████╗
             ╚═════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝

        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LXR VEHICLES CLASSIC — SUCCESSFULLY LOADED
        ═══════════════════════════════════════════════════════════════════════════════

        Version:      2.0.0
        Server:       ]] .. Config.ServerInfo.name .. [[

        Framework:    ]] .. Config.Framework .. [[

        Vehicles:     ]] .. totalVehicles .. [[ registered
        Dealerships:  ]] .. totalDealerships .. [[ locations

        Dealership:   ]] .. (Config.Features.Dealership and 'ENABLED  ✓' or 'DISABLED ✗') .. [[

        DB Ownership: ]] .. (Config.Features.DatabaseOwnership and 'ENABLED  ✓' or 'DISABLED ✗') .. [[

        Admin Spawn:  ]] .. (Config.Features.AdminSpawn and 'ENABLED  ✓' or 'DISABLED ✗') .. [[

        Public Spawn: ]] .. (Config.Features.PublicSpawn and 'ENABLED  ✓' or 'DISABLED ✗') .. [[

        Debug:        ]] .. (Config.Debug and 'ENABLED' or 'DISABLED') .. [[


        ═══════════════════════════════════════════════════════════════════════════════
        Developer:    iBoss21 / The Lux Empire
        Website:      https://www.wolves.land
        Discord:      https://discord.gg/CrKcWdfd3A
        ═══════════════════════════════════════════════════════════════════════════════

    ]])
end)
