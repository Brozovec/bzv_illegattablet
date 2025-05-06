
local playerName = nil

-- Function to get cached player name
local function GetCachedPlayerName()
    if not playerName then
        playerName = GetPlayerName(PlayerId())
    end
    return playerName
end

-- Event handler for when player loads
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    playerName = GetPlayerName(PlayerId())
    print('Player name cached:', playerName)
end)

-- Expose get name function to NUI
RegisterNUICallback('getPlayerName', function(_, cb)
    local name = GetCachedPlayerName()
    cb({
        name = name or 'Administrátor'
    })
end)

-- Export function for other resources
exports('getPlayerName', function()
    return GetCachedPlayerName()
end)
