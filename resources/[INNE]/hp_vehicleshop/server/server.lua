local vehicles = {}

MySQL.ready(function()
	vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')
end)

RegisterServerEvent('nt_vehicleshop:requestInfo')
AddEventHandler('nt_vehicleshop:requestInfo', function()
    local _source = source
    TriggerClientEvent("nt_vehicleshop:vehiclesInfos", _source , vehicles)
    TriggerClientEvent("esx:showNotification", _source, 'Użyj A oraz D aby obwrócić pojazd')
end)

ESX.RegisterServerCallback('nt_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

RegisterServerEvent('nt_vehicleshop:CheckMoneyForVeh')
AddEventHandler('nt_vehicleshop:CheckMoneyForVeh', function(vehicle, paymenttype, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil then
        local vehicleModel = vehicle
        local vehiclePrice = MySQL.scalar.await("SELECT `price` FROM vehicles WHERE model = ?", {vehicleModel})
        local payment = "cash" and "money" or "bank"
        if xPlayer.getAccount(payment).money >= vehiclePrice then
            xPlayer.removeAccountMoney(payment, vehiclePrice)
            -- exports['wait_logs']:SendLog(_source, 'VEHICLESHOP: `'..GetPlayerName(xPlayer.source)..'` ZAKUPIŁ POJAZD `'..vehicleModel..'` za `'..tonumber(vehiclePrice)..'`', 'nowe-napadyinne')
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps),
                ['@type'] = 'car'
            }, function(rowsChanged)
                TriggerClientEvent('nt_vehicleshop:spawnVehicle', _source, vehicleModel, vehicleProps.plate)
                TriggerClientEvent("nt_vehicleshop:sussessbuy", _source, vehicleModel, vehicleProps.plate, vehiclePrice)
                --exports['loaf_keysystem']:GenerateKey(_source, 'car_'..vehicleProps.plate, 'Klucze do auta: '.. vehicleProps.plate, 'client', 'nt_carkeys:useKey')
            end)
        else
            TriggerClientEvent("esx:showNotification", _source, 'Nie posiadasz wystarczająco pieniędzy! ('..vehiclePrice..')')
        end
    end
end)


AddEventHandler('playerDropped', function()
	TriggerClientEvent('nt_vehicleshop:checkRentCar', source)
end)