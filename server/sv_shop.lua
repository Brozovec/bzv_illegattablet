ESX = exports['es_extended']:getSharedObject()

local activeDeliveries = {}

-- Přidejte tuto funkci před vaši funkci purchaseItems
function SendWebhook(webhook, data)
    if webhook then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
    end
end

RegisterNetEvent('blackmarket:purchaseItems', function(items, totalPrice)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    -- Check if player already has an active delivery
    if activeDeliveries[src] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Blackmarket',
            description = 'Počkej na doručení před další objednávkou.',
            type = 'error'
        })
        return
    end

    -- Simulate getting NetCoin balance (replace this with your DB check)
    GetUserData(identifier, function(userData)
        if not userData then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Blackmarket',
                description = 'Uživatel nebyl nalezen.',
                type = 'error'
            })
            return
        end
    
        if userData.money < totalPrice then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Blackmarket',
                description = 'Nedostatek NetCoinů.',
                type = 'error'
            })
            return
        end
    
        -- Deduct money
        local newMoney = userData.money - totalPrice
        UpdateUserMoney(identifier, newMoney)
    
        -- Mark the player's order as active
        activeDeliveries[src] = true
    
        -- Close NUI and send notification
        TriggerClientEvent('blackmarket:closeNUI', src)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Blackmarket',
            description = 'Objednávka přijata. Budete kontaktováni v průběhu dne.',
            type = 'info'
        })
    
        -- Trigger the delivery job
        TriggerClientEvent('blackmarket:startDeliveryJob', src, {items = items})

        -- Send an SMS through lbphone (replace with your SMS integration if needed)
        TriggerEvent('lbphone:addMessage', identifier, 'BlackMarket', 'Vaše objednávka byla přijata a doručení je připraveno.')

        -- Webhook log (optional)
        if Config.Webhooks.Shop.ItemPurchase ~= "https://discord.com/api/webhooks/1363048200445104218/Mpyhfz4L0a86VnWYTAW9nwcLJkWb9PTQqArIrMBfml9Uk9fXnJgYHwR82_M4C43JXn40" then
            local itemList = {}
            for _, item in ipairs(items) do
                local itemData = Config.ShopItems[item.itemId]
                if itemData then
                    table.insert(itemList, string.format("- %s x%d", itemData.label, item.count or 1))
                end
            end
    
            SendWebhook(Config.Webhooks.Shop.ItemPurchase, {
                username = "BlackMarket System",
                embeds = {{
                    title = "Objednávka odeslána",
                    color = 45015,
                    fields = {
                        {
                            name = "Uživatel",
                            value = identifier,
                            inline = false
                        },
                        {
                            name = "Položky",
                            value = table.concat(itemList, "\n"),
                            inline = false
                        },
                        {
                            name = "Cena celkem",
                            value = tostring(totalPrice) .. " NetCoins",
                            inline = false
                        }
                    }
                }}
            })
        end
    end)
end)

lib.callback.register('blackmarket:giveItems', function(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    -- Debug: zkontrolujeme přijatá data na serveru
    print("Položky předané serveru: ", json.encode(data.items))

    if data and data.items then
        for _, item in ipairs(data.items) do
            if item.name and item.count then
                xPlayer.addInventoryItem(item.name, item.count) -- Přidání do inventáře
                print("Přidávám hráči položku: " .. item.name .. " x" .. item.count)
            else
                print("Chyba: Neplatný formát položky:", json.encode(item))
            end
        end
        TriggerClientEvent('esx:showNotification', source, 'Zásilka byla doručena!')
        return true
    else
        print("Chyba: data nebo items jsou nil")
        return false
    end
end)


