local ESX = exports['es_extended']:getSharedObject()

local hackingCooldowns = {}
local installedApps = {}
local isProcessingHackResult = false
local hasReceivedReward = false  -- New flag to track if a reward has been given

RegisterNUICallback('closeHackingGame', function(data, cb)
    -- Always remove focus to return control to the player
    SetNuiFocus(false, false)
    
    -- Check if we're already processing a hack result to prevent duplicate notifications
    if isProcessingHackResult then
        cb({})
        return
    end
    
    -- Set flag to prevent multiple processing of the same hack result
    isProcessingHackResult = true
    
    -- Log result for debugging
    print('Hack completed via Lua:', json.encode(data))
    
    if data.success then
        -- Prevent duplicate rewards by checking if we've already processed this hack
        if hasReceivedReward then
            print('Warning: Duplicate reward attempt detected and prevented')
            isProcessingHackResult = false
            cb({})
            return
        end
        
        
        -- Set flag to prevent duplicate rewards
        hasReceivedReward = true
        
        -- Get location type from hack type
        local locationType = data.hackType
        local locationName = data.locationName or "Unknown Location"
        
        -- Rewards based on hack type
        local rewards = {
            bank = {cryptoAmount = 0.05, xpAmount = 500},
            traffic = {cryptoAmount = 0.03, xpAmount = 350},
            corporate = {cryptoAmount = 0.04, xpAmount = 400}
        }
        
        local reward = rewards[data.hackType] or {cryptoAmount = 0.02, xpAmount = 200}
        
        -- Send notification about successful hack - just once
        TriggerEvent('esx:showNotification', 'Hack úspěšný!')
        
        -- Send SMS notification using lb-phone instead of gc-phone
        Citizen.SetTimeout(2000, function()
            -- Poslat zprávu o úspěšném hacku
            TriggerServerEvent('blackmarket:server:sendMessage', {
                sender = 'DARK.NET',
                message = '💻 Hack úspěšný na lokaci: ' .. locationName .. '!',
                anon = true
            })
        
            -- Poslat zprávu s odměnou
            Citizen.SetTimeout(1000, function()
                TriggerServerEvent('blackmarket:server:sendMessage', {
                    sender = 'DARK.NET',
                    message = string.format('🎁 Odměna připsána: %.2f DC, 📈 %d XP', reward.cryptoAmount, reward.xpAmount),
                    anon = true
                })
            end)
        end)
        
        
        
        -- Send event to server to give rewards - just once
        TriggerServerEvent('blackmarket:completeHacking', data.hackType, reward.cryptoAmount, reward.xpAmount)
        
        -- Hide UI after successful hack
        SendNUIMessage({
            action = 'hideUI'
        })
    else
        -- Only show notification once
        ESX.ShowNotification('Hack selhal!')
        
        -- Force hide the UI when hack fails - send single hide command
        SendNUIMessage({
            action = 'hideUI'
        })
    end
    
    -- Reset processing flag after a delay
    Citizen.SetTimeout(1000, function()
        isProcessingHackResult = false
        -- Reset the reward flag after 3 seconds to allow future hacks
        Citizen.SetTimeout(3000, function()
            hasReceivedReward = false
        end)
    end)
    
    cb({})
end)

-- Register event to start hacking
RegisterNetEvent('blackmarket:startHacking')
AddEventHandler('blackmarket:startHacking', function(hackId)
    -- Reset reward flag whenever a new hack starts
    hasReceivedReward = false
    
    if hackId == 'bank' or hackId == 'traffic' or hackId == 'corporate' then
        local currentTime = GetGameTimer()
        if hackingCooldowns[hackId] and currentTime < hackingCooldowns[hackId] then
            local remainingTime = math.ceil((hackingCooldowns[hackId] - currentTime) / 60000)
            ESX.ShowNotification('Tento cíl je na cooldownu. Zbývá: ' .. remainingTime .. ' minut.')
            return
        end
        
        -- Set cooldown
        local cooldownMinutes = {
            bank = 30,
            traffic = 20,
            corporate = 25
        }
        hackingCooldowns[hackId] = currentTime + (cooldownMinutes[hackId] * 60 * 1000)
        
        -- Get random location name for this hack type from hackingLocations.ts
        local locationName = exports["lovable-dev"]:getRandomLocation(hackId)
        
        -- Show hacking minigame with location
        SendNUIMessage({
            type = 'showHackingGame',
            hackType = hackId,
            difficulty = hackId == 'bank' and 'hard' or 'medium',
            location = locationName
        })
        SetNuiFocus(true, true)
    else
        ESX.ShowNotification('Neznámý cíl hackování.')
    end
end)

-- Handle app installation
RegisterNUICallback('installApp', function(data, cb)
    if data.appId then
        -- Store installed apps
        if not installedApps then installedApps = {} end
        table.insert(installedApps, data.appId)
        
        -- Send the updated list back to the NUI
        SendNUIMessage({
            type = 'setInstalledApps',
            apps = installedApps
        })
        
        ESX.ShowNotification('Aplikace ' .. data.appId .. ' byla nainstalována.')
    end
    
    cb({})
end)

-- Handle app uninstallation
RegisterNUICallback('uninstallApp', function(data, cb)
    if data.appId then
        -- Remove from installed apps
        if not installedApps then installedApps = {} end
        
        -- Find and remove the app
        for i = #installedApps, 1, -1 do
            if installedApps[i] == data.appId then
                table.remove(installedApps, i)
                break
            end
        end
        
        -- Send the updated list back to the NUI
        SendNUIMessage({
            type = 'setInstalledApps',
            apps = installedApps
        })
        
        ESX.ShowNotification('Aplikace ' .. data.appId .. ' byla odinstalována.')
    end
    
    cb({})
end)

