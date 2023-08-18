ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	local xTarget = args.playerId
	if ESX.DoesJobExist(args.job, args.grade) then
		local oldJob = string.upper(xTarget.job.label)
		local oldGrade = string.upper(xTarget.job.grade)
		local oldGradeName = string.upper(xTarget.job.grade_label)
		TriggerEvent('hp-logs:sendLog', xPlayer.source, '[NADAŁ JOBA]', "\n**Admin: **"..GetPlayerName(xPlayer.source)..'\n**Nadał joba: **'..GetPlayerName(xTarget.source).."\n**Nazwa joba: **"..args.job..'\n**Grade: **'..args.grade..'\n**Poprzednia praca: **'..oldJob..'\n**Stopień: **'..oldGrade..' | '..oldGradeName..'\n**Powód zmiany joba: ** Nie podano', 'esx_setjob')
		xTarget.setJob(args.job, args.grade)
	else
		showError(TranslateCap('command_setjob_invalid'))
	end
end, false, {help = TranslateCap('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = TranslateCap('command_setjob_job'), type = 'string'},
	{name = 'grade', help = TranslateCap('command_setjob_grade'), type = 'number'},
	--{name = 'powod', help = "Powód", type = 'string'}
}})
 
local upgrades = Config.SpawnVehMaxUpgrades and
    {
        plate = "SPWNED",
        modEngine = 3,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 3,
        modArmor = true,
        windowTint = 1
    } or {}

ESX.RegisterCommand('car', 'admin', function(xPlayer, args, showError)
	if not xPlayer then
		return print('[^1ERROR^7] The xPlayer value is nil')
	end
	
	local playerPed = GetPlayerPed(xPlayer.source)
	local playerCoords = GetEntityCoords(playerPed)
	local playerHeading = GetEntityHeading(playerPed)
	local playerVehicle = GetVehiclePedIsIn(playerPed)

	if not args.car or type(args.car) ~= 'string' then
		args.car = 'adder'
	end

	if playerVehicle then
		DeleteEntity(playerVehicle)
	end
	ESX.OneSync.SpawnVehicle(args.car, playerCoords, playerHeading, upgrades, function(networkId)
		if networkId then
			local vehicle = NetworkGetEntityFromNetworkId(networkId)
			for i = 1, 20 do
				Wait(0)
				SetPedIntoVehicle(playerPed, vehicle, -1)
		
				if GetVehiclePedIsIn(playerPed, false) == vehicle then
					TriggerEvent('hp-logs:sendLog', xPlayer.source, '[ZRESPIŁ POJAZD]','**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Zrespił pojazd: **'..args.car..'\n**Na kordach: **'..playerCoords, 'esx_car')
					break
				end
			end
			if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
				print('[^1ERROR^7] The player could not be seated in the vehicle')
			end
		end
	end)
end, false, {help = TranslateCap('command_car'), validate = false, arguments = {
	{name = 'car',validate = false, help = TranslateCap('command_car_car'), type = 'string'}
}}) 

ESX.RegisterCommand({'cardel', 'dv'}, 'admin', function(xPlayer, args, showError)
	local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
	if DoesEntityExist(PedVehicle) then
		DeleteEntity(PedVehicle)
	end
	local Vehicles = ESX.OneSync.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(xPlayer.source)), tonumber(args.radius) or 5.0)
	for i=1, #Vehicles do 
		local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
		if DoesEntityExist(Vehicle) then
			DeleteEntity(Vehicle)
		end
	end
end, false, {help = TranslateCap('command_cardel'), validate = false, arguments = {
	{name = 'radius',validate = false, help = TranslateCap('command_cardel_radius'), type = 'number'}
}})

