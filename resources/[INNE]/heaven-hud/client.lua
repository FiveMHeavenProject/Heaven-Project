ESX = exports["es_extended"]:getSharedObject()
local ShowArmor = false

--Restart skryptu
AddEventHandler('onResourceStart', function(resourceName)
	if not resourceName == GetCurrentResourceName() then return end
	Wait(1000)
	SendNUIMessage({ action = "openHud", status = true })
	SendNUIMessage({
		action = 'setID',
		id_label = GetPlayerServerId(PlayerId())
	})
	SendNUIMessage({
		action = 'updateHealth',
		healthPrecent = math.floor(GetEntityHealth(PlayerPedId()) - 100)
	})
	SendNUIMessage({
		action = 'updateArmour',
		armourPrecent = GetPedArmour(PlayerPedId())
	})
end)

--Załadowanie na serwer
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Wait(1000)
	SendNUIMessage({
		action = 'setID',
		id_label = GetPlayerServerId(PlayerId())
	})
	SendNUIMessage({
		action = 'updateHealth',
		healthPrecent = math.floor(GetEntityHealth(PlayerPedId()) - 100)
	})
	SendNUIMessage({
		action = 'updateArmour',
		armourPrecent = GetPedArmour(PlayerPedId())
	})
	ESX.TriggerServerCallback("heavenrp:GetSSN", function(cb)
		if cb then
			SendNUIMessage({
				action = 'setSSN',
				ssn_label = cb
			})
		end
	end)
end)

--Zmiana voice'a

--[[
	Poniższa tablica reprezentuje ustawienie wartości procentowych dla różnych głośności mówienia:
		Przykladowo:

		Szept   25% w hudzie
		 [1]   = 	25
--]]
local voice_ranges = {
	[1] = 33,
	[2] = 66,
	[3] = 100
}

-- Nasłuch na zmiane głośności mówienia
AddEventHandler('pma-voice:setTalkingMode', function(mode)
	SendNUIMessage({ action = 'voice_range', voicerange = voice_ranges[mode] })
end)

-- Nasłuch na restart skryptu z voicem
AddEventHandler('onResourceStart', function(resourceName)
	if not resourceName == 'pma-voice' then return end
	Wait(1000)
	SendNUIMessage({ type = 'voice_range', voicerange = voice_ranges[LocalPlayer.state.proximity.index] })
end)

-- Gadanie
Citizen.CreateThread(function()
	local wasTalking = false
	while true do
		if NetworkIsPlayerTalking(PlayerId()) then
			SendNUIMessage({ action = "TalkingOnMic", talking = true })
			wasTalking = true
		elseif wasTalking then
			SendNUIMessage({ action = "TalkingOnMic", talking = false })
			wasTalking = false
		end
		Citizen.Wait(300)
	end
end)

--Health i Armor
Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local playerPreviousHealth = GetEntityHealth(Ped)
		local playerPreviousArmor = GetPedArmour(Ped)
		local wasdead = exports["xrp_medical"]:isPlayerDead()
		Citizen.Wait(800)
		local playerCurrentHealth = GetEntityHealth(Ped)
		local playerCurrentArmour = GetPedArmour(Ped)
		local isdead = exports["xrp_medical"]:isPlayerDead()
		if not isdead then
			if playerPreviousHealth ~= playerCurrentHealth or wasdead ~= isdead then
				SendNUIMessage({ action = "updateHealth", healthPrecent = math.floor(playerCurrentHealth - 100) })
			end
			if playerPreviousArmor ~= playerCurrentArmour then
				SendNUIMessage({ action = "updateArmour", armourPrecent = playerCurrentArmour })
			end
		else
			SendNUIMessage({ action = "updateHealth", healthPrecent = 0 })
		end
	end
end)

-- Jedzenie/Picie
local status = {}
AddEventHandler('esx_status:onTick', function(data)
	for i = 1, #data do
		if data[i].name == 'thirst' then status.drinkBar = math.floor(data[i].percent) end
		if data[i].name == 'hunger' then status.foodBar = math.floor(data[i].percent) end
	end

	SendNUIMessage({ action = "updateStatus", status = status })
end)

--carhud
local inCar = false
local CarHudThread = function()
	Citizen.CreateThread(function()
		local Ped = PlayerPedId()
		local previousSpeed = 0
		while inCar do
			Citizen.Wait(110)
			local vehicle = GetVehiclePedIsIn(Ped, false)
			local currentSpeed = GetEntitySpeed(vehicle)

			if math.abs(currentSpeed - previousSpeed) >= 0.75 or currentSpeed <= 1 then
				SendNUIMessage({ action = "updateCarSpeed", speed = math.floor(currentSpeed * 3.6) })
				previousSpeed = currentSpeed
			end
		end
	end)
end

local FuelThread = function()
	Citizen.CreateThread(function()
		local Ped = PlayerPedId()
		while inCar do
			local vehicle = GetVehiclePedIsIn(Ped, false)
			local FuelLevel = GetVehicleFuelLevel(vehicle)
			SendNUIMessage({ action = "updateCarFuelLevel", fuel = math.round(FuelLevel) })
			Citizen.Wait(15000)
		end
	end)
