local ESX = exports['es_extended']:getSharedObject()

-- Current exchange rate
local exchangeRate = 0.00008 + math.random() * 0.00004

-- Debugging function to log safe messages
local function DebugLog(message)
    if message then
        print('[Blackmarket][Debug] ' .. tostring(message))
    end
end

-- Get player's bank balance
ESX.RegisterServerCallback('blackmarket:getBankBalance', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then 
        DebugLog('Player not found in getBankBalance')
        cb(0)
        return 
    end
    
    local bankBalance = xPlayer.getAccount('bank').money
    cb(bankBalance)
end)

-- Check if player has enough money in bank account
ESX.RegisterServerCallback('blackmarket:checkBankBalance', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then 
        DebugLog('Player not found in checkBankBalance')
        cb(false)
        return 
    end
    
    local bankBalance = xPlayer.getAccount('bank').money
    
    cb(bankBalance >= amount)
end)

-- Check if player has enough NetCoins
ESX.RegisterServerCallback('blackmarket:checkNetCoinsBalance', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then 
        DebugLog('Player not found in checkNetCoinsBalance')
        cb(false)
        return 
    end
    
    local identifier = xPlayer.identifier
    
    GetUserData(identifier, function(userData)
        if userData and userData.money then
            -- Ensure amount is properly compared as a number
            cb(tonumber(userData.money) >= tonumber(amount))
        else
            cb(false)
        end
    end)
end)

-- Function to send webhook messages safely
local function SendWebhook(webhookUrl, data)
    if not webhookUrl or webhookUrl == "" then return end
    
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

-- Function to safely check if a table exists
local function DoesTableExist(tableName, callback)
    if not tableName then
        DebugLog('Invalid table name in DoesTableExist')
        callback(false)
        return
    end
    
    exports.oxmysql:execute('SHOW TABLES LIKE ?', {tableName}, function(result)
        if result and #result > 0 then
            callback(true)
        else
            callback(false)
        end
    end)
end

-- Function to safely create the blackmarket_users table if it doesn't exist
local function EnsureTableExists(callback)
    DoesTableExist('blackmarket_users', function(exists)
        if not exists then
            DebugLog('blackmarket_users table does not exist, creating it')
            
            local query = [[
                CREATE TABLE IF NOT EXISTS `blackmarket_users` (
                    `id` int(11) NOT NULL AUTO_INCREMENT,
                    `identifier` varchar(60) NOT NULL,
                    `money` float DEFAULT 0,
                    `purchased_apps` longtext DEFAULT '[]',
                    `installed_apps` longtext DEFAULT '[]',
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `identifier` (`identifier`)
                );
            ]]
            
            exports.oxmysql:execute(query, {}, function(success)
                if success then
                    DebugLog('blackmarket_users table created successfully')
                    callback(true)
                else
                    DebugLog('Failed to create blackmarket_users table')
                    callback(false)
                end
            end)
        else
            callback(true)
        end
    end)
end

-- Function to safely get user data with proper error handling
function GetUserData(identifier, callback)
    if not identifier then
        DebugLog('GetUserData called with nil identifier')
        if callback then callback(nil) end
        return
    end
    
    -- Make sure the table exists first
    EnsureTableExists(function(tableExists)
        if not tableExists then
            DebugLog('Table does not exist and could not be created')
            if callback then callback(nil) end
            return
        end
        
        -- Now we can safely query the table
        exports.oxmysql:execute('SELECT * FROM blackmarket_users WHERE identifier = ?', {identifier}, function(result)
            if result and result[1] then
                -- Ensure money is stored as a number for consistent comparison
                if result[1].money then
                    result[1].money = tonumber(result[1].money)
                end
                callback(result[1])
            else
                callback(nil)
            end
        end)
    end)
end

-- Function to safely create user with proper error handling
function CreateUserIfNotExists(identifier, netCoinsAmount, callback)
    if not identifier then
        DebugLog('CreateUserIfNotExists called with nil identifier')
        if callback then callback(false) end
        return
    end
    
    -- Make sure netCoinsAmount is a number
    netCoinsAmount = tonumber(netCoinsAmount) or 0
    
    -- Make sure the table exists first
    EnsureTableExists(function(tableExists)
        if not tableExists then
            DebugLog('Table does not exist and could not be created')
            if callback then callback(false) end
            return
        end
        
        -- First check if user exists
        exports.oxmysql:execute('SELECT COUNT(*) as count FROM blackmarket_users WHERE identifier = ?', {identifier}, function(result)
            if not result or not result[1] then
                DebugLog('Error checking if user exists')
                if callback then callback(false) end
                return
            end
            
            -- If user doesn't exist, create them
            if result[1].count == 0 then
                exports.oxmysql:execute(
                    'INSERT INTO blackmarket_users (identifier, money, purchased_apps, installed_apps) VALUES (?, ?, ?, ?)',
                    {identifier, netCoinsAmount, '[]', '[]'},
                    function(insertResult)
                        if insertResult and insertResult.affectedRows > 0 then
                            DebugLog('New user created: ' .. identifier .. ' with ' .. netCoinsAmount .. ' NetCoins')
                            if callback then callback(true) end
                        else
                            DebugLog('Error creating new user')
                            if callback then callback(false) end
                        end
                    end
                )
            else
                if callback then callback(true) end  -- User already exists
            end
        end)
    end)
