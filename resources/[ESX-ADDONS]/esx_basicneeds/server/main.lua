CreateThread(function()
	for k,v in pairs(Config.Items) do
		ESX.RegisterUsableItem(k, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			if v.remove then
				xPlayer.removeInventoryItem(k,1)
			end
			if v.type == "food" then
				TriggerClientEvent("esx_status:add", source, "hunger", v.status)
				TriggerClientEvent('esx_basicneeds:onUse', source, v.type)
				xPlayer.showNotification(TranslateCap('used_food', ESX.GetItemLabel(k)))
			elseif v.type == "drink" then
				TriggerClientEvent("esx_status:add", source, "thirst", v.status)
				TriggerClientEvent('esx_basicneeds:onUse', source, v.type)
				xPlayer.showNotification(TranslateCap('used_drink', ESX.GetItemLabel(k)))
			else
				print(string.format('^1[ERROR]^0 %s has no correct type defined.', k))
			end
		end)
	end 
end)

ESX.RegisterCommand('heal', 'admin', function(xPlayer, args, showError)
	local xTarget = args.playerId
	xTarget.triggerEvent('esx_basicneeds:healPlayer')
	xTarget.triggerEvent("HEAL","Zostałeś uleczony przez administratora: "..GetPlayerName(source), 7000, 'success')
	if xPlayer then
		TriggerEvent('hp-logs:sendLog', xPlayer.source, '[ESX HEAL]','\n**Administrator: **'..GetPlayerName(xPlayer.source)..' uleczył gracza **'..GetPlayerName(xTarget.source)..'**', 'esx_heal')
	end
end, true, {help = 'Ulecz gracza', validate = true, arguments = {
	{name = 'playerId', help = 'ID Gracza', type = 'player'}
}})

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end

	TriggerClientEvent('esx_basicneeds:healPlayer', eventData.id)
end)
