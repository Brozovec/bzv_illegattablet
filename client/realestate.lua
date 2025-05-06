
local ESX = exports['es_extended']:getSharedObject()

local warehouses = {
    ["wh1"] = {
        name = "Industrial Warehouse #1",
        price = 0.045,
        coords = vector3(1204.73, -3116.22, 5.54),
        blip = { sprite = 473, color = 5 }
    },
    ["wh2"] = {
        name = "Dock Storage #3",
        price = 0.035,
        coords = vector3(955.12, -1510.41, 31.17),
        blip = { sprite = 473, color = 5 }
    },
    ["wh3"] = {
        name = "Desert Facility",
        price = 0.028,
        coords = vector3(2344.13, 3134.46, 48.21),
        blip = { sprite = 473, color = 5 }
    },
    ["wh4"] = {
        name = "Underground Storage",
        price = 0.065,
        coords = vector3(152.43, -3211.87, 5.9),
        blip = { sprite = 473, color = 5 }
    }
}

local ownedWarehouses = {}

-- Purchase warehouse
RegisterNUICallback('purchaseWarehouse', function(data, cb)
    if not data.warehouseId then
        cb({ success = false, message = 'Nebyl vybrán warehouse' })
        return
    end
    
    local warehouse = warehouses[data.warehouseId]
    
    if not warehouse then
        cb({ success = false, message = 'Neplatný warehouse' })
        return
    end
    
    TriggerServerEvent('blackmarket:purchaseWarehouse', data.warehouseId, warehouse.price)
    cb({ success = true })
end)

-- Get owned warehouses
RegisterNetEvent('blackmarket:openUI')
AddEventHandler('blackmarket:openUI', function()
    TriggerServerEvent('blackmarket:getOwnedWarehouses')
end)

-- Update owned warehouses
RegisterNetEvent('blackmarket:setOwnedWarehouses')
AddEventHandler('blackmarket:setOwnedWarehouses', function(warehouses)
    ownedWarehouses = warehouses
    
    SendNUIMessage({
        type = 'setOwnedWarehouses',
        warehouses = warehouses
    })
    
    -- Create blips for owned warehouses
    for _, warehouseId in ipairs(warehouses) do
        local warehouse = warehouses[warehouseId]
        if warehouse then
            local blip = AddBlipForCoord(warehouse.coords.x, warehouse.coords.y, warehouse.coords.z)
            SetBlipSprite(blip, warehouse.blip.sprite)
            SetBlipColour(blip, warehouse.blip.color)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Váš warehouse: " .. warehouse.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Warehouse purchase result
RegisterNetEvent('blackmarket:warehousePurchaseResult')
AddEventHandler('blackmarket:warehousePurchaseResult', function(success, message, warehouseId)
    if success then
        ESX.ShowNotification('Úspěšně jste zakoupili warehouse: ' .. warehouses[warehouseId].name)
        
        -- Add to owned warehouses
        table.insert(ownedWarehouses, warehouseId)
        
        -- Update the UI
        SendNUIMessage({
            type = 'setOwnedWarehouses',
            warehouses = ownedWarehouses
        })
        
        -- Create a blip for the new warehouse
        local warehouse = warehouses[warehouseId]
        local blip = AddBlipForCoord(warehouse.coords.x, warehouse.coords.y, warehouse.coords.z)
        SetBlipSprite(blip, warehouse.blip.sprite)
        SetBlipColour(blip, warehouse.blip.color)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Váš warehouse: " .. warehouse.name)
        EndTextCommandSetBlipName(blip)
        
        -- Update money
        TriggerServerEvent('blackmarket:refreshMoney')
    else
        ESX.ShowNotification(message)
    end
end)
