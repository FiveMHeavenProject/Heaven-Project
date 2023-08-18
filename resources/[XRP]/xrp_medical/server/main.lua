ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory

RegisterServerEvent('xrp_ambulancejob:rev')
AddEventHandler('xrp_ambulancejob:rev', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ambulance' then 
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
			account.addMoney(100)
			xPlayer.addMoney(250)
		end)
		TriggerClientEvent('xrp_ambulancejob:rev', target)
	else
		DropPlayer(_source, '?')
	end
end)

RegisterServerEvent('xrp_ambulancejob:healPlayerHandler')
AddEventHandler('xrp_ambulancejob:healPlayerHandler', function(serverId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('xrp_ambulancejob:heal', serverId)
	end
end)


TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	exports.ox_inventory:ClearInventory(xPlayer.source)

	cb()
end)

RegisterCommand('revive', function(source, args, user)
	if source == 0 then
		TriggerClientEvent('xrp_ambulancejob:rev', tonumber(args[1]), true)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport' or xPlayer.group == 'owner') then
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					TriggerClientEvent('xrp_ambulancejob:rev', tonumber(args[1]), true)
				end
			else
				TriggerClientEvent('xrp_ambulancejob:rev', source, true)
			end
		end
	end
end, false)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.scalar('SELECT is_dead FROM users WHERE identifier = ?', {xPlayer.identifier}, function(isDead)
		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.Sync.execute("UPDATE users SET is_dead=? WHERE identifier=?", { isDead, xPlayer.identifier  })
	end
end)