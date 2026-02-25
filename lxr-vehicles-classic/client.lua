--[[
    ██╗     ██╗  ██╗██████╗        ██╗   ██╗███████╗██╗  ██╗██╗ ██████╗██╗     ███████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██║   ██║██╔════╝██║  ██║██║██╔════╝██║     ██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝        ██║   ██║█████╗  ███████║██║██║     ██║     █████╗  ███████╗
    ██║      ██╔██╗ ██╔══██╗        ╚██╗ ██╔╝██╔══╝  ██╔══██║██║██║     ██║     ██╔══╝  ╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ╚████╔╝ ███████╗██║  ██║██║╚██████╗███████╗███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝          ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚══════╝╚══════╝
    🐺 LXR Vehicles Classic — client.lua
    wolves.land | The Land of Wolves | © 2026 iBoss21 / The Lux Empire
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ STATE VARIABLES ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local vehicles = Config.Vehicles

-- Active vehicle state
local currentVehicle        = nil
local clonePed              = nil
local cloneOffsets          = nil
local distanceStates        = nil

-- Physics / motion helpers
local currentRotationAngle        = 0.0
local turnSmoothing               = 20.0
local turningRight                = false
local turningLeft                 = false
local currentTurnAngle            = 0.0
local thrusterCurrentRotationAngle = 0.0
local thrusterTargetRotationAngle  = 0.0
local thrusterRotationSpeed        = 1.0
local thrusterRotated              = false
local flightMode                   = false
local currentForce                 = 0
local decayRate                    = 0.02
local doorOpen                     = false
local maxDoorRotationAngle         = 34.0
local doorRotationSpeed            = 1.0
local currentDoorRotationAngle     = 0.0
local currentBaseSpeed             = 0
local maxBaseSpeed                 = 3.2
local speedIncrement               = 0.005
local maxSpeedMPH                  = 40
local maxSpeedMetersPerSecond      = maxSpeedMPH / 2.23694

-- Camera
local vKey              = 0x7F8D09B8
local currentStateIndex = 1
local camDistance       = 1.0
local animationPlayed   = false
local objectVisible     = true
local firstEntry        = true
local scaleSet          = false

-- Particle effects
local new_ptfx_dictionary   = "core"
local new_ptfx_name         = "ent_amb_smoke_cabin"
local is_particle_effect_active = false
local current_ptfx_handles  = {}

-- Sound
local idleSound  = "truckidle.wav"
local startSound = "truckstart.wav"
local stopSound  = "truckstop.wav"
local weaponType = nil
local AltTopSpeed        = 50.0
local AltAccelMultiplier = 0.2

-- Suspension / Attachment globals
local topPropellerOffset = nil
local rearBladeOffset    = nil
local tanktopOffsets     = nil
local doorattach         = nil
local propellerOffset    = nil
local leftThrustOffset   = nil
local rightThrustOffset  = nil

-- Key codes
local keyD         = 0x7065027D
local keyA         = 0xB4E465B4
local keyW         = 0x8FD015D8
local keyShift     = 0x8FFC75D6
local keyAlt       = 0x8AAA0AD4
local keyS         = 0xD27782E3
local keyLeftClick = 0x07CE1E61
local keyRightClick = 0xF84FA74F
local keySpace     = 0xD9D0E1C0

-- Dealership state
local dealerNPCs          = {}
local dealerBlips         = {}
local dealerPromptGroup   = GetRandomIntInRange(0, 0xffffff)
local dealerPrompt        = nil
local nearDealerIndex     = nil
local playerGarage        = {}      -- {id, modelname, name, type}
local shopOpen            = false

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NOTIFICATIONS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local VORPcore = nil

RegisterNetEvent("lxr-vehicles:notify")
AddEventHandler("lxr-vehicles:notify", function(title, msg, dict, txtr, duration)
    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, true)
        while not HasStreamedTextureDictLoaded(dict) do Citizen.Wait(5) end
    end
    if Config.Features.VorpNotif then
        if not VORPcore then
            TriggerEvent("getCore", function(core) VORPcore = core end)
        end
        if VORPcore then VORPcore.NotifyAvanced(title, msg, dict, txtr, "COLOR_PURE_WHITE", duration) end
    else
        exports[GetCurrentResourceName()].LeftNot(0, tostring(title), tostring(msg),
            tostring(dict), tostring(txtr), tonumber(duration))
    end
    SetStreamedTextureDictAsNoLongerNeeded(dict)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SOUND HELPERS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local SOUND_MAP = {
    truck     = {"truckidle.wav",       "truckstart.wav",       "truckstop.wav"},
    bigtruck  = {"bigtruckidle.wav",    "bigtruckstart.wav",    "bigtruckstop.wav"},
    bat       = {"batidle.wav",         "batstart.wav",         "batstop.wav"},
    camaro    = {"camaroidle.wav",      "camarostart.wav",      "camarostop.wav"},
    dirtbike  = {"dirtbikeidle.wav",    "dirtbikestart.wav",    "dirtbikestop.wav"},
    electric  = {"electricidle.wav",    "electricstart.wav",    "electricstop.wav"},
    hellcat   = {"hellcatidle.wav",     "hellcatstart.wav",     "hellcatstop.wav"},
    heli      = {"heliidle.wav",        "helistart.wav",        "helistop.wav"},
    chopper   = {"chopperbikeidle.wav", "chopperbikestart.wav", "chopperbikestop.wav"},
    moped     = {"mopedidle.wav",       "mopedstart.wav",       "mopedstop.wav"},
    lambo     = {"lamboidle.wav",       "lambostart.wav",       "lambostop.wav"},
    lancer    = {"lanceridle.wav",      "lancerstart.wav",      "lancerstop.wav"},
    mustang   = {"mustangidle.wav",     "mustangstart.wav",     "mustangstop.wav"},
    plane     = {"planeidle.wav",       "planestart.wav",       "planestop.wav"},
    jet       = {"jetidle.wav",         "jetstart.wav",         "jetstop.wav"},
    xwing     = {"xwingidle.wav",       "xwingstart.wav",       "xwingstop.wav"},
    jetski    = {"jetskiidle.wav",      "jetskistart.wav",      "jetskistop.wav"},
    speedboat = {"speedboatidle.wav",   "speedboatstart.wav",   "speedboatstop.wav"},
    sport     = {"sportcaridle.wav",    "sportcarstart.wav",    "sportcarstop.wav"},
    vintage   = {"vintageidle.wav",     "vintagestart.wav",     "vintagestop.wav"},
    oldtruck  = {"oldtruckidle.wav",    "oldtruckstart.wav",    "oldtruckstop.wav"},
}

local function SetVehicleSounds(soundType)
    local sounds = SOUND_MAP[soundType] or SOUND_MAP["truck"]
    idleSound  = sounds[1]
    startSound = sounds[2]
    stopSound  = sounds[3]
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ VEHICLE SPAWN CORE ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local function DeleteCurrentVehicle()
    if not currentVehicle then return end

    DeleteEntity(currentVehicle.vehicle)
    DeleteEntity(currentVehicle.object)

    weaponType = nil

    if currentVehicle.type == 'bike' or currentVehicle.type == 'car' then
        for _, h in ipairs(current_ptfx_handles) do StopParticleFxLooped(h, false) end
        current_ptfx_handles = {}
        is_particle_effect_active = false
        if currentVehicle.exhausts then
            for _, e in ipairs(currentVehicle.exhausts) do DeleteEntity(e) end
        end
        if currentVehicle.headlights then
            for _, h in ipairs(currentVehicle.headlights) do DeleteEntity(h) end
        end
        if currentVehicle.brakeLights then
            for _, b in ipairs(currentVehicle.brakeLights) do DeleteEntity(b) end
        end
        if currentVehicle.wheels then
            for _, w in ipairs(currentVehicle.wheels.front or {}) do DeleteEntity(w) end
            for _, w in ipairs(currentVehicle.wheels.rear  or {}) do DeleteEntity(w) end
        end
    end

    if currentVehicle.type == 'heli' or currentVehicle.type == 'osprey' or currentVehicle.type == 'cargobob' then
        if currentVehicle.topPropeller then DeleteEntity(currentVehicle.topPropeller) end
        if currentVehicle.rearBlade    then DeleteEntity(currentVehicle.rearBlade) end
        if currentVehicle.leftThruster then DeleteEntity(currentVehicle.leftThruster) end
        if currentVehicle.rightThruster then DeleteEntity(currentVehicle.rightThruster) end
        if currentVehicle.doorobj      then DeleteEntity(currentVehicle.doorobj) end
    end
    if currentVehicle.type == 'tank'  then if currentVehicle.tanktop   then DeleteEntity(currentVehicle.tanktop) end end
    if currentVehicle.type == 'plane' then if currentVehicle.propeller then DeleteEntity(currentVehicle.propeller) end end

    if clonePed then DeleteEntity(clonePed); clonePed = nil end

    firstEntry  = true
    scaleSet    = false
    currentVehicle = nil
    SetEntityVisible(PlayerPedId(), true)
end

-- ── Main spawn function ───────────────────────────────────────────────────────
local function spawnVehicle(vehicleConfig)
    ExecuteCommand(Config.Keys.DeleteVeh)
    Citizen.Wait(150)
    if currentVehicle then return end

    local pc          = GetEntityCoords(PlayerPedId())
    local vehicleModel = GetHashKey(vehicleConfig.objectModel)
    local attach      = vehicleConfig.attachOffsets

    SetVehicleSounds(vehicleConfig.soundType or "truck")

    if vehicleConfig.weaponType then weaponType = vehicleConfig.weaponType end
    if vehicleConfig.AltTopSpeed       then AltTopSpeed        = vehicleConfig.AltTopSpeed end
    if vehicleConfig.AltAccelMultiplier then AltAccelMultiplier = vehicleConfig.AltAccelMultiplier end

    -- ── CAR / BIKE ──────────────────────────────────────────────────────────
    if vehicleConfig.type == 'car' or vehicleConfig.type == 'bike' then
        local baseModel = GetHashKey("buggy01")
        RequestModel(baseModel); RequestModel(vehicleModel)
        while not HasModelLoaded(baseModel) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end

        local vehicle = CreateVehicle(baseModel, pc.x + 2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150)
        FreezeEntityPosition(vehicle, 1)
        SetEntityVisible(vehicle, 0)
        Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0,
            attach[1], attach[2], attach[3], attach[4], attach[5], attach[6],
            0, 1, 1, 0, 0, 2)

        -- Wheels
        local wheels = {front = {}, rear = {}}
        local wheelFrontModel = GetHashKey(vehicleConfig.frontWheelModel)
        local wheelRearModel  = GetHashKey(vehicleConfig.rearWheelModel)
        RequestModel(wheelFrontModel); RequestModel(wheelRearModel)
        while not HasModelLoaded(wheelFrontModel) or not HasModelLoaded(wheelRearModel) do Citizen.Wait(5) end

        if vehicleConfig.type == 'car' then
            for _, off in ipairs(vehicleConfig.frontWheelOffsets) do
                local w = CreateObject(wheelFrontModel, pc.x, pc.y, pc.z, 1, 1, 1)
                AttachEntityToEntity(w, vehicle, 0, off.x, off.y, off.z, 0, 0, 0, 0, 0, 0, 0, 2, 2)
                local dist   = vehicleConfig.frontDistanceToGrnd
                local upper  = vehicleConfig.frontSuspensionUpperLimit
                local lower  = vehicleConfig.frontSuspensionLowerLimit
                Citizen.InvokeNative(0x9AA71BE56D8A0C14, w, dist, upper, lower, vehicle, true)
                table.insert(wheels.front, w)
            end
            for _, off in ipairs(vehicleConfig.rearWheelOffsets) do
                local w = CreateObject(wheelRearModel, pc.x, pc.y, pc.z, 1, 1, 1)
                AttachEntityToEntity(w, vehicle, 0, off.x, off.y, off.z, 0, 0, 0, 0, 0, 0, 0, 2, 2)
                local dist   = vehicleConfig.rearDistanceToGrnd
                local upper  = vehicleConfig.rearSuspensionUpperLimit
                local lower  = vehicleConfig.rearSuspensionLowerLimit
                Citizen.InvokeNative(0x9AA71BE56D8A0C14, w, dist, upper, lower, vehicle, true)
                table.insert(wheels.rear, w)
            end
        else -- bike
            for _, off in ipairs(vehicleConfig.frontWheelOffsets) do
                local w = CreateObject(wheelFrontModel, pc.x, pc.y, pc.z, 1, 1, 1)
                AttachEntityToEntity(w, vehicle, 0, off.x, off.y, off.z, 0, 0, 0, 0, 0, 0, 0, 2, 2)
                local dist  = vehicleConfig.frontDistanceToGrnd
                local upper = vehicleConfig.frontSuspensionUpperLimit
                local lower = vehicleConfig.frontSuspensionLowerLimit
                Citizen.InvokeNative(0x9AA71BE56D8A0C14, w, dist, upper, lower, vehicle, true)
                table.insert(wheels.front, w)
            end
            for _, off in ipairs(vehicleConfig.rearWheelOffsets) do
                local w = CreateObject(wheelRearModel, pc.x, pc.y, pc.z, 1, 1, 1)
                AttachEntityToEntity(w, vehicle, 0, off.x, off.y, off.z, 0, 0, 0, 0, 0, 0, 0, 2, 2)
                local dist  = vehicleConfig.rearDistanceToGrnd
                local upper = vehicleConfig.rearSuspensionUpperLimit
                local lower = vehicleConfig.rearSuspensionLowerLimit
                Citizen.InvokeNative(0x9AA71BE56D8A0C14, w, dist, upper, lower, vehicle, true)
                table.insert(wheels.rear, w)
            end
        end

        -- Exhausts
        local exhaustModel = GetHashKey("p_pebble01x")
        RequestModel(exhaustModel)
        while not HasModelLoaded(exhaustModel) do Citizen.Wait(5) end
        local exhausts = {}
        if vehicleConfig.exhaustOffsets then
            for _, eOff in ipairs(vehicleConfig.exhaustOffsets) do
                local x, y, z = table.unpack(GetEntityCoords(vehicle, false))
                local e = CreateObject(exhaustModel, x+eOff.x, y+eOff.y, z+eOff.z, true, true, true)
                AttachEntityToEntity(e, obj, 0, eOff.x, eOff.y, eOff.z, 0, 0, 0, false, false, false, false, 2, true)
                table.insert(exhausts, e)
            end
        end

        if vehicleConfig.AltTopSpeed       then AltTopSpeed        = vehicleConfig.AltTopSpeed end
        if vehicleConfig.AltAccelMultiplier then AltAccelMultiplier = vehicleConfig.AltAccelMultiplier end

        Citizen.Wait(50)
        local vData = {
            vehicle = vehicle, object = obj, engine = false, headlights = false,
            intruck = false, curr_speed = 0,
            wheels = wheels, exhausts = exhausts,
            weaponType = weaponType, AltTopSpeed = AltTopSpeed,
            AltAccelMultiplier = AltAccelMultiplier, type = "car",
        }
        Citizen.Wait(50)
        currentVehicle = vData
        FreezeEntityPosition(vehicle, 0)
        SetModelAsNoLongerNeeded(baseModel)
        SetModelAsNoLongerNeeded(vehicleModel)
        SetModelAsNoLongerNeeded(wheelFrontModel)
        SetModelAsNoLongerNeeded(wheelRearModel)
        Citizen.Wait(1)
        SetVehicleLights(vehicle, 1)

        -- Lights
        local headlightModel  = GetHashKey("p_steamerlight01x")
        local brakelightModel = GetHashKey("p_stageshelllight_red01x")
        RequestModel(headlightModel); RequestModel(brakelightModel)
        while not HasModelLoaded(headlightModel) do Citizen.Wait(5) end
        local headlights  = {}
        local brakeLights = {}
        for _ = 1, #vehicleConfig.headlightOffsets do
            table.insert(headlights, CreateObject(headlightModel, pc.x, pc.y, pc.z, 1, 1, 1))
        end
        for _ = 1, #vehicleConfig.brakelightOffsets do
            table.insert(brakeLights, CreateObject(brakelightModel, pc.x, pc.y, pc.z, 1, 1, 1))
        end
        Citizen.Wait(100)
        for i, off in ipairs(vehicleConfig.headlightOffsets) do
            AttachEntityToEntity(headlights[i], obj, 0, off.x, off.y, off.z, off.rx, off.ry, off.rz, 0,0,0,0,0,2)
            SetEntityVisible(headlights[i], false)
        end
        for i, off in ipairs(vehicleConfig.brakelightOffsets) do
            AttachEntityToEntity(brakeLights[i], obj, 0, off.x, off.y, off.z, off.rx, off.ry, off.rz, 0,0,0,0,0,2)
            SetEntityVisible(brakeLights[i], false)
        end
        currentVehicle.headlights  = headlights
        currentVehicle.brakeLights = brakeLights

    -- ── PLANE ───────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'plane' then
        local model = GetHashKey("boatsteam02x")
        RequestModel(model); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150); FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        propellerOffset = vehicleConfig.propellerOffsets
        local propellerModel = GetHashKey(vehicleConfig.propellerModel)
        RequestModel(propellerModel)
        while not HasModelLoaded(propellerModel) do Citizen.Wait(5) end
        local propeller = CreateObject(propellerModel, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(propeller, vehicle, 0, propellerOffset.x, propellerOffset.y, propellerOffset.z, 0,0,0, false, false, true)
        FreezeEntityPosition(vehicle, 0)
        currentVehicle = {vehicle=vehicle, object=obj, engine=false, invehicle=false, propeller=propeller, curr_speed=0, weaponType=weaponType, type="plane"}
        SetModelAsNoLongerNeeded(model)

    -- ── JET ─────────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'jet' then
        local model = GetHashKey("boatsteam02x")
        RequestModel(model); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150); FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        FreezeEntityPosition(vehicle, 0)
        local exhaustModel = GetHashKey("p_pebble04x")
        RequestModel(exhaustModel)
        while not HasModelLoaded(exhaustModel) do Citizen.Wait(5) end
        local exhausts = {}
        if vehicleConfig.exhaustOffsets then
            for _, eOff in ipairs(vehicleConfig.exhaustOffsets) do
                local x, y, z = table.unpack(GetEntityCoords(vehicle, false))
                local e = CreateObject(exhaustModel, x+eOff.x, y+eOff.y, z+eOff.z, true, true, true)
                AttachEntityToEntity(e, vehicle, 0, eOff.x, eOff.y, eOff.z, 0,0,0, false, false, false, false, 2, true)
                table.insert(exhausts, e)
            end
        end
        currentVehicle = {vehicle=vehicle, object=obj, engine=false, invehicle=false, exhausts=exhausts, curr_speed=0, weaponType=weaponType, type="jet"}
        SetModelAsNoLongerNeeded(model)

    -- ── HELI ─────────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'heli' then
        local model = GetHashKey("boatsteam02x")
        RequestModel(model); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150); FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        local topPropellerModel = GetHashKey(vehicleConfig.topbladeModel)
        RequestModel(topPropellerModel)
        while not HasModelLoaded(topPropellerModel) do Citizen.Wait(5) end
        topPropellerOffset = vehicleConfig.topbladeOffsets
        local topPropeller = CreateObject(topPropellerModel, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(topPropeller, vehicle, 0, topPropellerOffset.x, topPropellerOffset.y, topPropellerOffset.z, 0,0,0, false, false, true)
        local rearBladeModel = GetHashKey(vehicleConfig.rearbladeModel)
        RequestModel(rearBladeModel)
        while not HasModelLoaded(rearBladeModel) do Citizen.Wait(5) end
        rearBladeOffset = vehicleConfig.rearbladeOffsets
        local rearBlade = CreateObject(rearBladeModel, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(rearBlade, vehicle, 0, rearBladeOffset.x, rearBladeOffset.y, rearBladeOffset.z, 0,0,0, false, false, true)
        Citizen.Wait(50)
        currentVehicle = {vehicle=vehicle, object=obj, engine=false, invehicle=false, curr_speed=0, topPropeller=topPropeller, rearBlade=rearBlade, weaponType=weaponType, type="heli"}
        FreezeEntityPosition(vehicle, 0)
        SetModelAsNoLongerNeeded(model); SetModelAsNoLongerNeeded(vehicleModel); Citizen.Wait(1)

    -- ── BOAT ─────────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'boat' then
        if not IsEntityInWater(PlayerPedId()) then
            TriggerServerEvent("lxr-vehicles:needWater"); return
        end
        local model = GetHashKey("boatsteam02x")
        RequestModel(model); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150); FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        Citizen.Wait(50)
        currentVehicle = {vehicle=vehicle, object=obj, engine=false, invehicle=false, curr_speed=0, type="boat"}
        FreezeEntityPosition(vehicle, 0)

    -- ── TANK ─────────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'tank' then
        local model = Config.Features.AltHandling and GetHashKey("buggy01") or GetHashKey("coach4")
        RequestModel(model); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150); FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        tanktopOffsets = vehicleConfig.tanktopOffsets
        local tanktop = CreateObject(vehicleConfig.tanktopModel, pc.x+3.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 1)
        AttachEntityToEntity(tanktop, vehicle, 0, tanktopOffsets.x, tanktopOffsets.y, tanktopOffsets.z, tanktopOffsets.rx, tanktopOffsets.ry, tanktopOffsets.rz, 0,1,1,0,0,2)
        Citizen.Wait(50)
        currentVehicle = {vehicle=vehicle, object=obj, tanktop=tanktop, engine=false, invehicle=false, curr_speed=0, type="tank"}
        FreezeEntityPosition(vehicle, 0)

    -- ── OSPREY ────────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'osprey' then
        local model     = GetHashKey("boatsteam02x")
        local doormodel = GetHashKey(vehicleConfig.doorModel)
        RequestModel(model); RequestModel(doormodel); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150)
        doorattach = vehicleConfig.doorattachOffsets
        FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        local doorobj = CreateObject(doormodel, pc.x+3.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(50)
        AttachEntityToEntity(doorobj, vehicle, 0, doorattach[1], doorattach[2], doorattach[3], doorattach[4], doorattach[5], doorattach[6], 0,1,1,0,0,2)
        local rightthrModel = GetHashKey(vehicleConfig.rightthrusterModel)
        local leftthrModel  = GetHashKey(vehicleConfig.leftthrusterModel)
        RequestModel(rightthrModel); while not HasModelLoaded(rightthrModel) do Citizen.Wait(15) end
        RequestModel(leftthrModel);  while not HasModelLoaded(leftthrModel)  do Citizen.Wait(15) end
        leftThrustOffset  = vehicleConfig.leftthrusterattachOffsets
        rightThrustOffset = vehicleConfig.rightthrusterattachOffsets
        local Leftthruster  = CreateObject(leftthrModel,  pc.x, pc.y, pc.z, true, true, true)
        local rightThruster = CreateObject(rightthrModel, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(Leftthruster,  vehicle, 0, leftThrustOffset.x,  leftThrustOffset.y,  leftThrustOffset.z,  0,0,0, false, false, true, false, 2, true)
        AttachEntityToEntity(rightThruster, vehicle, 0, rightThrustOffset.x, rightThrustOffset.y, rightThrustOffset.z, 0,0,0, false, false, true, false, 2, true)
        local bladeModel = GetHashKey(vehicleConfig.bladeModel)
        RequestModel(bladeModel); while not HasModelLoaded(bladeModel) do Citizen.Wait(15) end
        topPropellerOffset = vehicleConfig.rightbladeOffsets
        rearBladeOffset    = vehicleConfig.leftbladeOffsets
        local topPropeller = CreateObject(bladeModel, pc.x, pc.y, pc.z, true, true, true)
        local rearBlade    = CreateObject(bladeModel, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(topPropeller, Leftthruster,  0, 0,0, topPropellerOffset.z, 0,0,0, false, false, true, false, 2, true)
        AttachEntityToEntity(rearBlade,    rightThruster, 0, 0,0, rearBladeOffset.z,    0,0,0, false, false, true, false, 2, true)
        Citizen.Wait(50)
        currentVehicle = {vehicle=vehicle, object=obj, doorobj=doorobj, leftThruster=Leftthruster, rightThruster=rightThruster, topPropeller=topPropeller, rearBlade=rearBlade, engine=false, invehicle=false, curr_speed=0, weaponType=weaponType, type="osprey"}
        FreezeEntityPosition(vehicle, 0)

    -- ── CARGOBOB ─────────────────────────────────────────────────────────────
    elseif vehicleConfig.type == 'cargobob' then
        local model     = GetHashKey("boatsteam02x")
        local doormodel = GetHashKey(vehicleConfig.doorModel)
        RequestModel(model); RequestModel(doormodel); RequestModel(vehicleModel)
        while not HasModelLoaded(model) or not HasModelLoaded(vehicleModel) do Citizen.Wait(5) end
        local vehicle = CreateVehicle(model, pc.x+2.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(150)
        doorattach = vehicleConfig.doorattachOffsets
        FreezeEntityPosition(vehicle, 1); SetEntityVisible(vehicle, 0); Citizen.Wait(150)
        local obj = CreateObject(vehicleModel, pc.x, pc.y, pc.z, 1, 1, 1)
        Citizen.Wait(300)
        AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0,1,1,0,0,2)
        local doorobj = CreateObject(doormodel, pc.x+3.0, pc.y, pc.z, pc.h or 1.0, 1, 1, 0)
        Citizen.Wait(50)
        AttachEntityToEntity(doorobj, vehicle, 0, doorattach[1], doorattach[2], doorattach[3], doorattach[4], doorattach[5], doorattach[6], 0,1,1,0,0,2)
        local bladeModel = GetHashKey(vehicleConfig.bladeModel)
        RequestModel(bladeModel); while not HasModelLoaded(bladeModel) do Citizen.Wait(15) end
        topPropellerOffset = vehicleConfig.frontbladeOffsets
        rearBladeOffset    = vehicleConfig.rearbladeOffsets
        local topPropeller = CreateObject(bladeModel, pc.x, pc.y, pc.z, true, true, true)
        local rearBlade    = CreateObject(bladeModel, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(topPropeller, vehicle, 0, topPropellerOffset.x, topPropellerOffset.y, topPropellerOffset.z, 0,0,0, false, false, true, false, 2, true)
        AttachEntityToEntity(rearBlade,    vehicle, 0, rearBladeOffset.x,    rearBladeOffset.y,    rearBladeOffset.z,    0,0,0, false, false, true, false, 2, true)
        Citizen.Wait(50)
        currentVehicle = {vehicle=vehicle, object=obj, doorobj=doorobj, topPropeller=topPropeller, rearBlade=rearBlade, engine=false, invehicle=false, curr_speed=0, weaponType=weaponType, type="cargobob"}
        FreezeEntityPosition(vehicle, 0)
    end

    -- Common clone offsets and camera distances
    if vehicleConfig.cloneOffsets then
        cloneOffsets = {
            position = {x=vehicleConfig.cloneOffsets.x, y=vehicleConfig.cloneOffsets.y, z=vehicleConfig.cloneOffsets.z},
            rotation = {rx=vehicleConfig.cloneOffsets.rx, ry=vehicleConfig.cloneOffsets.ry, rz=vehicleConfig.cloneOffsets.rz},
        }
    end
    distanceStates  = vehicleConfig.ThirdPersonCamDistances
    currentStateIndex = 1
    camDistance = distanceStates and distanceStates[currentStateIndex] or 8.0
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NET EVENTS — SPAWN ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

RegisterNetEvent("lxr-vehicles:doSpawn")
AddEventHandler("lxr-vehicles:doSpawn", function(vehicleConfig)
    spawnVehicle(vehicleConfig)
end)

-- Legacy compat
RegisterNetEvent("addon_vehicles:spawn_c")
AddEventHandler("addon_vehicles:spawn_c", function(vehicleConfig)
    spawnVehicle(vehicleConfig)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ COMMANDS ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Delete command
RegisterCommand(Config.Keys.DeleteVeh, function()
    DeleteCurrentVehicle()
end)

-- Public spawn command (all players, if enabled)
RegisterCommand(Config.Keys.SpawnCmd, function(_, args)
    if not Config.Features.PublicSpawn then return end
    local vehicleKey = args[1] or "truck"
    if not Config.Vehicles[vehicleKey] then
        if Config.Debug then print("[LXR-Vehicles] Unknown vehicle: " .. vehicleKey) end
        return
    end
    TriggerServerEvent("lxr-vehicles:requestSpawn", vehicleKey)
end, false)

-- Admin spawn command
RegisterCommand(Config.Keys.AdminCmd, function(_, args)
    if not Config.Features.AdminSpawn then return end
    local vehicleKey = args[1] or "truck"
    if not Config.Vehicles[vehicleKey] then
        if Config.Debug then print("[LXR-Vehicles] Unknown vehicle: " .. vehicleKey) end
        return
    end
    TriggerServerEvent("lxr-vehicles:adminSpawn", vehicleKey)
end, false)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEALERSHIP SYSTEM ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local function DealerInit()
    if not Config.Features.Dealership then return end

    local pedHash = GetHashKey("U_M_M_BwmStablehand_01")
    while not HasModelLoaded(pedHash) do RequestModel(pedHash, true); Citizen.Wait(100) end

    for i, dealer in ipairs(Config.Dealerships) do
        local coords = dealer.EnterStable
        -- Map blip
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords[1], coords[2], coords[3])
        Citizen.InvokeNative(0x74F74D3207ED525C, blip, dealer.BlipIcon, 1)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, dealer.Name)
        table.insert(dealerBlips, blip)

        -- NPC
        local npc = CreatePed(pedHash,
            dealer.StableNPC[1], dealer.StableNPC[2], dealer.StableNPC[3], dealer.StableNPC[4],
            false, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        SetEntityNoCollisionEntity(PlayerPedId(), npc, false)
        SetEntityCanBeDamaged(npc, false)
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        table.insert(dealerNPCs, npc)
    end
    SetModelAsNoLongerNeeded(pedHash)

    -- Register hold prompt
    local str = CreateVarString(10, "LITERAL_STRING", "Vehicle Dealer")
    dealerPrompt = PromptRegisterBegin()
    PromptSetControlAction(dealerPrompt, 0x760A9C6F) -- G key
    PromptSetText(dealerPrompt, str)
    PromptSetEnabled(dealerPrompt, true)
    PromptSetVisible(dealerPrompt, true)
    PromptSetHoldMode(dealerPrompt, true)
    PromptSetGroup(dealerPrompt, dealerPromptGroup)
    PromptRegisterEnd(dealerPrompt)
end

-- Distance helper
local function InDealerRange(playerCoords, dealerCoords, radius)
    local dx = playerCoords.x - dealerCoords[1]
    local dy = playerCoords.y - dealerCoords[2]
    local dz = playerCoords.z - dealerCoords[3]
    return (dx*dx + dy*dy + dz*dz) <= radius * radius
end

-- Dealer proximity loop
Citizen.CreateThread(function()
    Citizen.Wait(3000)
    DealerInit()

    while true do
        Citizen.Wait(500)
        if not Config.Features.Dealership then
            Citizen.Wait(5000); goto continue
        end

        local playerCoords = GetEntityCoords(PlayerPedId())
        nearDealerIndex = nil

        for i, dealer in ipairs(Config.Dealerships) do
            if InDealerRange(playerCoords, dealer.EnterStable, dealer.EnterStable[4]) then
                nearDealerIndex = i
                break
            end
        end

        if nearDealerIndex and not IsNuiFocused() then
            local dealer = Config.Dealerships[nearDealerIndex]
            local groupStr = CreateVarString(10, "LITERAL_STRING", dealer.Name)
            PromptSetActiveGroupThisFrame(dealerPromptGroup, groupStr)

            if PromptHasHoldModeCompleted(dealerPrompt) then
                OpenDealerShop(nearDealerIndex)
            end
        end

        ::continue::
    end
end)

function OpenDealerShop(dealerIndex)
    if shopOpen then return end
    shopOpen = true
    local dealer = Config.Dealerships[dealerIndex]
    -- Build vehicle list with prices and ownership status
    local vehicleList = {}
    for key, price in pairs(dealer.vehicles) do
        local owned = false
        for _, g in ipairs(playerGarage) do
            if g.modelname == (Config.Vehicles[key] and Config.Vehicles[key].objectModel) then
                owned = true; break
            end
        end
        table.insert(vehicleList, {
            key    = key,
            label  = key,
            model  = Config.Vehicles[key] and Config.Vehicles[key].objectModel or key,
            vtype  = Config.Vehicles[key] and Config.Vehicles[key].type or "car",
            price  = price,
            owned  = owned,
        })
    end

    SendNUIMessage({
        type        = "openShop",
        dealerIndex = dealerIndex,
        dealerName  = dealer.Name,
        vehicles    = vehicleList,
        garage      = playerGarage,
    })
    SetNuiFocus(true, true)
end

-- NUI Callbacks from dealership UI
RegisterNUICallback("closeShop", function(_, cb)
    shopOpen = false
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("buyVehicle", function(data, cb)
    TriggerServerEvent("lxr-vehicles:buyVehicle", data.vehicleKey, data.dealerIndex)
    cb("ok")
end)

RegisterNUICallback("spawnVehicle", function(data, cb)
    TriggerServerEvent("lxr-vehicles:requestSpawn", data.vehicleKey)
    cb("ok")
end)

RegisterNUICallback("deleteVehicle", function(data, cb)
    TriggerServerEvent("lxr-vehicles:deleteVehicle", data.vehicleId)
    cb("ok")
end)

-- Refresh garage when server sends update
RegisterNetEvent("lxr-vehicles:receiveGarage")
AddEventHandler("lxr-vehicles:receiveGarage", function(garageData)
    playerGarage = garageData or {}
    SendNUIMessage({type = "refreshGarage", garage = playerGarage})
end)

RegisterNetEvent("lxr-vehicles:purchaseComplete")
AddEventHandler("lxr-vehicles:purchaseComplete", function(vehicleKey)
    TriggerServerEvent("lxr-vehicles:loadGarage")
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CLONE PED ████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local player  = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)

        if currentVehicle and currentVehicle.vehicle and
           DoesEntityExist(vehicle) and vehicle == currentVehicle.vehicle and
           not DoesEntityExist(clonePed) then

            Citizen.CreateThread(function()
                Citizen.Wait(2)
                SetEntityVisible(player, false, false)
            end)

            local cloneCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.0, 0.0)
            clonePed = ClonePed(player, GetEntityHeading(player), false, true)
            SetEntityCoordsNoOffset(clonePed, cloneCoords.x, cloneCoords.y, cloneCoords.z, true, true, true)
            RequestAnimDict("script_re@check_point@small_cart")
            while not HasAnimDictLoaded("script_re@check_point@small_cart") do Citizen.Wait(100) end
            TaskPlayAnim(clonePed, "script_re@check_point@small_cart", "int_loop_driver", 8.0, 1.0, -1, 1, 0.1, 0, 0, 0)

            if cloneOffsets then
                AttachEntityToEntity(clonePed, currentVehicle.object, 0,
                    cloneOffsets.position.x, cloneOffsets.position.y, cloneOffsets.position.z,
                    cloneOffsets.rotation.rx, cloneOffsets.rotation.ry, cloneOffsets.rotation.rz,
                    false, false, false, false, 2, true)
            end
            SetEntityVisible(clonePed, false, false)
            Citizen.CreateThread(function()
                Citizen.Wait(700)
                SetEntityVisible(clonePed, true, false)
                SetBlockingOfNonTemporaryEvents(clonePed, true)
            end)

        elseif (not currentVehicle or not currentVehicle.vehicle or
                not DoesEntityExist(vehicle) or vehicle ~= currentVehicle.vehicle) and
               DoesEntityExist(clonePed) then
            SetEntityVisible(player, true, false)
            DeleteEntity(clonePed)
            clonePed = nil
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ENTER VEHICLE (E key) ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if currentVehicle then
            local playerPed    = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local closestVeh, closestDist = nil, 5.0
            for v in (function()
                return coroutine.wrap(function()
                    local h, vv = FindFirstVehicle()
                    if not vv then EndFindVehicle(h); return end
                    local ok; repeat coroutine.yield(vv); ok, vv = FindNextVehicle(h) until not ok
                    EndFindVehicle(h)
                end)
            end)() do
                local d = #(playerCoords - GetEntityCoords(v))
                if d < closestDist then closestVeh = v; closestDist = d end
            end
            if closestVeh and closestVeh == currentVehicle.vehicle and IsControlJustPressed(0, 0xCEFD9220) then
                TaskWarpPedIntoVehicle(playerPed, closestVeh, -1)
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PHYSICS HELPERS ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local function AdjustAircraftPitch(vehicle, dir)
    local p, r, y = table.unpack(GetEntityRotation(vehicle, 2))
    SetEntityRotation(vehicle, p + (dir * 0.38), r, y, 2, true)
end

local function AdjustAircraftOrientation(vehicle, rollDir, yawDir)
    local p, r, y = table.unpack(GetEntityRotation(vehicle, 2))
    SetEntityRotation(vehicle, p, r + (rollDir * 0.5), y + (yawDir * 0.5), 2, true)
end

local function lerp(a, b, t) return a + (b - a) * t end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CAR / BIKE BOOST ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
        if currentVehicle then
            currentVehicle.inVehicle = IsPedInVehicle(PlayerPedId(), currentVehicle.vehicle, 1)
            if currentVehicle.inVehicle and (currentVehicle.type == "car" or currentVehicle.type == "bike") then
                local speed    = GetEntitySpeed(currentVehicle.vehicle)
                local speedMph = speed * 2.23694
                local height   = GetEntityHeightAboveGround(currentVehicle.vehicle)
                if height <= 0.8 and IsControlPressed(0, keyShift) and
                   speedMph < currentVehicle.AltTopSpeed and speedMph > 10 and
                   not IsControlPressed(0, keyA) and not IsControlPressed(0, keyD) then
                    SetVehicleForwardSpeed(currentVehicle.vehicle, speed + currentVehicle.AltAccelMultiplier)
                end
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ BOAT BOOST ████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if currentVehicle and currentVehicle.inVehicle and currentVehicle.type == "boat" then
            local speed    = GetEntitySpeed(currentVehicle.vehicle)
            local speedMph = speed * 2.23694
            if IsControlPressed(0, keyW) and speedMph < 80 and not IsControlPressed(0, keyS) then
                SetVehicleForwardSpeed(currentVehicle.vehicle, speed + 0.25)
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ AIRCRAFT YAWROLL ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentVehicle and currentVehicle.inVehicle then
            if currentVehicle.type == "plane" or currentVehicle.type == "jet" then
                if IsControlPressed(0, keyA) and not IsControlPressed(0, keySpace) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, 0, -1)
                elseif IsControlPressed(0, keyD) and not IsControlPressed(0, keySpace) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, 0, 1)
                end
                if IsControlPressed(0, keySpace) and IsControlPressed(0, keyD) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, -1, 0)
                elseif IsControlPressed(0, keySpace) and IsControlPressed(0, keyA) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, 1, 0)
                end
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ HELICOPTER CONTROL ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if currentVehicle then
            currentVehicle.inVehicle = IsPedInVehicle(PlayerPedId(), currentVehicle.vehicle, 1)
            if currentVehicle.inVehicle and
               (currentVehicle.type == "heli" or currentVehicle.type == "cargobob") then
                local speedMPH = GetEntitySpeed(currentVehicle.vehicle) * 2.23694
                if IsControlPressed(0, keyShift) then
                    currentForce = 0.99
                else
                    currentForce = math.max(0, currentForce - decayRate)
                end
                ApplyForceToEntityCenterOfMass(currentVehicle.vehicle, 1, 0.0, 0.0, currentForce, true, true, true, true)
                if IsControlPressed(0, keyA) and not IsControlPressed(0, keySpace) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, 1, 0)
                elseif IsControlPressed(0, keyD) and not IsControlPressed(0, keySpace) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, -1, 0)
                end
                if IsControlPressed(0, keySpace) and IsControlPressed(0, keyA) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, 0, -1)
                elseif IsControlPressed(0, keySpace) and IsControlPressed(0, keyD) then
                    AdjustAircraftOrientation(currentVehicle.vehicle, 0, 1)
                end
                if speedMPH < 20 then
                    if IsControlPressed(0, keyW) then AdjustAircraftPitch(currentVehicle.vehicle, -1)
                    elseif IsControlPressed(0, keyS) then AdjustAircraftPitch(currentVehicle.vehicle, 1) end
                end
            end
        end
    end
