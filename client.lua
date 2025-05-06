Config = {
    BlackmarketPCs = {
        [1] = {
            model = `prop_laptop_01a`,
            coords = vector4(154.5314, -1007.3723, -98.4334, 213.2524),
            animation = {
                dict = "anim@heists@prison_heiststation@cop_reactions",
                clip = "cop_b_idle",
                flag = 49
            }
        }
    },
    TargetLabel = "Počítač",
    TargetIcon = "fas fa-desktop",
    RestrictedJobs = {
        ["police"] = true,
        ["sheriff"] = true,
        ["ambulance"] = true,
        ["sahp"] = true,

    },
    HackingCooldowns = {
        ["bank"] = 30,
        ["traffic"] = 20,
        ["corporate"] = 25
    }
    
}

local function hasRestrictedJob()
    local playerData = nil
    
    -- ESX framework compatibility
    if ESX and ESX.GetPlayerData then
        playerData = ESX.GetPlayerData()
        if playerData and playerData.job and Config.RestrictedJobs[playerData.job.name] then
            return true
        end
    end
    
    return false
end


local currentPC = nil
local isLoggedIn = false
local hackingCooldowns = {}

CreateThread(function()
    for i, pc in ipairs(Config.BlackmarketPCs) do
        local obj = CreateObject(pc.model, pc.coords.x, pc.coords.y, pc.coords.z - 0.9, false, false, false)
        SetEntityHeading(obj, pc.coords.w)
        FreezeEntityPosition(obj, true)

        if exports.ox_target then
            exports.ox_target:addLocalEntity(obj, {
                {
                    name = 'blackmarket_pc_'..i,
                    label = Config.TargetLabel or "Počítač",
                    icon = Config.TargetIcon or "fas fa-desktop",
                    distance = 1.5,
                    onSelect = function()
                        currentPC = i
                        TriggerEvent('blackmarket:usePC', i)
                    end
                }
            })
        elseif exports.qtarget then
            exports.qtarget:AddTargetEntity(obj, {
                options = {
                    {
                        icon = Config.TargetIcon or "fas fa-desktop",
                        label = Config.TargetLabel or "Počítač", 
                        action = function()
                            currentPC = i
                            TriggerEvent('blackmarket:usePC', i)
                        end
                    }
                },
                distance = 1.5
            })
        end
    end
end)

local function SpawnPCAndSetupTarget()
    for i, pc in ipairs(Config.BlackmarketPCs) do
        -- Vymaže existující prop pokud existuje
        local existingProps = GetGamePool('CObject')
        for _, prop in ipairs(existingProps) do
            if GetEntityModel(prop) == pc.model and #(GetEntityCoords(prop) - vector3(pc.coords.x, pc.coords.y, pc.coords.z)) < 1.0 then
                DeleteEntity(prop)
            end
        end

        -- Vytvoří nový prop
        local obj = CreateObject(pc.model, pc.coords.x, pc.coords.y, pc.coords.z - 0.9, false, false, false)
        SetEntityHeading(obj, pc.coords.w)
        FreezeEntityPosition(obj, true)

        -- Nastaví target
        if exports.ox_target then
            exports.ox_target:addLocalEntity(obj, {
                {
                    name = 'blackmarket_pc_'..i,
                    label = Config.TargetLabel or "Počítač",
                    icon = Config.TargetIcon or "fas fa-desktop",
                    distance = 1.5,
                    onSelect = function()
                        currentPC = i
                        TriggerEvent('blackmarket:usePC', i)
                    end
                }
            })
        elseif exports.qtarget then
            exports.qtarget:AddTargetEntity(obj, {
                options = {
                    {
                        icon = Config.TargetIcon or "fas fa-desktop",
                        label = Config.TargetLabel or "Počítač", 
                        action = function()
                            currentPC = i
                            TriggerEvent('blackmarket:usePC', i)
                        end
                    }
                },
                distance = 1.5
            })
        end
    end
end

SetNuiFocus(false, false)
SendNUIMessage({ action = 'hideUI' })
isLoggedIn = false

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('Resource started: ' .. resourceName)
    SpawnPCAndSetupTarget()
    SendNUIMessage({ action = 'hideUI' })
    SetNuiFocus(false, false)
    isLoggedIn = false
end)

