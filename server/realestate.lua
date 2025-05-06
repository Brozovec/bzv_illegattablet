
local ESX = exports['es_extended']:getSharedObject()

-- Table to track owned warehouses
local ownedWarehouses = {}

-- Load owned warehouses from database on resource start
CreateThread(function()
    MySQL.Async.fetchAll('SELECT identifier, warehouse_id FROM blackmarket_warehouses', {}, function(results)
        if results then
            for _, row in ipairs(results) do
                if row.identifier then
                    if not ownedWarehouses[row.identifier] then
                        ownedWarehouses[row.identifier] = {}
                    end
                    table.insert(ownedWarehouses[row.identifier], row.warehouse_id)
                end
            end
        end
    end)
end)

-- Purchase warehouse
RegisterServerEvent('blackmarket:purchaseWarehouse')
AddEventHandler('blackmarket:purchaseWarehouse', function(warehouseId, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local identifier = xPlayer.getIdentifier()
    
    if not identifier then
        TriggerClientEvent('blackmarket:warehousePurchaseResult', source, false, 'Chyba: Nelze identifikovat uživatele', warehouseId)
        return
    end
    
    -- Check if player already owns this warehouse
    if ownedWarehouses[identifier] and table.includes(ownedWarehouses[identifier], warehouseId) then
        TriggerClientEvent('blackmarket:warehousePurchaseResult', source, false, 'Již vlastníte tento warehouse', warehouseId)
        return
    end
    
    -- Check if player has enough NetCoins
    local netCoins = exports.ox_inventory:GetItem(source, 'netcoin', nil, true)
    
    if netCoins >= price then
        -- Remove NetCoins
        exports.ox_inventory:RemoveItem(source, 'netcoin', price)
        
        -- Add warehouse to player's owned warehouses
        if not ownedWarehouses[identifier] then
            ownedWarehouses[identifier] = {}
        end
        table.insert(ownedWarehouses[identifier], warehouseId)
        
        -- Save to database
        MySQL.Async.execute('INSERT INTO blackmarket_warehouses (identifier, warehouse_id) VALUES (@identifier, @warehouse_id)', {
            ['@identifier'] = identifier,
            ['@warehouse_id'] = warehouseId
        })
        
        -- Notify player
        TriggerClientEvent('blackmarket:warehousePurchaseResult', source, true, 'Úspěšně jste zakoupili warehouse', warehouseId)
        
        -- Update money
        TriggerClientEvent('blackmarket:updateMoney', source, exports.ox_inventory:GetItem(source, 'netcoin', nil, true))
    else
        TriggerClientEvent('blackmarket:warehousePurchaseResult', source, false, 'Nemáte dostatek NetCoinů', warehouseId)
    end
end)

-- Get owned warehouses
RegisterServerEvent('blackmarket:getOwnedWarehouses')
AddEventHandler('blackmarket:getOwnedWarehouses', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local identifier = xPlayer.getIdentifier()
    
    if not identifier then
        TriggerClientEvent('blackmarket:setOwnedWarehouses', source, {})
        return
    end
    
    TriggerClientEvent('blackmarket:setOwnedWarehouses', source, ownedWarehouses[identifier] or {})
end)

-- Helper function to check if table contains value
function table.includes(table, value)
    if not table then return false end
    
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end