end)

-- Heli blade rotation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentVehicle and currentVehicle.engine then
            if currentVehicle.type == "heli" or currentVehicle.type == "cargobob" then
                local vehicleSpeed = GetEntitySpeed(currentVehicle.vehicle)
                if currentBaseSpeed < maxBaseSpeed then
                    currentBaseSpeed = math.min(currentBaseSpeed + speedIncrement, maxBaseSpeed)
                end
                if vehicleSpeed > maxSpeedMetersPerSecond then vehicleSpeed = maxSpeedMetersPerSecond end
                local rotSpeedIncrement = -3.0 * (currentBaseSpeed + vehicleSpeed)
                currentRotationAngle = (currentRotationAngle + rotSpeedIncrement) % 360
                if topPropellerOffset and rearBladeOffset then
                    if currentVehicle.type == "cargobob" then
                        AttachEntityToEntity(currentVehicle.topPropeller, currentVehicle.vehicle, 0,
                            topPropellerOffset.x, topPropellerOffset.y, topPropellerOffset.z, 0,0,currentRotationAngle, 0,1,1,0,0,2)
                        AttachEntityToEntity(currentVehicle.rearBlade, currentVehicle.vehicle, 0,
                            rearBladeOffset.x, rearBladeOffset.y, rearBladeOffset.z, 0,0,currentRotationAngle, 0,1,1,0,0,2)
                    else
                        AttachEntityToEntity(currentVehicle.topPropeller, currentVehicle.vehicle, 0,
                            topPropellerOffset.x, topPropellerOffset.y, topPropellerOffset.z, 0,0,currentRotationAngle, 0,1,1,0,0,2)
                        AttachEntityToEntity(currentVehicle.rearBlade, currentVehicle.vehicle, 0,
                            rearBladeOffset.x, rearBladeOffset.y, rearBladeOffset.z, currentRotationAngle,0,0, 0,1,1,0,0,2)
                    end
                end
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ OSPREY CONTROL ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if currentVehicle and currentVehicle.type == 'osprey' then
            currentVehicle.inVehicle = IsPedInVehicle(PlayerPedId(), currentVehicle.vehicle, 1)
            if currentVehicle.inVehicle and DoesEntityExist(currentVehicle.vehicle) then
                local speedMPH = GetEntitySpeed(currentVehicle.vehicle) * 2.23694
                if flightMode then
                    if IsControlPressed(0, keyShift) then
                        if speedMPH < 5 and GetEntityHeightAboveGround(currentVehicle.vehicle) < 7 then
                            currentForce = 0.888
                            currentForce = math.max(0, currentForce - decayRate)
                            ApplyForceToEntityCenterOfMass(currentVehicle.vehicle, 1, 0,0, currentForce, true, true, true, true)
                        elseif speedMPH >= 5 or GetEntityHeightAboveGround(currentVehicle.vehicle) >= 17 then
                            SetVehicleForwardSpeed(currentVehicle.vehicle, GetEntitySpeed(currentVehicle.vehicle) + 0.13)
                        end
                    end
                else
                    if IsControlPressed(0, keyShift) then currentForce = 0.99
                    else currentForce = math.max(0, currentForce - decayRate) end
                    ApplyForceToEntityCenterOfMass(currentVehicle.vehicle, 1, 0,0, currentForce, true, true, true, true)
                end
                if IsControlPressed(0, keyA) and not IsControlPressed(0, keyAlt) then AdjustAircraftOrientation(currentVehicle.vehicle, 1, 0)
                elseif IsControlPressed(0, keyD) and not IsControlPressed(0, keyAlt) then AdjustAircraftOrientation(currentVehicle.vehicle, -1, 0) end
                if IsControlPressed(0, keySpace) and IsControlPressed(0, keyA) then AdjustAircraftOrientation(currentVehicle.vehicle, 0, -1)
                elseif IsControlPressed(0, keySpace) and IsControlPressed(0, keyD) then AdjustAircraftOrientation(currentVehicle.vehicle, 0, 1) end
                if IsControlJustPressed(0, keyLeftClick) then
                    if doorOpen then
                        while currentDoorRotationAngle > 0 do Citizen.Wait(10)
                            currentDoorRotationAngle = currentDoorRotationAngle - doorRotationSpeed
                            AttachEntityToEntity(currentVehicle.doorobj, currentVehicle.vehicle, 0, doorattach[1], doorattach[2], doorattach[3], currentDoorRotationAngle, doorattach[5], doorattach[6], 0,1,1,0,0,2)
                        end; currentDoorRotationAngle = 0
                    else
                        while currentDoorRotationAngle < maxDoorRotationAngle do Citizen.Wait(10)
                            currentDoorRotationAngle = currentDoorRotationAngle + doorRotationSpeed
                            AttachEntityToEntity(currentVehicle.doorobj, currentVehicle.vehicle, 0, doorattach[1], doorattach[2], doorattach[3], currentDoorRotationAngle, doorattach[5], doorattach[6], 0,1,1,0,0,2)
                        end; currentDoorRotationAngle = maxDoorRotationAngle
                    end
                    doorOpen = not doorOpen
                end
                if IsControlJustPressed(0, keyRightClick) then
                    flightMode = not flightMode
                    thrusterRotated = not thrusterRotated
                    thrusterTargetRotationAngle = thrusterRotated and 90.0 or 0.0
                end
                if thrusterCurrentRotationAngle ~= thrusterTargetRotationAngle then
                    if thrusterCurrentRotationAngle < thrusterTargetRotationAngle then
                        thrusterCurrentRotationAngle = math.min(thrusterCurrentRotationAngle + thrusterRotationSpeed, thrusterTargetRotationAngle)
                    else
                        thrusterCurrentRotationAngle = math.max(thrusterCurrentRotationAngle - thrusterRotationSpeed, thrusterTargetRotationAngle)
                    end
                    AttachEntityToEntity(currentVehicle.leftThruster,  currentVehicle.vehicle, 0, leftThrustOffset.x,  leftThrustOffset.y,  leftThrustOffset.z,  -thrusterCurrentRotationAngle, 0,0, false, false, true, false, 2, true)
                    AttachEntityToEntity(currentVehicle.rightThruster, currentVehicle.vehicle, 0, rightThrustOffset.x, rightThrustOffset.y, rightThrustOffset.z, -thrusterCurrentRotationAngle, 0,0, false, false, true, false, 2, true)
                    AttachEntityToEntity(currentVehicle.topPropeller,  currentVehicle.leftThruster,  0, 0,0, topPropellerOffset.z, 0,0, -thrusterCurrentRotationAngle, false, false, true, false, 2, true)
                    AttachEntityToEntity(currentVehicle.rearBlade,     currentVehicle.rightThruster, 0, 0,0, rearBladeOffset.z,    0,0, -thrusterCurrentRotationAngle, false, false, true, false, 2, true)
                end
                if speedMPH < 20 then
                    if IsControlPressed(0, keyW) then AdjustAircraftPitch(currentVehicle.vehicle, -1)
                    elseif IsControlPressed(0, keyS) then AdjustAircraftPitch(currentVehicle.vehicle, 1) end
                end
            end
        end
    end
