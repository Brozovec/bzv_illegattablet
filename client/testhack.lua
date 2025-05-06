local ESX = exports['es_extended']:getSharedObject()

RegisterCommand('testhack', function(source, args)
    if not args[1] then
        TriggerEvent('esx:showNotification', 'Použití: /testhack [bank/traffic/corporate]')
        return
    end

    local validHacks = {
        ['bank'] = true,
        ['traffic'] = true,
        ['corporate'] = true
    }

    local hackType = args[1]:lower()
    
    if not validHacks[hackType] then
        TriggerEvent('esx:showNotification', 'Neplatný typ hacku. Použij: bank, traffic, nebo corporate')
        return
    end

    -- Check for restricted job before allowing hack test
    if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name then
        local restrictedJobs = {
            ['police'] = true,
            ['sheriff'] = true,
            ['fbi'] = true
        }
        
        if restrictedJobs[ESX.GetPlayerData().job.name] then
            TriggerEvent('esx:showNotification', 'Nemůžete testovat hacky jako příslušník bezpečnostních složek.')
            return
        end
    end

    -- Show the hacking minigame UI
    SendNUIMessage({
        type = 'showHackingGame',
        hackType = hackType,
        difficulty = hackType == 'bank' and 'hard' or 'medium'
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand('hackhelp', function()
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message"><b>Dostupné hacky:</b><br>' ..
                  '- /testhack bank (Těžký hack)<br>' ..
                  '- /testhack traffic (Středně těžký hack)<br>' ..
                  '- /testhack corporate (Středně těžký hack)</div>',
        args = {}
    })
end, false)

-- Register suggestion for the command
TriggerEvent('chat:addSuggestion', '/testhack', 'Otestuj hack', {
    { name = "typ", help = "bank/traffic/corporate" }
})

TriggerEvent('chat:addSuggestion', '/hackhelp', 'Zobrazí nápovědu k hackům')