-- Handle app purchases
RegisterNUICallback('purchaseApp', function(data, cb)
    if data.appId and data.price then
        -- Check if player has enough money
        TriggerServerEvent('blackmarket:purchaseApp', data.appId, data.price)
    end
    
    cb({})
end)

-- Handle terminal commands
RegisterNUICallback('terminalCommand', function(data, cb)
    if data.command then
        local args = {}
        for arg in string.gmatch(data.command, "%S+") do
            table.insert(args, arg)
        end

        if args[1] == "hack" and args[2] then
            TriggerEvent('blackmarket:startHacking', args[2])

        elseif args[1] == "install" and args[2] then
            -- Handle app installation
            local appId = args[2]
            local version = args[3] or "1.0"

            -- Simulate installation
            if not installedApps then installedApps = {} end
            table.insert(installedApps, appId)

            -- Send the updated list back to the NUI
            SendNUIMessage({
                type = 'setInstalledApps',
                apps = installedApps
            })

            -- Send terminal response
            SendNUIMessage({
                type = 'terminalResponse', 
                message = 'Aplikace ' .. appId .. ' (v' .. version .. ') byla úspěšně nainstalována.'
            })

        else
            -- Process other commands if needed
            SendNUIMessage({
                type = 'terminalResponse', 
                message = 'Příkaz zpracován: ' .. data.command
            })
        end
    end

    cb({})
end)


-- Add our NUI event handlers for verification and other callbacks
RegisterNUICallback('verifyPassword', function(data, cb)
    -- Simple password check for the blackmarket PC
    -- In real implementation, you'd verify this against stored credentials
    if data.password == Config.BlackmarketPCs[1].password then
        -- Password correct, show desktop
        SendNUIMessage({
            type = 'passwordResponse',
            success = true
        })
        SendNUIMessage({
            action = 'showDesktop'
        })
    else
        -- Password incorrect
        SendNUIMessage({
            type = 'passwordResponse',
            success = false,
            message = 'Nesprávné heslo'
        })
    end
    cb({})
end)

-- Close the NUI interface
RegisterNUICallback('closePC', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- Initialize UI when resource starts
Citizen.CreateThread(function()
    -- Wait a bit to ensure everything is loaded
    Citizen.Wait(1000)
    
    -- Set initial money value (should be fetched from server in real implementation)
    local playerMoney = 0.0250 -- Example initial amount
    
    -- Update UI with money value
    SendNUIMessage({
        type = 'setMoney',
        amount = playerMoney
    })
    
    -- Set exchange rate
    SendNUIMessage({
        type = 'setExchangeRate',
        rate = 0.00008 + math.random() * 0.00004
    })
    
    -- Add export for getRandomLocation function to be used in the LUA environment
    exports('getRandomLocation', function(hackType)
        -- This is a simplified version; in reality, we would use the hackingLocations.ts data through NUI
        local locations = {
            bank = {
                "Fleeca Bank, Vinewood Boulevard",
                "Pacific Standard, Downtown",
                "Maze Bank Tower, Alta",
                "Blaine County Savings, Sandy Shores",
                "Union Depository, Pillbox Hill",
                "Lombank West, Del Perro",
                "Fleeca Bank, Great Ocean Highway",
                "Fleeca Bank, Hawick Avenue",
                "Fleeca Bank, Burton",
                "Maze Bank West, Del Perro"
            },
            traffic = {
                "Dopravní systém, Davis Avenue",
                "Centrální dopravní řídicí systém, Downtown",
                "Systém městských kamer, Vinewood",
                "Železniční signalizace, Mirror Park",
                "Letištní navigační systém, LSIA",
                "Dopravní kamery, Olympic Freeway",
                "Metro signalizace, Pillbox Hill",
                "Přístavní logistika, Terminal",
                "Systém parkovacích automatů, Rockford Hills",
                "Dálniční monitorovací systém, Route 68"
            },
            corporate = {
                "Life Invader HQ, Rockford Hills",
                "Korporátní databáze, Downtown",
                "Maze Bank Arena Datacentrum",
                "FIB Building Server Room",
                "Penris Building Network",
                "Von Crastenburg Hotel System",
                "Richards Majestic Studios",
                "Arcadius Business Center",
                "Lombank Corporate Servers",
                "Weazel News Network"
            }
        }
        
        local hackLocations = locations[hackType]
        if hackLocations then
            return hackLocations[math.random(1, #hackLocations)]
        else
            return "Unknown Location"
        end
    end)
end)

-- Add command to manually close UI and reset focus (for emergency recovery)
RegisterCommand('resethack', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hideUI'
    })
    -- Also reset processing flags in case of stuck states
    isProcessingHackResult = false
    hasReceivedReward = false
    ESX.ShowNotification('UI byl resetován.')
end, false)

-- Add a more aggressive reset command that completely hides the UI
RegisterCommand('forcereset', function()
    SetNuiFocus(false, false)
    
    -- Send multiple hide commands with delays to ensure UI is completely hidden
    SendNUIMessage({
        action = 'hideUI'
    })
    
    -- Double reset to ensure UI is completely hidden
    Citizen.Wait(100)
    SendNUIMessage({
        action = 'hideUI'
    })
    
    -- Triple reset with longer delay as final attempt
    Citizen.Wait(200)
    SendNUIMessage({
        action = 'hideUI'
    })
    
    -- Reset all flags
    isProcessingHackResult = false
    hasReceivedReward = false
    
    ESX.ShowNotification('UI byl kompletně resetován.')
end, false)