end

-- Function to safely update user money with proper error handling
function UpdateUserMoney(identifier, amount, callback)
    if not identifier then
        DebugLog('UpdateUserMoney called with nil identifier')
        if callback then callback(false) end
        return
    end
    
    -- Ensure amount is a number
    if type(amount) ~= "number" then
        DebugLog('Converting amount to number: ' .. tostring(amount))
        amount = tonumber(amount)
        
        if not amount then
            DebugLog('Failed to convert amount to number')
            if callback then callback(false) end
            return
        end
    end
    
    exports.oxmysql:execute('UPDATE blackmarket_users SET money = ? WHERE identifier = ?',
        {amount, identifier}, function(result)
            if result and result.affectedRows > 0 then
                DebugLog('Money updated for ' .. identifier .. ' to ' .. amount)
                if callback then callback(true) end
            else
                DebugLog('Error updating money for ' .. identifier)
                if callback then callback(false) end
            end
        end)
end

-- Convert money to NetCoins
RegisterServerEvent('blackmarket:convertMoney')
AddEventHandler('blackmarket:convertMoney', function(amount, direction, expectedAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerSource = source
    
    if not xPlayer then 
        DebugLog('Error: Player not found in convertMoney event')
        TriggerClientEvent('blackmarket:showNotification', playerSource, 'Chyba: Nelze identifikovat uživatele!')
        return 
    end
    
    -- Check if amount is valid
    if not amount or type(amount) ~= "number" or amount <= 0 then
        DebugLog('Error: Invalid amount in convertMoney: ' .. tostring(amount))
        TriggerClientEvent('blackmarket:showNotification', playerSource, 'Neplatná částka!')
        return
    end
    
    local identifier = xPlayer.identifier
    if not identifier then
        TriggerClientEvent('blackmarket:showNotification', playerSource, 'Chyba: Nelze identifikovat uživatele!')
        DebugLog('Error: Unable to identify user in convertMoney event')
        return
    end
    
    -- Handle conversion based on direction
    if direction == 'toBitcoin' then
        -- BANK MONEY TO NETCOINS
        -- Check bank balance
        local bankBalance = xPlayer.getAccount('bank').money
        
        if bankBalance >= amount then
            -- Calculate NetCoins amount
            local netCoinsAmount = amount * exchangeRate
            
            -- Remove money from player's bank account
            xPlayer.removeAccountMoney('bank', amount)
            
            -- Add NetCoins to the user's blackmarket account
            GetUserData(identifier, function(userData)
                if userData then
                    -- Parse the existing money value safely
                    local currentMoney = tonumber(userData.money) or 0
                    -- Add NetCoins to the user's blackmarket account
                    local newBalance = currentMoney + netCoinsAmount
                    
                    -- Update the database
                    UpdateUserMoney(identifier, newBalance, function(success)
                        if success then
                            -- Update client money immediately
                            TriggerClientEvent('blackmarket:updateMoney', playerSource, newBalance)
                            TriggerClientEvent('blackmarket:showNotification', playerSource, 
                                string.format('Převedli jste %.2f $ z banky na %.4f NetCoinů', amount, netCoinsAmount))
                            
                            -- Send money converted webhook
                            if Config and Config.Webhooks and Config.Webhooks.Finance and 
                               Config.Webhooks.Finance.MoneyConverted and Config.Webhooks.Finance.MoneyConverted ~= "" then
                                SendWebhook(Config.Webhooks.Finance.MoneyConverted, {
                                    username = "BlackMarket System",
                                    embeds = {{
                                        title = "Money Conversion (Bank to NetCoins)",
                                        color = 45015,
                                        fields = {
                                            {
                                                name = "User",
                                                value = identifier,
                                                inline = true
                                            },
                                            {
                                                name = "Amount",
                                                value = tostring(amount) .. " $",
                                                inline = true
                                            },
                                            {
                                                name = "NetCoins",
                                                value = string.format("%.4f", netCoinsAmount),
                                                inline = true
                                            }
                                        }
                                    }}
                                })
                            end
                            
                            DebugLog('Money conversion successful for ' .. identifier .. 
                                ': $' .. amount .. ' to ' .. netCoinsAmount .. ' NetCoins')
                        else
                            TriggerClientEvent('blackmarket:showNotification', playerSource, 'Chyba: Nelze aktualizovat váš účet!')
                        end
                    end)
                else
                    DebugLog('User not found, creating new account during money conversion')
                    
                    -- Create the user if not exists
                    CreateUserIfNotExists(identifier, netCoinsAmount, function(success)
                        if success then
                            -- Update client money immediately after successful user creation
                            TriggerClientEvent('blackmarket:updateMoney', playerSource, netCoinsAmount)
                            TriggerClientEvent('blackmarket:showNotification', playerSource, 
                                string.format('Účet vytvořen. Převedli jste %.2f $ na %.4f NetCoinů', amount, netCoinsAmount))
                            
                            DebugLog('New user created and money converted: ' .. identifier .. 
                                ' | $' .. amount .. ' to ' .. netCoinsAmount .. ' NetCoins')
                        else
                            TriggerClientEvent('blackmarket:showNotification', playerSource, 'Chyba: Nelze vytvořit uživatele!')
                        end
                    end)
                end
            end)
        else
            TriggerClientEvent('blackmarket:showNotification', playerSource, 'Nemáte dostatek peněz v bance!')
        end
    else
        -- NETCOINS TO BANK MONEY
        -- Check NetCoins balance
        GetUserData(identifier, function(userData)
            if userData and userData.money then
                local currentNetCoins = tonumber(userData.money) or 0
                
                if currentNetCoins >= amount then
                    -- Calculate money amount with fee
                    local conversionFee = 0.15 -- 15% fee
                    local moneyAmount = (amount / exchangeRate) * (1 - conversionFee)
                    
                    -- Remove NetCoins from user's account
                    local newNetCoinsBalance = currentNetCoins - amount
                    
                    -- Update the database
                    UpdateUserMoney(identifier, newNetCoinsBalance, function(success)
                        if success then
                            -- Add money to player's bank account
                            xPlayer.addAccountMoney('bank', moneyAmount)
                            
                            -- Update client money immediately
                            TriggerClientEvent('blackmarket:updateMoney', playerSource, newNetCoinsBalance)
                            TriggerClientEvent('blackmarket:showNotification', playerSource, 
                                string.format('Převedli jste %.4f NetCoinů na %.2f $ (poplatek 15%%)', amount, moneyAmount))
                            
                            -- Send money converted webhook
                            if Config and Config.Webhooks and Config.Webhooks.Finance and 
                               Config.Webhooks.Finance.MoneyConverted and Config.Webhooks.Finance.MoneyConverted ~= "" then
                                SendWebhook(Config.Webhooks.Finance.MoneyConverted, {
                                    username = "BlackMarket System",
                                    embeds = {{
                                        title = "Money Conversion (NetCoins to Bank)",
                                        color = 45015,
                                        fields = {
                                            {
                                                name = "User",
                                                value = identifier,
                                                inline = true
                                            },
                                            {
                                                name = "NetCoins",
                                                value = string.format("%.4f", amount),
                                                inline = true
                                            },
                                            {
                                                name = "Amount",
                                                value = string.format("%.2f $", moneyAmount),
                                                inline = true
                                            },
                                            {
                                                name = "Fee",
                                                value = "15%",
                                                inline = true
                                            }
                                        }
                                    }}
                                })
                            end
                            
                            DebugLog('NetCoins conversion successful for ' .. identifier .. 
                                ': ' .. amount .. ' NetCoins to $' .. moneyAmount)
                        else
                            TriggerClientEvent('blackmarket:showNotification', playerSource, 'Chyba: Nelze aktualizovat váš účet!')
                        end
                    end)
                else
                    TriggerClientEvent('blackmarket:showNotification', playerSource, 'Nemáte dostatek NetCoinů!')
                end
            else
                TriggerClientEvent('blackmarket:showNotification', playerSource, 'Chyba: Nelze načíst váš účet!')
            end
        end)
    end
end)

-- Update exchange rate
RegisterServerEvent('blackmarket:updateExchangeRate')
AddEventHandler('blackmarket:updateExchangeRate', function(rate)
    exchangeRate = rate
end)

-- Get current exchange rate
RegisterServerEvent('blackmarket:getExchangeRate')
AddEventHandler('blackmarket:getExchangeRate', function()
    TriggerClientEvent('blackmarket:setExchangeRate', source, exchangeRate)
end)