end)

-- Osprey blade rotation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentVehicle and currentVehicle.engine and currentVehicle.type == 'osprey' then
            local vehicleSpeed = GetEntitySpeed(currentVehicle.vehicle)
            if currentBaseSpeed < maxBaseSpeed then currentBaseSpeed = math.min(currentBaseSpeed + speedIncrement, maxBaseSpeed) end
            if vehicleSpeed > maxSpeedMetersPerSecond then vehicleSpeed = maxSpeedMetersPerSecond end
            local rotSpeedIncrement = -3.0 * (currentBaseSpeed + vehicleSpeed)
            currentRotationAngle = (currentRotationAngle + rotSpeedIncrement) % 360
            if topPropellerOffset and rearBladeOffset then
                AttachEntityToEntity(currentVehicle.topPropeller, currentVehicle.leftThruster,  0, topPropellerOffset.x, topPropellerOffset.y, topPropellerOffset.z, 0,0,currentRotationAngle, 0,1,1,0,0,2)
                AttachEntityToEntity(currentVehicle.rearBlade,    currentVehicle.rightThruster, 0, rearBladeOffset.x,    rearBladeOffset.y,    rearBladeOffset.z,    0,0,currentRotationAngle, 0,1,1,0,0,2)
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TANK TURRET ███████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local function RotationToDirection(rot)
    local adj = {x=(math.pi/180)*rot.x, y=(math.pi/180)*rot.y, z=(math.pi/180)*rot.z}
    return {
        x = -math.sin(adj.z) * math.abs(math.cos(adj.x)),
        y =  math.cos(adj.z) * math.abs(math.cos(adj.x)),
        z =  math.sin(adj.x),
    }