end

local streetdata = {}
local StreetLabelThread = function()
	Citizen.CreateThread(function()
		local Ped = PlayerPedId()
		while inCar do
			local vehicle = GetVehiclePedIsIn(Ped, false)
			local coords = GetEntityCoords(Ped)
			local zone = GetNameOfZone(coords.x, coords.y, coords.z);
			local streetName = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
			local heading = GetEntityHeading(Ped)

			if heading >= 60 and heading < 150 then
				streetdata.direction = "W"
			elseif heading >= 150 and heading < 240 then
				streetdata.direction = "S"
			elseif heading >= 240 and heading < 330 then
				streetdata.direction = "E"
			elseif heading >= 330 or heading < 60 then
				streetdata.direction = "N"
			end

			streetdata.zone = GetLabelText(zone)
			streetdata.street = GetStreetNameFromHashKey(streetName)
			SendNUIMessage({ action = "updateStreetAndZone", street = streetdata })
			Citizen.Wait(2500)
		end
	end)
end

local vehicledata = {}
local OtherThread = function()
	local ThreadOnGoing = true
	Citizen.CreateThread(function()
		local Ped = PlayerPedId()

		while inCar do
			local vehicle = GetVehiclePedIsIn(Ped, false)

			vehicledata.enginestate = GetIsVehicleEngineRunning(vehicle)
			_, __, ___ = GetVehicleLightsState(vehicle)
			vehicledata.lock = GetVehicleDoorLockStatus(vehicle)


			vehicledata.lightstate = 0
			if (__ == 1 or ___ == 1) and vehicledata.enginestate == 1 then
				vehicledata.lightstate = 1
			end



			if vehicledata.enginestate ~= lastenginestate or vehicledata.lightstate ~= lastlightstate or vehicledata.lock ~= lastlockstate then
				SendNUIMessage({ action = "updateVehicle", vehdata = vehicledata })
				lastenginestate = vehicledata.enginestate
				lastlightstate = vehicledata.lightstate
				lastlockstate = vehicledata.lock
			end
			Citizen.Wait(750)
		end
	end)
end

-- Display carhudu EDIT: dorzucony radar
CreateThread(function()
	DisplayRadar(false)
end)
AddEventHandler('esx:enteredVehicle', function()
	SendNUIMessage({ action = "carHud", status = true })
	inCar = true
	CarHudThread()
	FuelThread()
	StreetLabelThread()
	OtherThread()
	DisplayRadar(true)
end)
AddEventHandler('esx:exitedVehicle', function()
	DisplayRadar(false)
	SendNUIMessage({ action = "carHud", status = false })
	inCar = false
end)

--[[
CreateThread(function()
    while true do
	Citizen.Wait(1000)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			Wait(1000)
			DisplayRadar(true)
		else
			DisplayRadar(false)
		end
    end
end)
--]]

--Usuniecie wyswietlania w prawym dolnym (zoptymalizowane, sprawdzic czy poprawnie dziala)
CreateThread(function()
	SetHudComponentPosition(6, 0.0, 0.15)
	SetHudComponentPosition(7, 0.0, 0.15)
	SetHudComponentPosition(9, 0.0, 0.15)
end)

--Pasy
RegisterNetEvent('xrp_core:BeltStatusChange')
AddEventHandler('xrp_core:BeltStatusChange', function(value)
	SendNUIMessage({ action = "seatbelt", seatbelt = value })
end)

RegisterNetEvent('showHud')
AddEventHandler('showHud', function()
	SendNUIMessage({ action = "openHud", status = true })
end)

RegisterNetEvent('hideHud')
AddEventHandler('hideHud', function()
	SendNUIMessage({ action = "closeHud", status = false })
end)

local currentResolution = {
	width = 0,
	height = 0
}
UpdateRadar = function()
	local screenWidth, screenHeight = GetActiveScreenResolution()
	local newResolution = {
		width = screenWidth,
		height = screenHeight
	}

	if newResolution.width ~= currentResolution.width or newResolution.height ~= currentResolution.height then
		-- Gracz zmienił rozdzielczość gry
		currentResolution = newResolution

		-- Wywołaj funkcję lub wykonaj działania po zmianie rozdzielczości

		-- Zaktualizuj rozmiary mapy
		SendNUIMessage({ action = "updateRadar", minimap = GetMinimapAnchor() })
	end
end

CreateThread(function()
	while true do
		Wait(5000)
		UpdateRadar()
	end
end)

AddEventHandler('esx:pauseMenuActive', function(isActive)
    if isActive then
        SendNUIMessage({ action = "closeHud", status = false })
    else
        SendNUIMessage({ action = "openHud", status = true })
    end
end)

RegisterNetEvent("hp_minimap:InventoryCloseAndCar", function()
    if inCar then
        SendNUIMessage({ action = "carHud", status = true })
    end
end)
RegisterNetEvent("heaven-hud:InventoryOpenAndCar", function()
    if inCar then
		SendNUIMessage({ action = "carHud", status = false })
	end
end)

AddEventHandler("mumbleConnected", function()
	
end)