RegisterNetEvent('blackmarket:usePC')
AddEventHandler('blackmarket:usePC', function(pcIndex)
    if hasRestrictedJob() then
        TriggerEvent('esx:showNotification', 'Nemůžete přistupovat k podsvětí jako příslušník bezpečnostních složek.')
        return
    end

    local pc = Config.BlackmarketPCs[pcIndex]
    
    if pc.animation then
        RequestAnimDict(pc.animation.dict)
        while not HasAnimDictLoaded(pc.animation.dict) do Wait(10) end
        TaskPlayAnim(PlayerPedId(), pc.animation.dict, pc.animation.clip, 8.0, -8.0, -1, pc.animation.flag, 0, false, false, false)
    end

    isLoggedIn = false
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'showLogin' })
    print("Showing login screen")
end)
RegisterNUICallback('closePC', function(_, cb)
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    SendNUIMessage({ action = 'hideUI' })
    isLoggedIn = false
    print("Closing PC interface")
    cb({})
end)

RegisterNUICallback('verifyPassword', function(data, cb)
    print("Verifying password: " .. (data.password or "no password"))
    TriggerServerEvent('blackmarket:verifyPassword', data.password)
    cb({success = true})
end)

RegisterNetEvent('blackmarket:passwordIncorrect')
AddEventHandler('blackmarket:passwordIncorrect', function()
    SendNUIMessage({ 
        type = 'passwordResponse',
        success = false,
        message = 'Špatné heslo nebo nemáte přístup!'
    })
    print("Password incorrect")
end)

RegisterNetEvent('blackmarket:openUI')
AddEventHandler('blackmarket:openUI', function()
    isLoggedIn = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'showDesktop' })
    print("Showing desktop")
end)

RegisterNUICallback('terminalCommand', function(data, cb)
    if isLoggedIn then
        if string.find(data.command, "hack ") == 1 then
            local target = string.sub(data.command, 6)
            TriggerEvent('blackmarket:startHacking', target)
        else
            TriggerServerEvent('blackmarket:terminalCommand', data.command)
        end
    else
        SendNUIMessage({
            type = 'terminalResponse',
            message = 'Nejste přihlášeni!'
        })
    end
    cb({})
end)

RegisterNUICallback('purchaseApp', function(data, cb)
    if isLoggedIn then
        TriggerServerEvent('blackmarket:purchaseApp', data.appId, data.price)
        cb({success = true})
    else
        cb({success = false, message = 'Nejste přihlášeni!'})
    end
end)

RegisterNUICallback('convertMoney', function(data, cb)
    if isLoggedIn then
        TriggerServerEvent('blackmarket:convertMoney', data.amount)
        cb({success = true})
    else
        cb({success = false, message = 'Nejste přihlášeni!'})
    end
end)

RegisterNetEvent('blackmarket:updateMoney')
AddEventHandler('blackmarket:updateMoney', function(amount)
    SendNUIMessage({ 
        type = 'setMoney',
        amount = amount
    })
end)

RegisterNetEvent('blackmarket:updatePurchases')
AddEventHandler('blackmarket:updatePurchases', function(purchasedApps)
    SendNUIMessage({ 
        type = 'setPurchasedApps',
        apps = purchasedApps
    })
end)

RegisterNetEvent('blackmarket:setExchangeRate')
AddEventHandler('blackmarket:setExchangeRate', function(rate)
    SendNUIMessage({ 
        type = 'setExchangeRate',
        rate = rate
    })
end)

RegisterNetEvent('blackmarket:terminalResponse')
AddEventHandler('blackmarket:terminalResponse', function(message)
    SendNUIMessage({
        type = 'terminalResponse',
        message = message
    })
end)

RegisterNUICallback('showJobDialog', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideUI' })
    TriggerEvent('blackmarket:showJobMenu')
    cb({})
end)

RegisterNetEvent('blackmarket:showJobMenu', function()
    lib.notify({
        title = 'Blackmarket',
        description = 'Za chvíli tě budeme kontaktovat ohledně tvé práce.',
        type = 'info',
        duration = 5000 -- 5 sekund 
    })

        Wait(5 * 60 * 1000) -- 10 sekund         Wait(5 * 60 * 1000) -- 5 minut
        TriggerEvent('bzv_bm:job:clientStartJob') -- Spuštění náhodného úkolu
        --print('start jobu more')
    end)


RegisterNUICallback('startJob', function(data, cb)
    if not data.jobId then return end
    
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideUI' })
    
    TriggerEvent('blackmarket:startJob', data.jobId)
    
    cb({})
end)

