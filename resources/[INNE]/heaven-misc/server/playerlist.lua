ESX = exports["es_extended"]:getSharedObject()
local connectedPlayers = {}

ESX.RegisterServerCallback('xrp_playerlist:getPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('heaven-misc:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local ssn = MySQL.scalar.await("SELECT `id` FROM users WHERE identifier = ?", {xPlayer.identifier})
	if ssn then xPlayer.set('ssn', ssn) end
	AddPlayerToList(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('heaven-misc:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToList()
		end)
	end
end)


function AddPlayerToList(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].job = xPlayer.job.name
	connectedPlayers[playerId].ssn = xPlayer.get('ssn') or "ERROR"

	if update then
		TriggerClientEvent('heaven-misc:updateConnectedPlayers', -1, connectedPlayers)
	end
end


function AddPlayersToList()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToList(xPlayer, false)
	end
	
	TriggerClientEvent('heaven-misc:updateConnectedPlayers', -1, connectedPlayers)
end




