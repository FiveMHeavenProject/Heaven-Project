ESX = exports["es_extended"]:getSharedObject()
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData = {}
local firstSpawn, IsDead = true, false
local deadDecor = '_IS_DEAD'
local ox_inventory = exports.ox_inventory
CreateThread(function()
	DecorRegister(deadDecor, 1)
end)

AddEventHandler('esx:onPlayerSpawn', function()
	IsDead = false
	DecorRemove(PlayerPedId(), deadDecor)
	if firstSpawn then
		firstSpawn = false
		
		while not ESX.PlayerLoaded do
			Wait(100)
		end
		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
			if shouldDie then
			  Wait(1000)
			  SetEntityHealth(PlayerPedId(), 0)
			end
		end)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	firstSpawn = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)


AddEventHandler('esx:onPlayerDeath', function(reason)
	OnPlayerDeath()
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, heading)
	TriggerEvent('esx:onPlayerSpawn', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('xrp_ambulancejob:heal')
AddEventHandler('xrp_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)
	SetEntityHealth(playerPed, maxHealth)
end)

local CanSendSignal = true

function StartDistressSignal()
	CreateThread(function()
		local timer = Config.RespawnDelayAfterRPDeath

		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 1, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.42, 0.87)

			if IsControlJustPressed(0, Keys['G']) then
				if CanSendSignal then
					CanSendSignal = false
					SendDistressSignal()

					CreateThread(function()
						Citizen.Wait(1000 * 60 * 5)
						if IsDead then
							StartDistressSignal()
						end
					end)
				end
			end
		end
	end)
end

function SendDistressSignal()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

	ESX.ShowNotification('Powiadomienie zostało wysłane do służb!')
end


function RemoveItemsAfterRPDeath()
	CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			ESX.SetPlayerData('lastPosition', Config.RespawnPlace)
			ESX.SetPlayerData('loadout', {})

			TriggerServerEvent('esx:updateLastPosition', Config.RespawnPlace)
			RespawnPed(Citizen.InvokeNative(0x43A66C31C68491C0, -1), Config.RespawnPlace)
			TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end

function StartDeathTimer()
	local earlySpawnTimer = ESX.Math.Round(Config.RespawnDelayAfterRPDeath / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.RespawnDelayAfterRPDeath2 / 1000)

	CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(6)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.92)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(6)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, 46) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
				end
			end

			if IsControlPressed(0, 46) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		if bleedoutTimer < 1 and IsDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function OnPlayerDeath()
	IsDead = true
	DisableControlsWhenDead()
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 1)
	StartDeathTimer()
	StartDistressSignal()
	DeathHandler()
end

function DeathHandler()
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		local lib, anim = 'random@dealgonewrong', 'idle_a'
		ESX.Streaming.RequestAnimDict(lib, function()
			local weapon = GetPedCauseOfDeath(playerPed)
			local sourceofdeath = GetPedSourceOfDeath(playerPed)
			local coords = GetEntityCoords(playerPed)

			if IsPedInAnyVehicle(playerPed, false) then
				while IsPedInAnyVehicle(playerPed, true) do
					Citizen.Wait(100)
				end
			else
				if GetEntitySpeed(playerPed) > 0.2 then
					while GetEntitySpeed(playerPed) > 0.2 do
						Citizen.Wait(100)
					end
				end
			end

			NetworkResurrectLocalPlayer(coords, 0.0, false, false)
			Citizen.Wait(100)
			SetEntityCoords(playerPed, coords)
			SetPlayerInvincible(PlayerId(), true)
			SetPlayerCanUseCover(PlayerId(), false)
			DecorSetInt(PlayerPedId(), deadDecor, 1)
			while IsDead do
				local playerPed = PlayerPedId()
				SetEntityInvincible(playerPed, true)
				SetEntityCanBeDamaged(playerPed, false)
				if not IsPedInAnyVehicle(playerPed, false) then
					if not IsEntityPlayingAnim(playerPed, lib, anim, 3) then
						TaskPlayAnim(playerPed, lib, anim, 1.0, 1.0, -1, 2, 0, 0, 0, 0)
					end
				end
	
				if not DecorExistOn(PlayerPedId(), deadDecor) then
					DecorSetInt(PlayerPedId(), deadDecor, 1)
				end
	
				Citizen.Wait(50)
			end
			SetPlayerInvincible(PlayerId(), false)
			SetPlayerCanUseCover(PlayerId(), true)
			SetEntityInvincible(playerPed, false)
			SetEntityCanBeDamaged(playerPed, true)
			StopAnimTask(PlayerPedId(), lib, anim, 4.0)
			RemoveAnimDict(lib)
			EnableAllControlActions(0)
			DecorRemove(PlayerPedId(), deadDecor)
		end)
	end)