ESX.RegisterCommand('setaccountmoney', 'admin', function(xPlayer, args, showError)
	local xTarget = args.playerId
	local moneyBefore = xPlayer.getAccount(args.account).money

	if xTarget.getAccount(args.account) then
		TriggerEvent('hp-logs:sendLog', xPlayer.source, '[SETACCOUNTMONEY]','\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Ustawił stan konta graczowi: **'..GetPlayerName(xTarget.source)..'\n**Typ konta: **'..args.account..'\n**Stan przed ustawieniem: **'..moneyBefore..'$\n**Stan po ustawieniu: **'..args.amount..'$\n**Powód dodania: **Nie podano', 'esx_setaccountmoney')
		xTarget.setAccountMoney(args.account, args.amount, "Government Grant")
	else
		showError(TranslateCap('command_giveaccountmoney_invalid'))
	end
end, false, {help = TranslateCap('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = TranslateCap('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = TranslateCap('command_setaccountmoney_amount'), type = 'number'},
	--{name = 'powod', help = "Powód", type = 'string'}
}})

ESX.RegisterCommand('giveaccountmoney', 'admin', function(xPlayer, args, showError)
	local xTarget = args.playerId
	if xTarget.getAccount(args.account) then

		local moneyBefore = xTarget.getAccount(args.account).money
		xTarget.addAccountMoney(args.account, args.amount, "Government Grant")

		local moneyAfter = xTarget.getAccount(args.account).money
		TriggerEvent('hp-logs:sendLog', xPlayer.source, '[GIVEACCOUNTMONEY]','**Admin: **'..GetPlayerName(source)..'\n**Ustawił stan konta gracza: **'..GetPlayerName(xTarget.source)..'\n**Stan konta przed: **'..moneyBefore..'$\n**Stan konta po dodaniu: **'..moneyAfter..'$\n**Powód dodania: **Nie podano', 'esx_giveaccountmoney')
	else
		showError(TranslateCap('command_giveaccountmoney_invalid'))
	end
end, false, {help = TranslateCap('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = TranslateCap('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = TranslateCap('command_giveaccountmoney_amount'), type = 'number'},
	--{name = 'powod', help = "Powód", type = 'string'}
}})

ESX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = TranslateCap('command_clear')})

ESX.RegisterCommand({'clearall', 'clsall'}, {'support', 'mod', 'admin'}, function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
	TriggerEvent('hp-logs:sendLog', xPlayer.source, '[CLEARALL]','\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n\n**Wyczyścił wszystkim czat!**', 'esx_clearall')
end, false, {help = TranslateCap('command_clearall')})

ESX.RegisterCommand("refreshjobs", 'admin', function(xPlayer, args, showError)
	ESX.RefreshJobs()
end, true, {help = TranslateCap('command_clearall')})


ESX.RegisterCommand('setgroup', 'admin', function(xPlayer, args, showError)
	--if not xPlayer then print('Komenda doste')
	if not args.playerId then args.playerId = xPlayer.source end
	local xTarget = args.playerId
	local oldGroup = xTarget.getGroup()
	if args.group == "superadmin" then args.group = "admin" print("[^3WARNING^7] ^5Superadmin^7 detected, setting group to ^5admin^7") end
	if xPlayer then
		TriggerEvent('hp-logs:sendLog', xPlayer.source, '[SETGROUP]','\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Ustawił grupę graczu: **'..GetPlayerName(xTarget.source)..'\n**Nowa grupa: **'..args.group..'\n**Stara grupa: **'..oldGroup, 'esx_setgroup')
	end
	xTarget.setGroup(args.group)
end, true, {help = TranslateCap('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = TranslateCap('command_setgroup_group'), type = 'string'},
}})

ESX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
	Core.SavePlayer(args.playerId)
	print("[^2Info^0] Saved Player - ^5".. args.playerId.source .. "^0")
