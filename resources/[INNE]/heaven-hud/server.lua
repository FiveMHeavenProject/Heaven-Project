ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("heavenrp:GetSSN", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.scalar('SELECT id FROM users WHERE identifier = ?', {xPlayer.identifier}, function(res)
        cb(res)
    end)
end)

AddEventHandler('ox_inventory:openedInventory', function(playerId, inventoryId) 
    TriggerClientEvent("heaven-hud:InventoryOpenAndCar", playerId)
end)

RegisterNetEvent('ox_inventory:closeInventory')
AddEventHandler('ox_inventory:closeInventory', function() 
    TriggerClientEvent("hp_minimap:InventoryCloseAndCar", source)
end)