end

RegisterNetEvent('xrp_ambulancejob:rev')
AddEventHandler('xrp_ambulancejob:rev', function()
	local playerPed = PlayerPedId()
	local coords	= GetEntityCoords(playerPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

	CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.SetPlayerData('lastPosition', {
			x = coords.x,
			y = coords.y,
			z = coords.z
		})

		TriggerServerEvent('esx:updateLastPosition', {
			x = coords.x,
			y = coords.y,
			z = coords.z
		})

		RespawnPed(playerPed, {
			x = coords.x,
			y = coords.y,
			z = coords.z,
			heading = 0.0
		})

		DoScreenFadeIn(800)
		isDead = false
	end)

end)

-- Disable most inputs when dead
function DisableControlsWhenDead()
	Citizen.CreateThread(function()
	    while IsDead do
			Citizen.Wait(0)
	
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 170, true)
		end
	end)
end

CreateThread(function()
	for i=1, #Config.Blips, 1 do
		local blip = AddBlipForCoord(Config.Blips[i].coords)

		SetBlipSprite(blip, Config.Sprite)
		SetBlipDisplay(blip, Config.Display)
		SetBlipScale(blip, Config.Scale)
		SetBlipColour(blip, Config.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Szpital")
		EndTextCommandSetBlipName(blip)
	end
end)

function isPedDead(playerPed)
	if DecorExistOn(playerPed, deadDecor) then
		return true
	end
	return false
end

exports('isPedDead', isPedDead)


function isPlayerDead()
	return IsDead
end

exports('isPlayerDead', isPlayerDead)


RegisterNetEvent('xrp_ambulancejob:healPlayer')
AddEventHandler('xrp_ambulancejob:healPlayer', function(entity)
	if PlayerData.job.name == 'ambulance' then
		TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
		exports['mythic_progressbar']:ProgressBar('ambulance_heal', 10000, 'Leczysz rany...', true, true, true, function(finished)
			if finished then
				local ped = GetPlayerPed(entity.entity)
				local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity.entity))
				local server = GetPlayerServerId(id)
				TriggerServerEvent('xrp_ambulancejob:healPlayerHandler', server)
				ClearPedTasks(PlayerPedId())
				ESX.ShowNotification('Uleczyłeś/aś rany!')
			else
				ClearPedTasks(PlayerPedId())
			end
		end)
	end
end)


RegisterNetEvent('xrp_ambulancejob:revivePlayer')
AddEventHandler('xrp_ambulancejob:revivePlayer', function(entity)
	if PlayerData.job.name == 'ambulance' then
		ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_str', function()
			TaskPlayAnim(PlayerPedId(), 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest', 8.0, -8.0, -1, 7, 0, false, false, false)
		end)
		exports['mythic_progressbar']:ProgressBar('ambulance_heal', 20000, 'Podnoszenie...', true, true, true, function(finished)
			if finished then
				local ped = GetPlayerPed(entity.entity)
				local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity.entity))
				local server = GetPlayerServerId(id)
				TriggerServerEvent('xrp_ambulancejob:rev', server)
				ClearPedTasks(PlayerPedId())
				ESX.ShowNotification('Ożywiłeś obywatela!')
			else
				ClearPedTasks(PlayerPedId())
			end
		end)
	end
end)

function isAmbulance()
	if PlayerData.job.name == 'ambulance' then
		return true
	end
	return false
end

exports('isAmbulance', isAmbulance)