end, true, {help = TranslateCap('command_save'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', 'admin', function(xPlayer, args, showError)
	Core.SavePlayers()
end, true, {help = TranslateCap('command_saveall')})

ESX.RegisterCommand('tpm', "admin", function(xPlayer, args, showError)
	--if not args.powod then return end
	xPlayer.triggerEvent("esx:tpm")
end, true,{help = "Teleportuje gracza na wskazane miejsce na mapie"})

ESX.RegisterCommand('goto', "admin", function(xPlayer, args, showError)
	local xTarget = args.playerId
	local targetCoords = xTarget.getCoords()
	xPlayer.setCoords(targetCoords)
	TriggerEvent('hp-logs:sendLog', xPlayer.source, '[ESX GOTO]','\n**Admin: **'..GetPlayerName(xPlayer.source)..' teleportował się do: '..GetPlayerName(xTarget.source)..'\n**Kordy docelowego gracza: **'..json.encode(targetCoords), 'esx_goto')
end, false, {help = TranslateCap('command_goto'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('bring', "admin", function(xPlayer, args, showError)
	local playerCoords = xPlayer.getCoords()
	local xTarget = args.playerId
	xTarget.setCoords(playerCoords)
	TriggerEvent('hp-logs:sendLog', xPlayer.source, '[ESX GOTO]','\n**Admin: **'..GetPlayerName(xPlayer.source)..' teleportował '..GetPlayerName(xTarget.source)..' do siebie.\n**Kordy docelowego gracza: **'..json.encode(playerCoords), 'esx_bring')

end, false, {help = TranslateCap('command_bring'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('kill', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent("esx:killPlayer")
end, true, {help = TranslateCap('command_kill'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('freeze', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:freezePlayer', "freeze")
end, true, {help = TranslateCap('command_freeze'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('unfreeze', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx:freezePlayer', "unfreeze")
end, true, {help = TranslateCap('command_unfreeze'), validate = true, arguments = {
	{name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand("noclip", 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:noclip')
end, false)

RegisterNetEvent('hp_logs:tpm', function(oldCoords, newCoords, check)
	if not check or not reason then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('hp-logs:sendLog', xPlayer.source, '[ESX TPM]','**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Użył komendy tpm.**\n**Stare kordy: **vector3(x:'..oldCoords.x..' y:'..oldCoords.y..' z:'..oldCoords.z..')\n**Nowe kordy: **vector3(x:'..newCoords.x..' y:'..newCoords.y..' z:'..newCoords.z..')\n\n**Powód: ** Nie podano', 'esx_tpm')
end)

ESX.RegisterCommand('tp', 'admin', function(xPlayer, args, showError)
    if not args.x or not args.y or not args.z then return end
    xPlayer.triggerEvent('esx:teleport', args.x, args.y,args.z)

end, false,{help = "Teleport", arguments = {{name = 'x', help = "X", type = 'number'},{name = 'y', help = "Y", type = 'number'},{name = 'z', help = "Z", type = 'number'},}
})
ESX.RegisterCommand('otworz_eq', 'admin', function(xPlayer, args, showError)
	if not args.id then return end
	local tPlayer = args.id
	exports.ox_inventory:forceOpenInventory(xPlayer.source, 'player', tPlayer.source)

end, false, {help = 'Otwiera ekwipunek gracza którym można zarządzać', arguments = {{name='id', help='ID Gracza', type='player'}}})

ESX.RegisterCommand('kick', 'admin', function(xPlayer,args,showErr)
	local xTarget = args.id
	if xTarget then
		local reason = args.reason
		local admin = xPlayer and GetPlayerName(xPlayer.source) or 'Konsola'
		DropPlayer(xTarget.source, 'Zostałeś wyrzucony z serwera przez Administratora: '..admin..'. Powód: '..reason)
	end
end, true, {help = 'Wyrzuć gracza z serwera', arguments = {
	{name = 'id', help = 'ID Gracza', type='player'},
	{name = 'reason', help = 'powod', type='any'}
}})

ESX.RegisterCommand('admin_komendy', {'support', 'mod', 'admin'}, function(xPlayer,args,showErr)
	print('Dostępne komendy: \n')
	print('/setjob id_gracza nazwa_joba grade_joba | Nadaje joba graczowi (admin)')
	print('/car model | Respi auto (admin)')
	print('/dv radius | Usuwa auto obok gracza bądź promień aut o ile go podamy (admin)')
	print('/kick id_gracza | Wyrzuca gracza z serwera (każda rola)')
	print('/otworz_eq id_gracza | Otwiera ekwipunek gracza (admin)')
	print('/tp kord_x kord_y kord_z | Teleportuje na wybrane kordy (admin)')
	
end, true)