
local ESX = exports['es_extended']:getSharedObject()

Config = {
    BlackmarketPCs = {
        [1] = {
            model = `prop_laptop_01a`,
            coords = vector4(154.5314, -1007.3723, -98.3334, 213.2524),
            password = 'xkr9vp'
        }
    },
    DefaultMoney = 0.0,
    RestrictedJobs = {
        ["police"] = true,
        ["sheriff"] = true,
        ["ambulance"] = true,
        ["sahp"] = true,

    },
    ExchangeRate = {
        Min = 0.00008,
        Max = 0.00012
    },
    HackingRewards = {
        ["bank"] = 0.01,
        ["traffic"] = 0.006, 
        ["corporate"] = 0.008
    },
    ShopItems = {
        ["thermite"] = {
            label = "Thermite",
            price = 0.0981,
            item = "thermite"
        },
        ["hacking_laptop"] = {
            label = "Hacking Laptop",
            price = 1.501,
            item = "hacking_laptop"
        },
        ["illegal_ntbk"] = {
            label = "Notebook",
            price = 2.058,
            item = "illegal_ntbk"
        },
        ["cracker"] = {
            label = "Signal Přijímač",
            price = 1.110,
            item = "cracker"
        },
        ["usb_drive"] = {
            label = "USBčko",
            price = 0.800,
            item = "usb_drive"
        }
    },
    Webhooks = {
        Auth = {
            Registration = "https://discord.com/api/webhooks/1362034910969462856/NoTM3MzLTGXeZPkqcbV1fRrzmiWpSYGe26NZfegDWB8opbZj-SO-RemJJt_Nlkz7ezcy",      -- New user registration
            Login = "https://discord.com/api/webhooks/1362034983547703296/ZlNI545FYGGlOvfhjhFk16lJh02j-TVx2RSSmNiCL6fQHBUw81_a-rIhm8RN8KmIhnOX",            -- Successful login
            LoginFailed = "https://discord.com/api/webhooks/1362035053076549963/wA6F9LKNB3lqy3XHzvCHAgJO2TjhfoDtVQT6_eL3g6ODUxVAEHBN6GFnZFKmeVqYqU0q",      -- Failed login attempts
            BlacklistedJob = "https://discord.com/api/webhooks/1362035136169771059/8USpssuH1OKNXcvcxH3Q9h5gOxG6bbMr7hu7ILZYw5kWVtGr_8x0Z0TmJgWjwYaCRTZS"    -- Restricted job access attempt
        },
        
        Apps = {
            Purchase = "https://discord.com/api/webhooks/1362035226590843141/_2YPQqfmFkKO7xc__ajauNXg1GInVUAPgMo3-L6xsSm-za5C5OWYtYpLU3jDTZLgJ2Ee",         -- App purchases
            Download = "https://discord.com/api/webhooks/1362035283750551612/j_kyGSuTZsaaqVqdwESJa-PzcgXQkWeTEzuYLo1oTnF13DnfNeBzBfzRDvfr0LqFAPzZ",         -- App downloads
            Installation = "https://discord.com/api/webhooks/1362035357721432225/5JraGSpr80xyCKfR8FMwjv1zUiyTEkbxbu-TCdUFoSBxAYZnHfxwCd2sILJhZkkrjraj",     -- App installations
            PurchaseFailed = "https://discord.com/api/webhooks/1362035438445138003/Ej2Ki-Xw1yy2_pNVE41qwuFUB-UnFgdog4VOwIHjSK2tuBB1FFqRPijNbAEXVeseGy99"   -- Failed purchases
        },
        
        Finance = {
            MoneyConverted = "https://discord.com/api/webhooks/1362035533190008985/6cNTd0VZclKU_gy7g3cK5cmzC5RIG-LBgFCx_OYtsjtO1jwKl3tQZTA1n8en9b98IAOl",   -- Money conversion
            MoneyAdded = "https://discord.com/api/webhooks/1362035612357628164/vrRf3g8vKEHPYoCElvjeVQoab0Yl2JHuxsxjPWg9IQrlsAQnh7tF_3LiXfOiPJhiAjA6",       -- NetCoins added
            Purchase = "https://discord.com/api/webhooks/1362035679848042557/Cru-7aYVlifCgADrxDDjSuT1brYVUrDAkI7jd1jHnf-e1EcFMcnj-Y17v5O-XXponMfz",         -- Shop purchases
            ExchangeRate = "https://discord.com/api/webhooks/1362035733824798842/FEHjx7TK3Ncc70s6ydji7L5v5GMDmSWmYim3xuBVS-s3Q1BbT8ddrvZtONkXiYbGnT--"      -- Exchange rate updates
        },
        
        Jobs = {
            Started = "https://discord.com/api/webhooks/1362035821468844306/wyRhE4zEl3XC-jR0l_NmLOVyjZJmCkwY5YMhQwtTDmziuAEIn75azH7_4GPkmBznrmEB",         -- Job started
            Completed = "https://discord.com/api/webhooks/1362035887587852401/wx_zbXLfKovCwyVMmgBUbLMsIHLDFUHkxmRAy4pTJaOy-RCy48Le-8YEgSDxCWUG-V4B",       -- Job completed
            Failed = "https://discord.com/api/webhooks/1362035953622843412/gV9V8oYKAMe5vcjCM5__3UO8CbTqH6-mw5POlTr4Qi7VPCmWuEOHCQTIe5uAWARVuP7a",          -- Job failed
            Salary = "https://discord.com/api/webhooks/1362036065518751755/EeBIRghImQdH-IMkBmyu-wmpuukV_hcErsLom_ci156SDRb1Ny7XkzoWkJDUmCBKStmb",          -- Salary paid
            Bonus = "https://discord.com/api/webhooks/1362036123488227329/alE8mW5lU9wNXKCyJwzqvZTlxnLY2lIBmEG9sbi6INgqBon9-rkAPXVKp-5hEOmkW-kz"           -- Bonus earned
        },
        
        Hacking = {
            Started = "https://discord.com/api/webhooks/1362036303688110200/wQASRxGskdfHiyeBguIncHHUrt59tF2e6gTbvpkZOEKESoKHE1887LdK5rdR0WqPw7Pz",         -- Hack started
            Success = "https://discord.com/api/webhooks/1362036381777658036/Cxr5wFYjm3uRATeYPK8doDQuZh_LQl1qWfL4hxGScvn-5YDUboyHoulbEU_cmNyBFYcU",         -- Hack successful
            Failed = "https://discord.com/api/webhooks/1362047318949494924/2t-QJkyqW3k-ozUt75Xi5WjR9PEUAb-aFCB55cV5Lk8N2RiRAuyyrJMBibNeOvG17d9K",          -- Hack failed
            Bank = "https://discord.com/api/webhooks/1362047404689592514/xKeCcGUQ1hlPqplmDruqt1Bt1CI6jbUzsq3gz-EcSybzr6yJZJKzNjSMy69E0AcPa50V",           -- Bank hack
            Traffic = "https://discord.com/api/webhooks/1362047678795616568/FjtQZ74mALeEzKwoOyDG41Vi3uSK-wb9zVkRj_VA78MQvW11w4FXZhg49-PGML9cXciU",        -- Traffic system hack
            Corporate = "https://discord.com/api/webhooks/1362047678795616568/FjtQZ74mALeEzKwoOyDG41Vi3uSK-wb9zVkRj_VA78MQvW11w4FXZhg49-PGML9cXciU"       -- Corporate network hack
        },
        
        Shop = {
            ItemPurchase = "https://discord.com/api/webhooks/1362047850158227597/fJf9lcoAo0su0xPvKNXN8hWQlpiakdXfyWYBDow_exd_8MZ3eUoYoIq5fQejcvEdQRAc",    -- General item purchase
            ThermitePurchase = "https://discord.com/api/webhooks/1362047909587325048/8PYxHc6aSBFXUELd44Uyp6JNLbUiuLO8Bb0YTngQr9rILsUptHGnTZC2otR3A8FievnC", -- Thermite purchase
            LaptopPurchase = "https://discord.com/api/webhooks/1362047988406685837/r_iz1N4CMPt6_YyU_FzlzmBpNOP3d4dnFei7TRw2lygn7pZeUi6xUj7rHQAZ3x9My0A6",   -- Hacking laptop purchase
            ToolkitPurchase = "https://discord.com/api/webhooks/1362048064747081868/l3SqEVM_6POfgUXhrJ6eAV-GFpaIVdDNvFp0BnPQYopr1qFkPKxTzN83GrAZHW0uTCnE"   -- Toolkit purchase
        },
        
        System = {
            Notification = "https://discord.com/api/webhooks/1362048149589590279/GAoSAt_wEyqJ9NlOGjtZHsKNyyParNroJg6B_aJfWrWpXvjWfkuqu6OBBxo_sfcZzIfB",     -- New notification
            Alert = "https://discord.com/api/webhooks/1362048201011494932/_pXJ8-ucKAgxRnOeaQwqKoZDkXKWmH4uDbu79G6cUDVe8V78eXeYRB-beH-5Qsd9a8L6",           -- System alert
            Suspicious = "https://discord.com/api/webhooks/1362048279126474812/3r47-3M0D8ZRUV97PW_Zd0KiaT-YzkpAv8GfW_ACbxSjkh2zl_uziERBKSJSTmhcV27U"       -- Suspicious activity
        }
    }
}