end

Citizen.CreateThread(function()
    local lastRotY, lastRotZ = 0, 0
    while true do
        Citizen.Wait(0)
        if currentVehicle and currentVehicle.inVehicle and currentVehicle.type == "tank" then
            local camRot = GetGameplayCamRot(2)
            local vehRot = GetEntityRotation(currentVehicle.vehicle, 2)
            local smoothY = lerp(lastRotY, camRot.y - vehRot.y, 0.1)
            local smoothZ = lerp(lastRotZ, camRot.z - vehRot.z, 0.1)
            lastRotY, lastRotZ = smoothY, smoothZ
            if tanktopOffsets then
                AttachEntityToEntity(currentVehicle.tanktop, currentVehicle.vehicle, 0,
                    tanktopOffsets.x, tanktopOffsets.y, tanktopOffsets.z,
                    tanktopOffsets.rx, smoothY, smoothZ, 0, false, false, false, 2, true)
            end
        end
    end
end)

-- Tank shell fire
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentVehicle and currentVehicle.inVehicle and currentVehicle.type == "tank" then
            local pressed = false
            if IsControlPressed(0, keySpace) and not pressed then
                pressed = true
                local camRot   = GetGameplayCamRot(2)
                local camCoord = GetGameplayCamCoord()
                local dir      = RotationToDirection(camRot)
                local fwd      = 20.0
                local start    = {x=camCoord.x+dir.x*fwd, y=camCoord.y+dir.y*fwd, z=camCoord.z+dir.z*fwd}
                local dest     = {x=start.x+dir.x*1000,   y=start.y+dir.y*1000,   z=start.z+dir.z*1000}
                local ray      = StartShapeTestRay(start.x, start.y, start.z, dest.x, dest.y, dest.z, -1, -1, 1)
                local _, hit, hitCoords = GetShapeTestResult(ray)
                if hit then
                    Citizen.InvokeNative(0x7D6F58F69DA92530, hitCoords.x, hitCoords.y, hitCoords.z, 27, 1.0, true, false, true)
                end
                Citizen.Wait(1000)
                pressed = false
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ENGINE TOGGLE ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

