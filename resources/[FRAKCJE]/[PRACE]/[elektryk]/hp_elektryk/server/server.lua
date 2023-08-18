ESX = exports['es_extended']:getSharedObject()
local pVeh = {}

ESX.RegisterServerCallback('hp_elektryk:checkCaution', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer.getAccount('bank').money >= Config.VehCaution then
		xPlayer.removeAccountMoney('bank', Config.VehCaution)
		xPlayer.triggerEvent('okokNotify:Alert', 'ELEKTRYK', 'Pobrano kaucje w wysokości '.. Config.VehCaution..'$', 5000, 'info')
		pVeh[source] = true
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent('hp_elektryk:payForJob', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job.name == 'elektryk' then exports.hp_logs:cheatAlert(source, 'Zapłata za pracę bez joba') return end
	if not data.isWorking then exports.hp_logs:cheatAlert(source, 'Zapłata z jobem ale nie rozpoczętą pracą') return end
	if not data.vehicle then exports.hp_logs:cheatAlert(source, 'Zapłata z jobem ale nie rozpoczętą pracą(brak pojazdu)') return end

	TriggerEvent('heaven_stats:addPointForRanking', xPlayer.source)
	xPlayer.addAccountMoney('bank', Config.Payment)
end)

RegisterNetEvent('hp_elektryk:returnCaution', function(veh, dist)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not pVeh[source] then exports.hp_logs:cheatAlert(source, 'Zwrot auta bez kaucji') return end
	if not xPlayer.job.name == 'elektryk' then exports.hp_logs:cheatAlert(source, 'Próba zwrotu auta bez joba') return end
	if dist > 15 then exports.hp_logs:cheatAlert(source, 'Próba zwrotu auta z za dużym dystansem. Prawdziwy dystans: '..dist) return end
	pVeh[source] = nil
	xPlayer.addAccountMoney('bank', Config.VehCaution)
end)