-- Helper function to send webhooks
local function SendWebhook(webhookUrl, data)
    if webhookUrl == "" then return end
    
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

-- Function to generate random exchange rate
local function GenerateExchangeRate()
    return Config.ExchangeRate.Min + math.random() * (Config.ExchangeRate.Max - Config.ExchangeRate.Min)
end

local currentExchangeRate = GenerateExchangeRate()

-- Exchange rate update thread
CreateThread(function()
    while true do
        Wait(24 * 60 * 60 * 1000) -- 24 hours
        local oldRate = currentExchangeRate
        currentExchangeRate = GenerateExchangeRate()
        
        -- Send exchange rate update webhook
        if Config.Webhooks.Finance.ExchangeRate ~= "" then
            SendWebhook(Config.Webhooks.Finance.ExchangeRate, {
                username = "BlackMarket System",
                embeds = {{
                    title = "Exchange Rate Updated",
                    color = 45015,
                    fields = {
                        {
                            name = "Old Rate",
                            value = tostring(oldRate),
                            inline = true
                        },
                        {
                            name = "New Rate",
                            value = tostring(currentExchangeRate),
                            inline = true
                        },
                        {
                            name = "Change",
                            value = string.format("%.8f", currentExchangeRate - oldRate),
                            inline = true
                        }
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            })
        end
    end
end)

-- Database initialization
CreateThread(function()
    exports.oxmysql:execute("SHOW TABLES LIKE 'blackmarket_users'", {}, function(result)
        if result == nil or #result == 0 then
            print('[Blackmarket] Table does not exist, creating new...')
            exports.oxmysql:execute([[
                CREATE TABLE IF NOT EXISTS blackmarket_users (
                    id int(11) NOT NULL AUTO_INCREMENT,
                    identifier varchar(255) NOT NULL,
                    money decimal(14,4) NOT NULL DEFAULT 0.0000,
                    purchased_apps TEXT NOT NULL DEFAULT '[]',
                    installed_apps TEXT NOT NULL DEFAULT '[]',
                    PRIMARY KEY (id),
                    UNIQUE KEY identifier (identifier)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ]], {}, function(result)
                if result then
                    print('[Blackmarket] Database successfully initialized')
                else
                    print('[Blackmarket] Error initializing database')
                end
            end)
        else
            print('[Blackmarket] Table blackmarket_users already exists')
            
            exports.oxmysql:execute("SHOW COLUMNS FROM blackmarket_users LIKE 'installed_apps'", {}, function(columnResult)
                if columnResult == nil or #columnResult == 0 then
                    print('[Blackmarket] Adding installed_apps column...')
                    exports.oxmysql:execute([[
                        ALTER TABLE blackmarket_users 
                        ADD COLUMN installed_apps TEXT NOT NULL DEFAULT '[]'
                    ]], {}, function(alterResult)
                        if alterResult then
                            print('[Blackmarket] Column installed_apps successfully added')
                        else
                            print('[Blackmarket] Error adding column installed_apps')
                        end
                    end)
                end
            end)
        end
    end)
end)

-- Database helper functions
local function GetUserData(identifier, callback)
    if not identifier then
        print('[Blackmarket] Error: Attempted to get user data with nil identifier')
        if callback then callback(nil) end
        return
    end
    
    exports.oxmysql:execute('SELECT * FROM blackmarket_users WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] then
            callback(result[1])
        else
            callback(nil)
        end
    end)
end

local function UpdateUserMoney(identifier, amount)
    if not identifier then
        print('[Blackmarket] Error: Attempted to update money with nil identifier')
        return
    end
    
    exports.oxmysql:execute('UPDATE blackmarket_users SET money = ? WHERE identifier = ?',
        {amount, identifier})
end

local function UpdateUserPurchases(identifier, purchasedApps)
    if not identifier then
        print('[Blackmarket] Error: Attempted to update purchases with nil identifier')
        return
    end
    
    local jsonApps = json.encode(purchasedApps)
    exports.oxmysql:execute('UPDATE blackmarket_users SET purchased_apps = ? WHERE identifier = ?',
        {jsonApps, identifier})
end

local function UpdateUserInstalls(identifier, installedApps)
    if not identifier then
        print('[Blackmarket] Error: Attempted to update installs with nil identifier')
        return
    end
    
    local jsonApps = json.encode(installedApps)
    exports.oxmysql:execute('UPDATE blackmarket_users SET installed_apps = ? WHERE identifier = ?',
        {jsonApps, identifier})
end

local function CreateNewUser(identifier, callback)
    if not identifier then
        print('[Blackmarket] Error: Attempted to create user with nil identifier')
        if callback then callback(nil) end
        return
    end
    
    exports.oxmysql:execute([[
        INSERT INTO blackmarket_users 
        (identifier, money, purchased_apps, installed_apps) 
        VALUES (?, ?, ?, ?)
    ]], {
        identifier, 
        Config.DefaultMoney, 
        '[]',
        '[]'
    }, function(result)
        print('[Blackmarket] New user created: ' .. identifier)
        
        -- Send registration webhook
        if Config.Webhooks.Auth.Registration ~= "" then
            SendWebhook(Config.Webhooks.Auth.Registration, {
                username = "BlackMarket System",
                embeds = {{
                    title = "New User Registration",
                    color = 5814783,
                    fields = {
                        {
                            name = "User ID",
                            value = identifier,
                            inline = true
                        },
                        {
                            name = "Time",
                            value = os.date("%Y-%m-%d %H:%M:%S"),
                            inline = true
                        }
                    }
                }}
            })
        end
        
        GetUserData(identifier, callback)
    end)
end

local function IsJobRestricted(job)
    return Config.RestrictedJobs[job] or false
end

-- Event Handlers
RegisterNetEvent('blackmarket:verifyPassword')
AddEventHandler('blackmarket:verifyPassword', function(password)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    local pc = Config.BlackmarketPCs[1]
    
    if not identifier then
        TriggerClientEvent('esx:showNotification', src, 'Error identifying user!')
        TriggerClientEvent('blackmarket:passwordIncorrect', src)
        return
    end
    
    local playerJob = xPlayer.job.name
    if IsJobRestricted(playerJob) then
        -- Send blacklisted job webhook
        if Config.Webhooks.Auth.BlacklistedJob ~= "" then
            SendWebhook(Config.Webhooks.Auth.BlacklistedJob, {
                username = "BlackMarket System",
                embeds = {{
                    title = "Restricted Job Access Attempt",
                    color = 15158332,
                    fields = {
                        {
                            name = "User",
                            value = identifier,
                            inline = true
                        },
                        {
                            name = "Job",
                            value = playerJob,
                            inline = true
                        }
                    }
                }}
            })
        end
        TriggerClientEvent('esx:showNotification', src, 'Law enforcement cannot access this device!')
        TriggerClientEvent('blackmarket:passwordIncorrect', src)
        return
    end
    
    if password == pc.password then
        GetUserData(identifier, function(userData)
            if not userData then
                CreateNewUser(identifier, function(newUserData)
                    if newUserData then
                        -- Send login webhook
                        if Config.Webhooks.Auth.Login ~= "" then
                            SendWebhook(Config.Webhooks.Auth.Login, {
                                username = "BlackMarket System",
                                embeds = {{
                                    title = "User Login",
                                    color = 5814783,
                                    fields = {
                                        {
                                            name = "User",
                                            value = identifier,
                                            inline = true
                                        },
                                        {
                                            name = "Status",
                                            value = "New User",
                                            inline = true
                                        }
                                    }
                                }}
                            })
                        end
                        
                        TriggerClientEvent('blackmarket:updateMoney', src, newUserData.money)
                        TriggerClientEvent('blackmarket:updatePurchases', src, json.decode(newUserData.purchased_apps) or {})
                        TriggerClientEvent('blackmarket:setExchangeRate', src, currentExchangeRate)
                        TriggerClientEvent('blackmarket:updateInstalledApps', src, json.decode(newUserData.installed_apps) or {})
                        TriggerClientEvent('blackmarket:openUI', src)
                    else
                        TriggerClientEvent('esx:showNotification', src, 'Error creating user!')
                        TriggerClientEvent('blackmarket:passwordIncorrect', src)
                    end
                end)
            else
                -- Send login webhook
                if Config.Webhooks.Auth.Login ~= "" then
                    SendWebhook(Config.Webhooks.Auth.Login, {
                        username = "BlackMarket System",
                        embeds = {{
                            title = "User Login",
                            color = 5814783,
                            fields = {
                                {
                                    name = "User",
                                    value = identifier,
                                    inline = true
                                },
                                {
                                    name = "Status",
                                    value = "Existing User",
                                    inline = true
                                }
                            }
                        }}
                    })
                end
                
                TriggerClientEvent('blackmarket:updateMoney', src, userData.money)
                TriggerClientEvent('blackmarket:updatePurchases', src, json.decode(userData.purchased_apps) or {})
                TriggerClientEvent('blackmarket:setExchangeRate', src, currentExchangeRate)
                TriggerClientEvent('blackmarket:updateInstalledApps', src, json.decode(userData.installed_apps) or {})
                TriggerClientEvent('blackmarket:openUI', src)
            end
        end)
    else
        -- Send failed login webhook
        if Config.Webhooks.Auth.LoginFailed ~= "" then
            SendWebhook(Config.Webhooks.Auth.LoginFailed, {
                username = "BlackMarket System",
                embeds = {{
                    title = "Failed Login Attempt",
                    color = 15158332,
                    fields = {
                        {
                            name = "User",
                            value = identifier,
                            inline = true
                        }
                    }
                }}
            })
        end
        
        TriggerClientEvent('esx:showNotification', src, 'Wrong password!')
        TriggerClientEvent('blackmarket:passwordIncorrect', src)
    end
end)

RegisterNetEvent('blackmarket:purchaseApp')
AddEventHandler('blackmarket:purchaseApp', function(appId, appPrice)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    GetUserData(identifier, function(userData)
        if not userData then
            TriggerClientEvent('esx:showNotification', src, 'Error: User not found!')
            return
        end
        
        local price = tonumber(appPrice)
        local userMoney = tonumber(userData.money)
        
        if userMoney < price then
            -- Send failed purchase webhook
            if Config.Webhooks.Apps.PurchaseFailed ~= "" then
                SendWebhook(Config.Webhooks.Apps.PurchaseFailed, {
                    username = "BlackMarket System",
                    embeds = {{
                        title = "Failed App Purchase",
                        color = 15158332,
                        fields = {
                            {
                                name = "User",
                                value = identifier,
                                inline = true
                            },
                            {
                                name = "App",
                                value = appId,
                                inline = true
                            },
                            {
                                name = "Reason",
                                value = "Insufficient funds",
                                inline = true
                            }
                        }
                    }}
                })
            end
            
            TriggerClientEvent('esx:showNotification', src, 'Not enough NetCoins!')
            return
        end
        
        local purchasedApps = json.decode(userData.purchased_apps) or {}
        
        -- Check if already purchased
        for _, id in ipairs(purchasedApps) do
            if id == appId then
                TriggerClientEvent('esx:showNotification', src, 'You already own this app!')
                return
            end
        end
        
        -- Process purchase
        local newAmount = userMoney - price
        table.insert(purchasedApps, appId)
        
        UpdateUserMoney(identifier, newAmount)
        UpdateUserPurchases(identifier, purchasedApps)
        
        -- Send purchase webhook
        if Config.Webhooks.Apps.Purchase ~= "" then
            SendWebhook(Config.Webhooks.Apps.Purchase, {
                username = "BlackMarket System",
                embeds = {{
                    title = "App Purchase",
                    color = 5814783,
                    fields = {
                        {
                            name = "User",
                            value = identifier,
                            inline = true
                        },
                        {
                            name = "App",
                            value = appId,
                            inline = true
                        },
                        {
                            name = "Price",
                            value = tostring(price) .. " NetCoins",
                            inline = true
                        }
                    }
                }}
            })
        end
        
        TriggerClientEvent('blackmarket:updateMoney', src, newAmount)
        TriggerClientEvent('blackmarket:updatePurchases', src, purchasedApps)
        TriggerClientEvent('esx:showNotification', src, 'App purchased!')
    end)
end)

RegisterNetEvent('blackmarket:installApp')
AddEventHandler('blackmarket:installApp', function(appId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    GetUserData(identifier, function(userData)
        if not userData then
            TriggerClientEvent('esx:showNotification', src, 'Error: User not found!')
            return
        end
        
        local installedApps = json.decode(userData.installed_apps) or {}
        
        -- Check if already installed
        for _, id in ipairs(installedApps) do
            if id == appId then
                TriggerClientEvent('esx:showNotification', src, 'This app is already installed!')
                return
            end
        end
        
        table.insert(installedApps, appId)
        UpdateUserInstalls(identifier, installedApps)
        
        -- Send installation webhook
        if Config.Webhooks.Apps.Installation ~= "" then
            SendWebhook(Config.Webhooks.Apps.Installation, {
                username = "BlackMarket System",
                embeds = {{
                    title = "App Installation",
                    color = 5814783,
                    fields = {
                        {
                            name = "User",
                            value = identifier,
                            inline = true
                        },
                        {
                            name = "App",
                            value = appId,
                            inline = true
                        }
                    }
                }}
            })
        end
        
        TriggerClientEvent('blackmarket:updateInstalledApps', src, installedApps)
        TriggerClientEvent('esx:showNotification', src, 'App installed!')
    end)
end)

RegisterNetEvent('blackmarket:convertMoney')
AddEventHandler('blackmarket:convertMoney', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    local playerMoney = xPlayer.getMoney()
    
    if playerMoney < amount then
        TriggerClientEvent('esx:showNotification', src, 'Not enough money!')
        return
    end
    
    GetUserData(identifier, function(userData)
        if not userData then
            TriggerClientEvent('esx:showNotification', src, 'Error: User not found!')
            return
        end
        
        xPlayer.removeMoney(amount)
        
        local netCoinsAmount = amount * currentExchangeRate
        local newBalance = userData.money + netCoinsAmount
        
        UpdateUserMoney(identifier, newBalance)
        
        -- Send money converted webhook
        if Config.Webhooks.Finance.MoneyConverted ~= "" then
            SendWebhook(Config.Webhooks.Finance.MoneyConverted, {
                username = "BlackMarket System",
                embeds = {{
                    title = "Money Conversion",
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
        
        TriggerClientEvent('blackmarket:updateMoney', src, newBalance)
        TriggerClientEvent('esx:showNotification', src, 
            string.format('Converted %.2f $ to %.4f NetCoins', amount, netCoinsAmount))
    end)
end)

-- Job reward ranges configuration
local jobRewards = {
    courier = {
        min = 0.0015,
        max = 0.0020
    },
    warehouse = {
        min = 0.0018,
        max = 0.0025
    },
    bartender = {
        min = 0.0020,
        max = 0.0028
    }
}

-- Helper function to get random reward within range
local function GetRandomReward(jobId)
    local jobConfig = jobRewards[jobId]
    if not jobConfig then return 0 end
    
    return jobConfig.min + math.random() * (jobConfig.max - jobConfig.min)
end

-- Modified completeJob event handler
RegisterNetEvent('blackmarket:completeJob')
AddEventHandler('blackmarket:completeJob', function(jobId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    if not jobRewards[jobId] then return end
    
    local reward = GetRandomReward(jobId)
    
    GetUserData(identifier, function(userData)
        if userData then
            local newAmount = userData.money + reward
            UpdateUserMoney(identifier, newAmount)
            
            -- Send job completed webhook
            if Config.Webhooks.Jobs.Completed ~= "" then
                SendWebhook(Config.Webhooks.Jobs.Completed, {
                    username = "BlackMarket System",
                    embeds = {{
                        title = "Job Completed",
                        color = 5814783,
                        fields = {
                            {
                                name = "User",
                                value = identifier,
                                inline = true
                            },
                            {
                                name = "Job",
                                value = jobId,
                                inline = true
                            },
                            {
                                name = "Reward",
                                value = string.format("%.4f NetCoins", reward),
                                inline = true
                            }
                        }
                    }}
                })
            end
            
            TriggerClientEvent('blackmarket:updateMoney', src, newAmount)
            TriggerClientEvent('esx:showNotification', src, 
                string.format('Job completed! Earned: %.4f NetCoins', reward))
        end
    end)
end)

RegisterNetEvent('blackmarket:completeHacking')
AddEventHandler('blackmarket:completeHacking', function(hackId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    local reward = Config.HackingRewards[hackId]
    if not reward then return end
    
    GetUserData(identifier, function(userData)
        if userData then
            local newAmount = userData.money + reward
            UpdateUserMoney(identifier, newAmount)
            
            -- Send hacking success webhook
            if Config.Webhooks.Hacking.Success ~= "" then
                SendWebhook(Config.Webhooks.Hacking.Success, {
                    username = "BlackMarket System",
                    embeds = {{
                        title = "Successful Hack",
                        color = 5814783,
                        fields = {
                            {
                                name = "User",
                                value = identifier,
                                inline = true
                            },
                            {
                                name = "Type",
                                value = hackId,
                                inline = true
                            },
                            {
                                name = "Reward",
                                value = tostring(reward) .. " NetCoins",
                                inline = true
                            }
                        }
                    }}
                })
            end
            
            TriggerClientEvent('blackmarket:updateMoney', src, newAmount)
            TriggerClientEvent('esx:showNotification', src, 
                string.format('Hack successful! Earned: %.4f NetCoins', reward))
        end
    end)
end)



RegisterNetEvent('blackmarket:refreshMoney')
AddEventHandler('blackmarket:refreshMoney', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    GetUserData(identifier, function(userData)
        if userData then
            TriggerClientEvent('blackmarket:updateMoney', src, userData.money)
        end
    end)
end)

RegisterNetEvent('blackmarket:getExchangeRate')
AddEventHandler('blackmarket:getExchangeRate', function()
    TriggerClientEvent('blackmarket:setExchangeRate', source, currentExchangeRate)
end)

RegisterNetEvent('blackmarket:newNotification')
AddEventHandler('blackmarket:newNotification', function(title, message)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    
    -- Send notification webhook
    if Config.Webhooks.System.Notification ~= "" then
        SendWebhook(Config.Webhooks.System.Notification, {
            username = "BlackMarket System",
            embeds = {{
                title = "New System Notification",
                color = 5814783,
                fields = {
                    {
                        name = "User",
                        value = xPlayer.identifier,
                        inline = true
                    },
                    {
                        name = "Title",
                        value = title,
                        inline = true
                    },
                    {
                        name = "Message",
                        value = message,
                        inline = false
                    }
                }
            }}
        })
    end
end)

