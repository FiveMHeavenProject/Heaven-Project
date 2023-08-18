--TriggerEvent('esx_phone:registerNumber', 'police', TranslateCap('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', TranslateCap('society_police'), 'society_police', 'society_police', 'society_police', {type = 'public'})

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	local retrivedInfo = {
		plate = plate
	}
	if Config.EnableESXIdentity then
		MySQL.single('SELECT users.firstname, users.lastname FROM owned_vehicles JOIN users ON owned_vehicles.owner = users.identifier WHERE plate = ?', {plate},
		function(result)
			if result then
				retrivedInfo.owner = ('%s %s'):format(result.firstname, result.lastname)
			end
			cb(retrivedInfo)
		end)
	else
		MySQL.scalar('SELECT owner FROM owned_vehicles WHERE plate = ?', {plate},
		function(owner)
			if owner then
				local xPlayer = ESX.GetPlayerFromIdentifier(owner)
				if xPlayer then
					retrivedInfo.owner = xPlayer.getName()
				end
			end
			cb(retrivedInfo)
		end)
	end
end)
--[[
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)
]]
lib.callback.register('esx_policejob:CreateStash', function(source, StationName, SSN)
	local res = MySQL.scalar.await("SELECT `id` FROM `users` WHERE `id` = ?", {SSN})
	if res ~= nil then
		return exports.ox_inventory:RegisterStash(StationName..SSN, StationName.." Szafka SSN "..SSN, 50, 100000, nil)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.showNotification("BRAK GRACZA O TAKIM SSN", "error", 6000)
	end
end)

lib.callback.register('esx_policejob:CreateFractionStash', function(source, StationName, id)
	return exports.ox_inventory:RegisterStash(StationName..id, "Szafka Frakcyjna "..StationName..id, 150, 100000, nil)
end)

lib.callback.register('esx_policejob:CreateTrashStash', function(source)
	local mystash = exports.ox_inventory:CreateTemporaryStash({
		label = 'PDdump',
		slots = 15,
		maxWeight = 5000,
	})
	return mystash
end)

CreateThread(function()
	for k,v in pairs(Config.AuthorizedWeapons) do
		exports.ox_inventory:RegisterShop('PD'..k, {
			name = 'Zbrojownia',
			inventory = v,
			groups = {
				police = 0
			},
		})
	end
end)

lib.callback.register("esx_policejob:GetVehicles", function(source, category)
	local vehicles = MySQL.query.await("SELECT * FROM `owned_vehicles` WHERE `job` = 'police' AND `category` = ?", {category})

	return vehicles
end)

lib.callback.register("esx_policejob:BuyVehicle", function(source, vehicle, props, price, category)
	local vehiclesize = MySQL.scalar.await("SELECT count(*) FROM owned_vehicles WHERE `job` = 'police'")
	local xPlayer = ESX.GetPlayerFromId(source)

	if vehiclesize < Config.Vehicles.VehicleLimit then
		print(price, xPlayer.getMoney())
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.insert('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`, category) VALUES (?, ?, ?, ?, ?, ?, ?)', { xPlayer.identifier, json.encode(props), props.plate, "car", xPlayer.job.name, true, category},
			function (rowsChanged)
				return true
			end)
			return true
		else
			return false
		end
	else
		return "limit"
	end
end)

RegisterNetEvent("esx_policejob:SetVehicleInAndOutOfGarage", function(plate, store, props)
	if not store then
		MySQL.query("UPDATE `owned_vehicles` SET `stored` = 0 WHERE `plate` LIKE ?", {plate})
	else
		local xPlayer  = ESX.GetPlayerFromId(source)
		local ssn = xPlayer.get('ssn')
		MySQL.update('UPDATE `owned_vehicles` SET `stored` = 1, `vehicle` = ?, `last_driver` = ? WHERE `plate` = ?', {json.encode(props), ssn, plate})
		xPlayer.showNotification("Pojazd został schowany")
	end
end)

lib.callback.register('esx_policejob:GetEmployees', function(source, job)
	local res = MySQL.query.await('SELECT identifier, firstname, lastname FROM users WHERE `job` = ?', {job})
	return res
end)

lib.callback.register('esx_policejob:GetEmployeeBadges', function(source, identifier)
	local res = MySQL.scalar.await('SELECT badges FROM users WHERE identifier = ?', {identifier})
	return res
end)

lib.callback.register('esx_policejob:GetEmployeeLicenses', function(source, identifier)
	local res = MySQL.query.await('SELECT id, type FROM user_licenses WHERE owner = ?', {identifier})
	return res
end)

lib.callback.register('esx_policejob:RemoveEmployeeLicense', function(source, identifier, id, type)
	local res = MySQL.query.await('DELETE FROM user_licenses WHERE id = ?', {id})
	return true
end)

lib.callback.register("esx_policejob:GetImpoundVehicles", function(source, category)
	local vehicles = MySQL.query.await("SELECT * FROM `owned_vehicles` WHERE `job` = 'police' AND `stored` = 0")

	return vehicles
end)

RegisterNetEvent("esx_policejob:ImpoundVehicle", function(plate)
	MySQL.query("UPDATE `owned_vehicles` SET `stored` = 1 WHERE `plate` LIKE ?", {plate})
end)