RegisterNetEvent('blackmarket:startJob')
AddEventHandler('blackmarket:startJob', function(jobId)
    if jobId == 'courier' then
        TriggerEvent('esx:showNotification', 'Budete kontaktováni za 5 minut pro kurýrní práci.')
        
        SetTimeout(5 * 60 * 1000, function()
            TriggerEvent('phone:receiveSMS', {
                sender = 'Underground',
                message = 'Máme pro tebe práci. Doruč balíček na označené místo.'
            })
            
            TriggerEvent('courier:startDelivery')
        end)
    elseif jobId == 'warehouse' then
        TriggerEvent('esx:showNotification', 'Budete kontaktováni za 5 minut pro skladnickou práci.')
        SetTimeout(5 * 60 * 1000, function()
            TriggerEvent('phone:receiveSMS', {
                sender = 'Underground',
                message = 'Potřebujeme pomoc ve skladu. Přijď na označené místo.'
            })
            TriggerEvent('warehouse:startWork')
        end)
    elseif jobId == 'bartender' then
        TriggerEvent('esx:showNotification', 'Budete kontaktováni za 5 minut pro barmanskou práci.')
        SetTimeout(5 * 60 * 1000, function()
            TriggerEvent('phone:receiveSMS', {
                sender = 'Underground',
                message = 'Bar potřebuje barmana. Přijď na označené místo.'
            })
            TriggerEvent('bartender:startShift')
        end)
    end
end)

RegisterNUICallback('startHackingGame', function(data, cb)
    local hackType = data.hackId or 'default'
    local difficulty = data.difficulty or 'medium'

    SendNUIMessage({
        type = 'showHackingGame',
        hackType = hackType,
        difficulty = difficulty
    })

    cb({ success = true })
end)


RegisterNUICallback('closeHackingGame', function(data, cb)
    if data.success then
        TriggerServerEvent('blackmarket:completeHacking', data.hackType)
        TriggerEvent('esx:showNotification', 'Hack úspěšný! Odměna byla připsána.')
    else
        TriggerEvent('esx:showNotification', 'Hack selhal!')
    end
    
    cb({})
end)

RegisterNetEvent('blackmarket:startHackingGame')
AddEventHandler('blackmarket:startHackingGame', function(hackId)
    local cooldownTime = 0
    if hackingCooldowns[hackId] then
        local currentTime = GetGameTimer()
        local remainingTime = math.ceil((hackingCooldowns[hackId] - currentTime) / 60000)
        
        if remainingTime > 0 then
            TriggerEvent('esx:showNotification', 'Tento cíl je na cooldownu. Zbývá: ' .. remainingTime .. ' minut.')
            return
        end
    end
    
    local cooldownMinutes = Config.HackingCooldowns[hackId] or 30
    hackingCooldowns[hackId] = GetGameTimer() + (cooldownMinutes * 60 * 1000)
    
    SendNUIMessage({
        type = 'showHackingGame',
        hackType = hackId,
        difficulty = hackId == 'bank' and 'hard' or 'medium'
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('blackmarket:startHacking')
AddEventHandler('blackmarket:startHacking', function(hackId)
    if hackId == 'bank' or hackId == 'traffic' or hackId == 'corporate' then
        TriggerEvent('blackmarket:startHackingGame', hackId)
    else
        TriggerEvent('esx:showNotification', 'Neznámý cíl hackování.')
    end
end)

RegisterNUICallback('purchaseItem', function(data, cb)
    if not data.itemId or not data.price then 
        cb({success = false, message = "Neplatný požadavek"})
        return 
    end
    
    TriggerServerEvent('blackmarket:purchaseItems', data.itemId, data.price)
    
    cb({success = true})
end) 

RegisterNetEvent('blackmarket:purchaseResult')
AddEventHandler('blackmarket:purchaseResult', function(success, message)
    TriggerEvent('esx:showNotification', message)
    
    if isLoggedIn then
        TriggerServerEvent('blackmarket:refreshMoney')
    end
end)

RegisterNUICallback('getExchangeRate', function(data, cb)
    TriggerServerEvent('blackmarket:getExchangeRate')
    cb({})
end)






-- Spustí spawn PC při startu scriptu
CreateThread(function()
    SpawnPCAndSetupTarget()
end)


-- Spustí spawn PC když hráč joinne
AddEventHandler('playerSpawned', function()
    SpawnPCAndSetupTarget()
end)

-- Reset NUI při startu
SetNuiFocus(false, false)
SendNUIMessage({ action = 'hideUI' })
isLoggedIn = false
