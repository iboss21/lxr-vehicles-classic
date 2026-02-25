--[[
    ██╗     ██╗  ██╗██████╗        ██╗   ██╗███████╗██╗  ██╗██╗ ██████╗██╗     ███████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██║   ██║██╔════╝██║  ██║██║██╔════╝██║     ██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝        ██║   ██║█████╗  ███████║██║██║     ██║     █████╗  ███████╗
    ██║      ██╔██╗ ██╔══██╗        ╚██╗ ██╔╝██╔══╝  ██╔══██║██║██║     ██║     ██╔══╝  ╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ╚████╔╝ ███████╗██║  ██║██║╚██████╗███████╗███████╗███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝          ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚══════╝╚══════╝
    🐺 LXR Vehicles Classic — server.lua
    wolves.land | The Land of Wolves | © 2026 iBoss21 / The Lux Empire
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK AUTO-DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local Framework     = nil
local FrameworkName = "none"
local db            = exports.oxmysql

-- ── LXR Core ────────────────────────────────────────────────────────────────
local LXRCore = nil
AddEventHandler("LXRCore:GetObject", function(cb) cb(LXRCore) end)

-- ── RSG Core ────────────────────────────────────────────────────────────────
local RSGCore = nil

-- ── VORP Core ────────────────────────────────────────────────────────────────
local VorpCore = nil
local VorpInv  = nil

-- Detect and bind on resource start
AddEventHandler("onResourceStart", function(res)
    if res ~= GetCurrentResourceName() then return end
    Citizen.Wait(500)
    DetectFramework()
end)

function DetectFramework()
    local mode = Config.Framework

    if mode == "lxr" or mode == "auto" then
        local ok, obj = pcall(function()
            local result = nil
            TriggerEvent("LXRCore:GetObject", function(core) result = core end)
            return result
        end)
        if ok and obj then
            LXRCore    = obj
            Framework  = "lxr"
            FrameworkName = "LXR-Core"
        end
    end

    if (mode == "rsg" or mode == "auto") and not Framework then
        local ok, obj = pcall(function() return exports["rsg-core"]:GetCoreObject() end)
        if ok and obj then
            RSGCore    = obj
            Framework  = "rsg"
            FrameworkName = "RSG-Core"
        end
    end

    if (mode == "vorp" or mode == "auto") and not Framework then
        local ok, obj = pcall(function()
            local result = nil
            TriggerEvent("getCore", function(core) result = core end)
            return result
        end)
        if ok and obj then
            VorpCore   = obj
            VorpInv    = exports.vorp_inventory:vorp_inventoryApi()
            Framework  = "vorp"
            FrameworkName = "VORP-Core"
        end
    end

    if not Framework then
        FrameworkName = "Standalone"
    end

    if Config.Debug then
        print(string.format("[🐺 LXR-Vehicles] Framework detected: %s", FrameworkName))
    end
end

-- ── Helpers ──────────────────────────────────────────────────────────────────

--- Returns a table with player data regardless of framework.
---@param src number  server source
---@return table|nil  {identifier, charId, money, job, group}
function GetPlayerData(src)
    if Framework == "lxr" and LXRCore then
        local player = LXRCore.Functions.GetPlayer(src)
        if not player then return nil end
        return {
            identifier = player.PlayerData.citizenid,
            charId     = player.PlayerData.charinfo and player.PlayerData.charinfo.id or 0,
            money      = player.PlayerData.money and player.PlayerData.money.cash or 0,
            job        = player.PlayerData.job and player.PlayerData.job.name or "unemployed",
            group      = player.PlayerData.group or "user",
        }
    elseif Framework == "rsg" and RSGCore then
        local player = RSGCore.Functions.GetPlayer(src)
        if not player then return nil end
        return {
            identifier = player.PlayerData.citizenid,
            charId     = player.PlayerData.charinfo and player.PlayerData.charinfo.id or 0,
            money      = player.PlayerData.money and player.PlayerData.money.cash or 0,
            job        = player.PlayerData.job and player.PlayerData.job.name or "unemployed",
            group      = player.PlayerData.group or "user",
        }
    elseif Framework == "vorp" and VorpCore then
        local user = VorpCore.getUser(src)
        if not user then return nil end
        local char = user.getUsedCharacter
        return {
            identifier = char.identifier,
            charId     = char.charIdentifier,
            money      = char.money or 0,
            job        = char.job or "unemployed",
            group      = "user",
        }
    else
        return {
            identifier = GetPlayerIdentifierByType(src, "steam") or tostring(src),
            charId     = src,
            money      = 999999,
            job        = "none",
            group      = "user",
        }
    end
end

--- Remove cash from player (amount in dollars)
function RemoveMoney(src, amount)
    if Framework == "lxr" and LXRCore then
        local player = LXRCore.Functions.GetPlayer(src)
        if player then player.Functions.RemoveMoney("cash", amount) end
    elseif Framework == "rsg" and RSGCore then
        local player = RSGCore.Functions.GetPlayer(src)
        if player then player.Functions.RemoveMoney("cash", amount) end
    elseif Framework == "vorp" and VorpCore then
        local user = VorpCore.getUser(src)
        if user then user.getUsedCharacter.removeCurrency(0, amount) end
    end
end

--- Add cash to player
function AddMoney(src, amount)
    if Framework == "lxr" and LXRCore then
        local player = LXRCore.Functions.GetPlayer(src)
        if player then player.Functions.AddMoney("cash", amount) end
    elseif Framework == "rsg" and RSGCore then
        local player = RSGCore.Functions.GetPlayer(src)
        if player then player.Functions.AddMoney("cash", amount) end
    elseif Framework == "vorp" and VorpCore then
        local user = VorpCore.getUser(src)
        if user then user.getUsedCharacter.addCurrency(0, amount) end
    end
end

--- Returns true if the player has an admin group
function IsAdmin(src)
    if not Config.Features.AdminSpawn then return false end
    local data = GetPlayerData(src)
    if not data then return false end
    if Framework == "lxr" or Framework == "rsg" then
        for _, g in ipairs(Config.AdminGroups) do
            if data.group == g then return true end
        end
        return false
    elseif Framework == "vorp" then
        -- VORP stores permission level; treat any job in AdminGroups as admin
        for _, g in ipairs(Config.AdminGroups) do
            if data.job == g then return true end
        end
        return IsPlayerAceAllowed(src, "command") or false
    else
        return IsPlayerAceAllowed(src, "command") or false
    end
end

--- Notify client
function Notify(src, title, msg, dict, txtr, duration)
    TriggerClientEvent("lxr-vehicles:notify", src, title, msg, dict, txtr, duration or 3500)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DATABASE — OWNERSHIP QUERIES
-- ═══════════════════════════════════════════════════════════════════════════════

--- Returns true if the character owns this vehicle model
function PlayerOwnsVehicle(charId, modelName, cb)
    db:execute(
        "SELECT id FROM lxr_vehicles WHERE charidentifier = ? AND modelname = ? LIMIT 1",
        {charId, modelName},
        function(result)
            cb(result and result[1] ~= nil)
        end
    )
end

--- Load all vehicles owned by a character
function LoadOwnedVehicles(src, charId)
    db:execute(
        "SELECT * FROM lxr_vehicles WHERE charidentifier = ?",
        {charId},
        function(result)
            TriggerClientEvent("lxr-vehicles:receiveGarage", src, result or {})
        end
    )
end

--- Insert a purchased vehicle into the database
function InsertVehicle(charId, vehicleName, modelName, vehicleType, cb)
    db:execute(
        "INSERT INTO lxr_vehicles (charidentifier, name, modelname, type, identifier) VALUES (?, ?, ?, ?, 'steam:')",
        {charId, vehicleName, modelName, vehicleType},
        function(result)
            cb(result and result.affectedRows > 0)
        end
    )
end

--- Delete a vehicle record
function DeleteVehicleRecord(vehicleId, charId, cb)
    db:execute(
        "DELETE FROM lxr_vehicles WHERE id = ? AND charidentifier = ?",
        {vehicleId, charId},
        function(result)
            cb(result and result.affectedRows > 0)
        end
    )
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SPAWN LOGIC — REQUEST FROM CLIENT
-- ═══════════════════════════════════════════════════════════════════════════════

--- Main spawn handler (called from client prompt / command)
RegisterServerEvent("lxr-vehicles:requestSpawn")
AddEventHandler("lxr-vehicles:requestSpawn", function(vehicleKey)
    local src = source
    local vehicleConfig = Config.Vehicles[vehicleKey]

    if not vehicleConfig then
        Notify(src, Config.Texts.SpawnTitle, Config.Texts.NoVehicle,
               Config.Textures.alert[1], Config.Textures.alert[2])
        return
    end

    -- ── Public Spawn (no DB check) ────────────────────────────────────────────
    if Config.Features.PublicSpawn then
        TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
        return
    end

    -- ── DB Ownership check ────────────────────────────────────────────────────
    if Config.Features.DatabaseOwnership then
        local player = GetPlayerData(src)
        if not player then return end
        PlayerOwnsVehicle(player.charId, vehicleConfig.objectModel, function(owns)
            if owns then
                TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
            else
                Notify(src, Config.Texts.SpawnTitle, Config.Texts.NotOwned,
                       Config.Textures.locked[1], Config.Textures.locked[2])
            end
        end)
    else
        TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
    end
end)

--- Admin spawn (bypasses ownership)
RegisterServerEvent("lxr-vehicles:adminSpawn")
AddEventHandler("lxr-vehicles:adminSpawn", function(vehicleKey)
    local src = source
    if not Config.Features.AdminSpawn then return end
    if not IsAdmin(src) then
        Notify(src, "🐺 LXR Vehicles", Config.Texts.AdminOnly,
               Config.Textures.locked[1], Config.Textures.locked[2])
        return
    end
    local vehicleConfig = Config.Vehicles[vehicleKey]
    if not vehicleConfig then
        Notify(src, Config.Texts.SpawnTitle, Config.Texts.NoVehicle,
               Config.Textures.alert[1], Config.Textures.alert[2])
        return
    end
    TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
    if Config.Debug then
        print(string.format("[🐺 LXR-Vehicles] Admin %s spawned vehicle '%s'", src, vehicleKey))
    end
end)

--- Legacy spawn event (backward compatibility with old balboni command)
RegisterServerEvent("addon_vehicles:spawn_car")
AddEventHandler("addon_vehicles:spawn_car", function(vehicleConfig)
    local src = source
    if Config.Features.PublicSpawn then
        TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
        return
    end
    if Config.Features.DatabaseOwnership then
        local player = GetPlayerData(src)
        if not player then return end
        PlayerOwnsVehicle(player.charId, vehicleConfig.objectModel, function(owns)
            if owns then
                TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
            else
                Notify(src, Config.Texts.SpawnTitle, Config.Texts.NotOwned,
                       Config.Textures.locked[1], Config.Textures.locked[2])
            end
        end)
    else
        TriggerClientEvent("lxr-vehicles:doSpawn", src, vehicleConfig)
    end
end)

--- Legacy receive-config event
RegisterServerEvent("requestVehicleConfig")
AddEventHandler("requestVehicleConfig", function()
    TriggerClientEvent("receiveVehicleConfig", source, Config.Vehicles)
end)

RegisterServerEvent("requestVehicleConfigJSON")
AddEventHandler("requestVehicleConfigJSON", function()
    TriggerClientEvent("receiveVehicleConfigJSON", source, json.encode(Config.Vehicles))
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DEALERSHIP — BUY / SELL / TRANSFER / DELETE
-- ═══════════════════════════════════════════════════════════════════════════════

--- Player requests to BUY a vehicle from a dealership
RegisterServerEvent("lxr-vehicles:buyVehicle")
AddEventHandler("lxr-vehicles:buyVehicle", function(vehicleKey, dealerIndex)
    if not Config.Features.Dealership then return end
    local src     = source
    local player  = GetPlayerData(src)
    if not player then return end

    local dealer  = Config.Dealerships[dealerIndex]
    if not dealer then return end

    local price   = dealer.vehicles[vehicleKey]
    if not price  then return end

    local vCfg    = Config.Vehicles[vehicleKey]
    if not vCfg   then return end

    if player.money < price then
        Notify(src, Config.Texts.DealerTitle, Config.Texts.CantAfford,
               Config.Textures.cross[1], Config.Textures.cross[2])
        return
    end

    -- Check if already owned
    PlayerOwnsVehicle(player.charId, vCfg.objectModel, function(alreadyOwns)
        if alreadyOwns then
            Notify(src, Config.Texts.DealerTitle, "You already own this vehicle!",
                   Config.Textures.alert[1], Config.Textures.alert[2])
            return
        end

        RemoveMoney(src, price)
        InsertVehicle(player.charId, vehicleKey, vCfg.objectModel, vCfg.type, function(ok)
            if ok then
                Notify(src, Config.Texts.DealerTitle, Config.Texts.PurchaseSuccess,
                       Config.Textures.tick[1], Config.Textures.tick[2])
                LoadOwnedVehicles(src, player.charId)
                TriggerClientEvent("lxr-vehicles:purchaseComplete", src, vehicleKey)
            else
                AddMoney(src, price)  -- refund
                Notify(src, Config.Texts.DealerTitle, Config.Texts.PurchaseFail,
                       Config.Textures.cross[1], Config.Textures.cross[2])
            end
        end)
    end)
end)

--- Player requests to DELETE / SELL a vehicle
RegisterServerEvent("lxr-vehicles:deleteVehicle")
AddEventHandler("lxr-vehicles:deleteVehicle", function(vehicleDbId)
    local src    = source
    local player = GetPlayerData(src)
    if not player then return end

    DeleteVehicleRecord(vehicleDbId, player.charId, function(ok)
        if ok then
            Notify(src, Config.Texts.DealerTitle, Config.Texts.DeleteSuccess,
                   Config.Textures.tick[1], Config.Textures.tick[2])
            LoadOwnedVehicles(src, player.charId)
        end
    end)
end)

--- Transfer a vehicle to another player
RegisterServerEvent("lxr-vehicles:transferVehicle")
AddEventHandler("lxr-vehicles:transferVehicle", function(vehicleDbId, targetCharId, price)
    local src    = source
    local player = GetPlayerData(src)
    if not player then return end

    price = tonumber(price) or 0

    db:execute(
        "UPDATE lxr_vehicles SET status = ? WHERE id = ? AND charidentifier = ?",
        {json.encode({transferTarget = targetCharId, price = price}), vehicleDbId, player.charId},
        function(result)
            if result and result.affectedRows > 0 then
                Notify(src, Config.Texts.DealerTitle, Config.Texts.TransferSent,
                       Config.Textures.tick[1], Config.Textures.tick[2])
            end
        end
    )
end)

--- Accept or decline a transfer offer
RegisterServerEvent("lxr-vehicles:acceptTransfer")
AddEventHandler("lxr-vehicles:acceptTransfer", function(vehicleDbId, accepted, price)
    local src    = source
    local player = GetPlayerData(src)
    if not player then return end

    price = tonumber(price) or 0

    if not accepted then
        db:execute("UPDATE lxr_vehicles SET status = NULL WHERE id = ?", {vehicleDbId}, function()
            Notify(src, Config.Texts.DealerTitle, Config.Texts.TransferDecline,
                   Config.Textures.cross[1], Config.Textures.cross[2])
            LoadOwnedVehicles(src, player.charId)
        end)
        return
    end

    if player.money < price then
        Notify(src, Config.Texts.DealerTitle, Config.Texts.CantAfford,
               Config.Textures.cross[1], Config.Textures.cross[2])
        return
    end

    db:execute(
        "UPDATE lxr_vehicles SET status = NULL, charidentifier = ? WHERE id = ?",
        {player.charId, vehicleDbId},
        function(result)
            if result and result.affectedRows > 0 then
                if price > 0 then RemoveMoney(src, price) end
                Notify(src, Config.Texts.DealerTitle, Config.Texts.TransferAccept,
                       Config.Textures.tick[1], Config.Textures.tick[2])
                LoadOwnedVehicles(src, player.charId)
            end
        end
    )
end)

--- Load garage (owned vehicles) for client
RegisterServerEvent("lxr-vehicles:loadGarage")
AddEventHandler("lxr-vehicles:loadGarage", function()
    local src    = source
    local player = GetPlayerData(src)
    if not player then return end
    LoadOwnedVehicles(src, player.charId)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 WATER CHECK NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterServerEvent("lxr-vehicles:needWater")
AddEventHandler("lxr-vehicles:needWater", function()
    local src = source
    Notify(src, Config.Texts.DealerTitle, Config.Texts.WaterOnly,
           Config.Textures.alert[1], Config.Textures.alert[2])
end)

-- backward compat
RegisterServerEvent("Notification:NeedWaterToSpawn")
AddEventHandler("Notification:NeedWaterToSpawn", function()
    local src = source
    TriggerClientEvent("lxr-vehicles:notify", src,
        "Dealership", Config.Texts.WaterOnly, "menu_textures", "stamp_locked_rank", 2500)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK CHARACTER LOAD EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- LXR / RSG: Character selected
AddEventHandler("LXRCore:Server:PlayerLoaded", function(player)
    if player and player.PlayerData then
        local charId = player.PlayerData.charinfo and player.PlayerData.charinfo.id or 0
        LoadOwnedVehicles(player.PlayerData.source, charId)
    end
end)

AddEventHandler("RSGCore:Server:PlayerLoaded", function(player)
    if player and player.PlayerData then
        local charId = player.PlayerData.charinfo and player.PlayerData.charinfo.id or 0
        LoadOwnedVehicles(player.PlayerData.source, charId)
    end
end)

-- VORP: Character selected
AddEventHandler("vorp:SelectedCharacter", function(src, charId)
    LoadOwnedVehicles(src, charId)
end)
