----[[ SERVER SCRIPT ]]----

-- Funkce pro odeslání zprávy přes LB Phone
local function SendJobMessage(source, message, coords)
    -- Získání telefonního čísla
    local playerPhone = exports['lb-phone']:GetEquippedPhoneNumber(source)
    if not playerPhone then 
        print("^1CHYBA: Hráč nemá telefon^7")
        return 
    end
    
    -- Odeslání zprávy
    -- from, to, message, attachments, cb, channelId
    exports["lb-phone"]:SendMessage("Underground", playerPhone, message)
    
    -- Pokud jsou k dispozici souřadnice, pošleme i je
    if coords then
        Wait(500) -- Malé zpoždění pro zajištění pořadí zpráv
        exports["lb-phone"]:SendMessage("Underground", playerPhone, "📍 GPS byla přidána do tvého telefonu.")
        
        -- Odeslání souřadnic
        -- Předpokládám, že pro souřadnice existuje stejný formát jako pro zprávy
        exports["lb-phone"]:SendCoords("Underground", playerPhone, vec2(coords.x, coords.y))
    end
end

-- Registrace události pro odesílání zpráv
RegisterNetEvent('blackmarket:server:sendMessage')
AddEventHandler('blackmarket:server:sendMessage', function(data)
    if not data or not data.message then return end
    SendJobMessage(source, data.message, data.coords)
end)

-- cd_dispatch volání policie
RegisterNetEvent('dispatch:server:notifyPolice')
AddEventHandler('dispatch:server:notifyPolice', function(data)
    local coords = data.coords
    local info = data.info
    TriggerClientEvent("cd_dispatch:AddNotification", -1, {
        job = {"police", "sheriff"},
        coords = vector3(coords.x, coords.y, coords.z),
        title = "Podezřelá Aktivita",
        message = info,
        flash = true,
        uniqueID = tostring(math.random(1, 999999)),
        blip = {
            colour = 1,
            scale = 1.5,
            sprite = 161
        }
    })
end)

-- Oznámení na dokončené nebo selhané úkoly
RegisterNetEvent('bzv_bm:job:jobDone')
AddEventHandler('bzv_bm:job:jobDone', function()
    print('Hráč dokončil úkol.')
end)

RegisterNetEvent('bzv_bm:job:jobFailed')
AddEventHandler('bzv_bm:job:jobFailed', function()
    print('Hráč selhal v úkolu.')
end)