firstEntry = true
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(10)
        if currentVehicle then
            if currentVehicle.inVehicle then
                local veh = GetVehiclePedIsIn(PlayerPedId())
                if IsControlPressed(0, Config.Keys.Engine) or firstEntry then
                    if not currentVehicle.engine then
                        Citizen.Wait(500)
                        SendNUIMessage({key = "onStartVehicle", soundFile = startSound})
                        Citizen.Wait(500)
                        SetVehicleEngineOn(veh, 1, 1)
                        currentVehicle.particlesActive = true
                        if currentVehicle.type == 'bike' or currentVehicle.type == 'car' then
                            if currentVehicle.headlights then
                                for _, h in ipairs(currentVehicle.headlights) do SetEntityVisible(h, true) end
                            end
                        end
                        firstEntry = false
                    else
                        SetVehicleEngineOn(veh, 0, 0)
                        currentVehicle.particlesActive = false
                        if currentVehicle.type == 'bike' or currentVehicle.type == 'car' then
                            if currentVehicle.headlights then
                                for _, h in ipairs(currentVehicle.headlights) do SetEntityVisible(h, false) end
                            end
                        end
                        Citizen.Wait(2000)
                    end
                    currentVehicle.engine = not currentVehicle.engine
                    Citizen.Wait(1200)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EXHAUST PARTICLES ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if currentVehicle and currentVehicle.inVehicle then
            if (currentVehicle.type == 'bike' or currentVehicle.type == 'car') and currentVehicle.particlesActive then
                if not is_particle_effect_active and currentVehicle.exhausts and #currentVehicle.exhausts > 0 then
                    if not HasNamedPtfxAssetLoaded(new_ptfx_dictionary) then
                        RequestNamedPtfxAsset(new_ptfx_dictionary)
                        while not HasNamedPtfxAssetLoaded(new_ptfx_dictionary) do Citizen.Wait(0) end
                    end
                    for _, exhaust in ipairs(currentVehicle.exhausts) do
                        UseParticleFxAsset(new_ptfx_dictionary)
                        local handle = StartParticleFxLoopedOnEntity(new_ptfx_name, exhaust, 0,  -0.2, 0, 0, 0, 0, 0.5, false, false, false)
                        table.insert(current_ptfx_handles, handle)
                    end
                    is_particle_effect_active = true
                end
            else
                if is_particle_effect_active then
                    for _, h in ipairs(current_ptfx_handles) do StopParticleFxLooped(h, false) end
                    current_ptfx_handles = {}
                    is_particle_effect_active = false
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SOUND UPDATE ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    local wasInVehicle = false
    while true do
        Citizen.Wait(100)
        if currentVehicle and currentVehicle.engine then
            local vehicle = currentVehicle.vehicle
            local speed   = GetEntitySpeed(vehicle)
            local dist    = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))
            local minVol  = (currentVehicle.type == 'car' or currentVehicle.type == 'bike' or
                             currentVehicle.type == 'boat' or currentVehicle.type == 'tank')
                             and (0.15 - dist * 0.006) or (0.15 - dist * 0.003)
            if minVol < 0 then minVol = 0 end
            local gearBoost = 0
            if IsControlPressed(0, keyShift) and currentVehicle.inVehicle then
                if (currentVehicle.type == 'car' or currentVehicle.type == 'bike') and speed < 20 then
                    gearBoost = 12.0
                else gearBoost = 8.0 end
            end
            speed = math.min(speed + gearBoost, 200)
            if not wasInVehicle then
                SendNUIMessage({key = "onEnteredVehicle", soundFile = idleSound, minVolume = minVol})
                wasInVehicle = true
            else
                SendNUIMessage({key = "onSpeedChanged", value = speed, minVolume = minVol})
            end
        else
            if wasInVehicle then
                SendNUIMessage({key = "onStopVehicle", soundFile = stopSound})
                wasInVehicle = false
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SPEEDOMETER HUD ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if currentVehicle and currentVehicle.inVehicle then
            local speedMPH = GetEntitySpeed(currentVehicle.vehicle) * 2.23694
            local curr_speed = string.format("%.1f", speedMPH)
            local col = currentVehicle.engine and {0,126,0,200} or {126,0,0,200}
            SetTextColor(126, 0, 0, 215)
            SetTextScale(0.35, 0.35)
            SetTextFontForCurrentCommand(0)
            SetTextCentre(1)
            local str = CreateVarString(10, "LITERAL_STRING", curr_speed .. "mph", Citizen.ResultAsLong())
            DisplayText(str, 0.46, 0.9)
            DrawSprite("hud_textures", "gang_savings", 0.53, 0.91, 0.04, 0.04, 0.1, col[1], col[2], col[3], col[4], 0)
        else
            Citizen.Wait(800)
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CAMERA ████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentVehicle and currentVehicle.inVehicle then
            if IsControlJustPressed(0, vKey) and IsFirstPersonCameraActive() == 0 then
                currentStateIndex = currentStateIndex + 1
                if currentStateIndex > #(distanceStates or {}) then currentStateIndex = 1 end
                camDistance = distanceStates and distanceStates[currentStateIndex] or 8.0
            end
            if distanceStates then
                SetThirdPersonCamOrbitDistanceLimitsThisUpdate(1.0, camDistance)
            end
            if IsFirstPersonCameraActive() == 1 then
                if clonePed and DoesEntityExist(clonePed) then
                    local headBone = GetEntityBoneIndexByName(clonePed, "HEAD")
                    GetPedBoneCoords(clonePed, headBone)
                    SetGameplayCamFollowPedThisUpdate(clonePed)
                    Citizen.SetTimeout(550, function()
                        SetEntityVisible(clonePed, false, false)
                        ClearPedTasks(clonePed)
                        animationPlayed = false
                    end)
                end
            else
                if not animationPlayed and clonePed and DoesEntityExist(clonePed) then
                    SetEntityVisible(clonePed, true, false)
                    TaskPlayAnim(clonePed, "script_re@check_point@small_cart", "int_loop_driver", 8.0, 1.0, -1, 1, 0.1, 0, 0, 0)
                    animationPlayed = true
                end
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ALT HANDLING — PED SCALE ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if Config.Features.AltHandling and not scaleSet then
            if currentVehicle and currentVehicle.vehicle then
                if currentVehicle.type == "car" or currentVehicle.type == "bike" then
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local ret, closestPed = GetClosestPed(playerCoords.x, playerCoords.y, playerCoords.z, 10.0, true, true, false, false, true, -1)
                    if ret and DoesEntityExist(closestPed) then
                        SetPedScale(closestPed, 0.8)
                        scaleSet = true
                    else
                        Citizen.Wait(100)
                    end
                end
            end
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ RESOURCE CLEANUP ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    DeleteCurrentVehicle()
    -- Remove dealer NPCs and blips
    for _, npc in ipairs(dealerNPCs)  do DeletePed(npc) end
    for _, blip in ipairs(dealerBlips) do RemoveBlip(blip) end
end)
