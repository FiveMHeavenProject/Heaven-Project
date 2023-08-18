ESX = exports["es_extended"]:getSharedObject()
local VehiclesInImpounds = {}

ESX.RegisterServerCallback('xrp_garage:checkVehicleOwner', function(source, cb, plate, job)
    local xPlayer = ESX.GetPlayerFromId(source)
	if not job then editedquery = '`owner` = @identifier AND `job` IS NULL' else editedquery = '`job` = "'..job..'"' end

	MySQL.query('SELECT COUNT(*) as count FROM `owned_vehicles` WHERE '..editedquery..' AND `plate` = @plate',
	{
		['@identifier'] 	= xPlayer.identifier,
		['@plate']     		= plate
	}, function(result)

		if tonumber(result[1].count) > 0 then
			return cb(true)
		else
			return cb(false)
		end
	end)
end)

RegisterServerEvent('xrp_garage:updateOwnedVehicle')
AddEventHandler('xrp_garage:updateOwnedVehicle', function(stored, parking, data, spawn, heading)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	MySQL.update('UPDATE owned_vehicles SET `stored` = @stored, `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@vehicle'] 	= json.encode(data.vehicleProps),
		['@plate'] 		= data.vehicleProps.plate,
		['@stored']     = stored,
	})

	if stored then
		xPlayer.showNotification("Schowano pojazd")
		--Server Usun klucze do pojazdu
		TriggerEvent('xrp:removekeygarage', source, data.vehicleProps.plate)
	else 
		print(json.encode(data))
		ESX.OneSync.SpawnVehicle(data.vehicleProps.model, spawn, heading, data.vehicleProps, function(vehicle)
			VehiclesInImpounds[data.vehicleProps.plate] = vehicle
			local vehicle = NetworkGetEntityFromNetworkId(vehicle)
			Wait(1)
			TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
			--Server Dodaj klucze do pojazdu
			TriggerEvent('xrp:addkeygarage', source, data.vehicleProps.plate)
		end)
	end
end)

ESX.RegisterServerCallback('xrp_garage:getVehiclesInParking', function(source, cb, job)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if not job then editedquery = '`owner` = @identifier AND `job` IS NULL' else editedquery = '`job` = "'..job..'"' end

    MySQL.query('SELECT * FROM `owned_vehicles` WHERE '..editedquery..' AND `stored` = 1',
	{
		['@identifier'] 	= xPlayer.identifier
	}, function(result)

		local vehicles = {}
		for i = 1, #result, 1 do
			table.insert(vehicles, {
				vehicle 	= json.decode(result[i].vehicle),
				plate 		= result[i].plate
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('xrp_garage:getVehiclesInImpound', function(source, cb, job)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if not job then editedquery = '`owner` = @identifier AND `job` IS NULL' else editedquery = '`job` = "'..job..'"' end

    MySQL.query('SELECT * FROM `owned_vehicles` WHERE '..editedquery..' AND `stored` = 0',
	{
		['@identifier'] 	= xPlayer.identifier
	}, function(result)

		local vehicles = {}
		for i = 1, #result, 1 do
			local entity = NetworkGetEntityFromNetworkId(VehiclesInImpounds[result[i].plate])
			if not DoesEntityExist(entity) then
				table.insert(vehicles, {
					vehicle 	= json.decode(result[i].vehicle),
					plate 		= result[i].plate
				})
			end
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('xrp_garage:hasMoney', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("money").money >= price then
        xPlayer.removeAccountMoney("money", price)
        cb(true)
        return
    end
    cb(false)
end)