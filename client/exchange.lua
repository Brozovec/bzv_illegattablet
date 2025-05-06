
local ESX = exports['es_extended']:getSharedObject()

-- Get player's bank balance
RegisterNUICallback('getBankBalance', function(data, cb)
    ESX.TriggerServerCallback('blackmarket:getBankBalance', function(balance)
        cb({ success = true, balance = balance })
    end)
end)

RegisterNUICallback('convertMoney', function(data, cb)
    if not data.amount then
        cb({ success = false, message = 'Nebyla zadána částka' })
        return
    end
    
    local amount = tonumber(data.amount)
    local direction = data.direction or 'toBitcoin' -- Default is converting to bitcoin
    
    if not amount or amount <= 0 then
        cb({ success = false, message = 'Neplatná částka' })
        return
    end
    
    if direction == 'toBitcoin' then
        -- Converting money to NetCoins - check bank balance
        ESX.TriggerServerCallback('blackmarket:checkBankBalance', function(hasMoney)
            if hasMoney then
                TriggerServerEvent('blackmarket:convertMoney', amount, direction, data.expectedAmount)
                cb({ success = true })
            else
                cb({ success = false, message = 'Nemáte dostatek peněz v bance' })
            end
        end, amount)
    else
        -- Converting NetCoins to money - check NetCoins balance on server
        ESX.TriggerServerCallback('blackmarket:checkNetCoinsBalance', function(hasCoins)
            if hasCoins then
                TriggerServerEvent('blackmarket:convertMoney', amount, direction, data.expectedAmount)
                cb({ success = true })
            else
                cb({ success = false, message = 'Nemáte dostatek NetCoinů' })
            end
        end, amount)
    end
end)

-- Update exchange rate periodically
CreateThread(function()
    while true do
        Wait(15 * 60 * 1000) -- every 15 minutes
        
        -- Generate a slightly different exchange rate each time
        local baseRate = 0.00008 -- base rate
        local variation = math.random(-20, 20) / 100000 -- random variation
        local newRate = baseRate + variation
        
        -- Send the new exchange rate to NUI
        SendNUIMessage({
            type = 'setExchangeRate',
            rate = newRate
        })
        
        -- Also save it on the server
        TriggerServerEvent('blackmarket:updateExchangeRate', newRate)
    end
end)

-- Request initial exchange rate
RegisterNetEvent('blackmarket:openUI')
AddEventHandler('blackmarket:openUI', function()
    TriggerServerEvent('blackmarket:getExchangeRate')
end)

RegisterNetEvent('blackmarket:setExchangeRate')
AddEventHandler('blackmarket:setExchangeRate', function(rate)
    SendNUIMessage({
        type = 'setExchangeRate',
        rate = rate
    })
end)

RegisterNetEvent('blackmarket:showNotification')
AddEventHandler('blackmarket:showNotification', function(message)
    ESX.ShowNotification(message)
end)
