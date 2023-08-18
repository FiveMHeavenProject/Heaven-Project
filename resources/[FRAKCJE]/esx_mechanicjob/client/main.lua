local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy, isActive, isAttached = false, false, false, false
local carId = nil
local carBodyHP, carEngineHP, carPlate, takenCar, registeredTowable, brokenCar = nil, nil, nil, nil, nil, nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)

--[[AddEventHandler('onClientResourceStart', function(resourceName)
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
		local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

		SetBlipSprite (blip, 446)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(TranslateCap('mechanic'))
		EndTextCommandSetBlipName(blip)
	end

	exports.ox_target:addBoxZone({
		coords = Config.places.BossMenu,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'mechanic:BossMenu',
				icon = 'fa-solid fa-cube',
				label = 'Otwórz akcje szefa',
				canInteract = function(entity, distance, coords, name, bone)
					if ESX.PlayerData.job.name == 'mechanic' and ESX.PlayerData.job.grade_name == "boss" then
						return true
					end
				end,
				onSelect = function(data)
					TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
						ESX.CloseContext()
				 	end)
				end,
			}
		}
	})
	
	exports.ox_target:addBoxZone({
		coords = Config.places.Stash,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'mechanic:stash',
				icon = 'fa-solid fa-cube',
				label = 'Otwórz schowek',
				canInteract = function(entity, distance, coords, name, bone)
					if ESX.PlayerData.job.name == 'mechanic' then
						return true
					end
				end,
				onSelect = function(data)
					exports.ox_inventory:openInventory('stash', 'mechanic:stash')
				end,
			}
		}
	})
	
	exports.ox_target:addBoxZone({
		coords = Config.places.Clothes,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'mechanic:clothes',
				icon = 'fa-solid fa-cube',
				label = 'Otwórz szafkę z ubraniami',
				canInteract = function(entity, distance, coords, name, bone)
					if ESX.PlayerData.job.name == 'mechanic' then
						return true
					end
				end,
				onSelect = function(data)
					OpenCloakroomMenu()
				end,
			}
		}
	})

	exports.ox_target:addBoxZone({
		coords = Config.places.GetCar,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'mechanic:getCar',
				icon = 'fa-solid fa-cube',
				label = 'Wybierz pojazd',
				canInteract = function(entity, distance, coords, name, bone)
					if ESX.PlayerData.job.name == 'mechanic' then
						return true
					end
				end,
				onSelect = function(data)
					spawnMechanicCar()
				end,
			}
		}
	})

	exports.ox_target:addBoxZone({
		coords = Config.places.RemoveCar,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'mechanic:removeCar',
				icon = 'fa-solid fa-cube',
				label = 'Odholuj pojazd',
				canInteract = function(entity, distance, coords, name, bone)
					if ESX.PlayerData.job.name == 'mechanic' then
						return true
					end
				end,
				onSelect = function(data)
					removeCar()
				end,
			}
		}
	})

end)--]]

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(TranslateCap('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable  = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(TranslateCap('mission_canceled'), "error")
	else
		--TriggerServerEvent('esx_mechanicjob:onNPCJobCompleted')
	end
end

function OpenMechanicHarvestMenu()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{unselectable = true, icon = "fas fa-gear", title = "Mechanic Harvest Menu"},
			{icon = "fas fa-gear", title = TranslateCap('gas_can'), value = 'gaz_bottle'},
			{icon = "fas fa-gear", title = TranslateCap('repair_tools'), value = 'fix_tool'},
			{icon = "fas fa-gear", title = TranslateCap('body_work_tools'), value = 'caro_tool'}
		}

		ESX.OpenContext("right", elements, function(menu,element)
			if element.value == 'gaz_bottle' then
				TriggerServerEvent('esx_mechanicjob:startHarvest')
			elseif element.value == 'fix_tool' then
				TriggerServerEvent('esx_mechanicjob:startHarvest2')
			elseif element.value == 'caro_tool' then
				TriggerServerEvent('esx_mechanicjob:startHarvest3')
			end
		end, function(menu)
			CurrentAction     = 'mechanic_harvest_menu'
			CurrentActionMsg  = TranslateCap('harvest_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(TranslateCap('not_experienced_enough'))
	end
end

function OpenMechanicCraftMenu()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{unselectable = true, icon = "fas fa-gear", title = "Mechanic Craft Menu"},
			{icon = "fas fa-gear", title = TranslateCap('blowtorch'),  value = 'blow_pipe'},
			{icon = "fas fa-gear", title = TranslateCap('repair_kit'), value = 'fix_kit'},
			{icon = "fas fa-gear", title = TranslateCap('body_kit'),   value = 'caro_kit'}
		}

		ESX.OpenContext("right", elements, function(menu,element)
			if element.value == 'blow_pipe' then
				TriggerServerEvent('esx_mechanicjob:startCraft')
			elseif element.value == 'fix_kit' then
				TriggerServerEvent('esx_mechanicjob:startCraft2')
			elseif element.value == 'caro_kit' then
				TriggerServerEvent('esx_mechanicjob:startCraft3')
			end
		end, function(menu)
			CurrentAction     = 'mechanic_craft_menu'
			CurrentActionMsg  = TranslateCap('craft_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(TranslateCap('not_experienced_enough'))
	end
end

function OpenMobileMechanicActionsMenu()
	local elements = {
		{unselectable = true, icon = "fas fa-gear", title = TranslateCap('mechanic')},
		{icon = "fas fa-gear", title = TranslateCap('billing'),       value = 'billing'},
		-- {icon = "fas fa-gear", title = TranslateCap('hijack'),        value = 'hijack_vehicle'},
		-- {icon = "fas fa-gear", title = TranslateCap('repair'),        value = 'fix_vehicle'},
		-- {icon = "fas fa-gear", title = TranslateCap('clean'),         value = 'clean_vehicle'},
		-- {icon = "fas fa-gear", title = TranslateCap('imp_veh'),       value = 'del_vehicle'},
		{icon = "fas fa-gear", title = TranslateCap('flat_bed'),      value = 'dep_vehicle'},
		-- {icon = "fas fa-gear", title = TranslateCap('place_objects'), value = 'object_spawner'}
		{icon = "fas fa-gear", title = "Menu Tuningu", value = 'tuning_menu'}
	}

	ESX.OpenContext("center", elements, function(menu,element)
		if isBusy then return end

		if element.value == "billing" then
			local elements2 = {
				{unselectable = true, icon = "fas fa-scroll", title = element.title},
				{title = "SSN", input = true, inputType = "number", inputMin = 1, inputMax = 250000, inputPlaceholder = "Wpisz SSN osoby..."},
				{title = "Ilość", input = true, inputType = "number", inputMin = 1, inputMax = 250000, inputPlaceholder = "Kwota za usługę"},
				{icon = "fas fa-check-double", title = "Confirm", value = "confirm"}
			}

			ESX.OpenContext("center", elements2, function(menu2,element2)
				local ssn = tonumber(menu2.eles[2].inputValue)
				local amount = tonumber(menu2.eles[3].inputValue)

				if ssn == nil or amount == nil then ESX.ShowNotification("Nie podałeś wszystkich wartości") return end

				TriggerServerEvent('esx_mechanicjob:billing', ssn, amount)
				ESX.CloseContext()
			end)

		elseif element.value == "hijack_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(TranslateCap('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				CreateThread(function()
					Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(TranslateCap('vehicle_unlocked'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(TranslateCap('no_vehicle_nearby'))
			end
		elseif element.value == "fix_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(TranslateCap('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				CreateThread(function()
					Wait(20000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(TranslateCap('vehicle_repaired'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(TranslateCap('no_vehicle_nearby'))
			end
		elseif element.value == "clean_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(TranslateCap('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				CreateThread(function()
					Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(TranslateCap('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(TranslateCap('no_vehicle_nearby'))
			end
		elseif element.value == "del_vehicle" then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(TranslateCap('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(TranslateCap('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(TranslateCap('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(TranslateCap('must_near'))
				end
			end
		elseif element.value == "dep_vehicle" then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			local towmodel = `flatbed`
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)

			if isVehicleTow then
				local targetVehicle = ESX.Game.GetVehicleInDirection()

				if CurrentlyTowedVehicle == nil then
					if targetVehicle ~= 0 then
						if not IsPedInAnyVehicle(playerPed, true) then
							if vehicle ~= targetVehicle then
								AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								CurrentlyTowedVehicle = targetVehicle
								ESX.ShowNotification(TranslateCap('vehicle_success_attached'))

								if NPCOnJob then
									if NPCTargetTowable == targetVehicle then
										ESX.ShowNotification(TranslateCap('please_drop_off'))
										Config.Zones.VehicleDelivery.Type = 1

										if Blips['NPCTargetTowableZone'] then
											RemoveBlip(Blips['NPCTargetTowableZone'])
											Blips['NPCTargetTowableZone'] = nil
										end

										Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
										SetBlipRoute(Blips['NPCDelivery'], true)
									end
								end
							else
								ESX.ShowNotification(TranslateCap('cant_attach_own_tt'))
							end
						end
					else
						ESX.ShowNotification(TranslateCap('no_veh_att'))
					end
				else
					AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(CurrentlyTowedVehicle, true, true)

					if NPCOnJob then
						if NPCTargetDeleterZone then

							if CurrentlyTowedVehicle == NPCTargetTowable then
								ESX.Game.DeleteVehicle(NPCTargetTowable)
								TriggerServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
								StopNPCJob()
								NPCTargetDeleterZone = false
							else
								ESX.ShowNotification(TranslateCap('not_right_veh'))
							end

						else
							ESX.ShowNotification(TranslateCap('not_right_place'))
						end
					end

					CurrentlyTowedVehicle = nil
					ESX.ShowNotification(TranslateCap('veh_det_succ'))
				end
			else
				ESX.ShowNotification(TranslateCap('imp_flatbed'))
			end
		elseif element.value == "object_spawner" then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(TranslateCap('inside_vehicle'))
				return
			end

			local elements2 = {
				{unselectable= true, icon = "fas fa-object", title = TranslateCap('objects')},
				{icon = "fas fa-object", title = TranslateCap('roadcone'), value = 'prop_roadcone02a'},
				{icon = "fas fa-object", title = TranslateCap('toolbox'),  value = 'prop_toolchest_01'}
			}

			ESX.OpenContext("right", elements2, function(menuObj,elementObj)
				local model   = elementObj.value
				local coords  = GetEntityCoords(playerPed)
				local forward = GetEntityForwardVector(playerPed)
				local x, y, z = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 1.0
				elseif model == 'prop_toolchest_01' then
					z = z - 1.0
				end

				ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end)
		elseif element.value == "tuning_menu" then
			local ped = PlayerPedId()
			local pCoords = GetEntityCoords(ped)
			local dist = #(pCoords - Config.Zones.MechanicActions.Pos)
			if dist < 20 then
				if IsPedInAnyVehicle(ped, false) then
					ESX.CloseContext()
					local vehicle = GetVehiclePedIsIn(ped, false)
					TriggerEvent('rey_tuning:TuningMenu')
					
				else
					ESX.ShowNotification("Musisz być w pojeździe by móc tuningować pojazd")
				end
			else 
				ESX.ShowNotification("Musisz być na terenie warsztatu")
			end
			ESX.CloseContext()
		end
	end)
end

exports('OpenMobileMechanicActionsMenu', OpenMobileMechanicActionsMenu)

function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject
		
		sex = (skin.sex == 0) and "male" or "female"

		uniformObject = Config.Uniforms[uniform][sex]

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
		else
			ESX.ShowNotification(TranslateCap('no_outfit'))
		end
	end)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function OpenCloakroomMenu() 
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{unselectable = true, icon = "fas fa-shirt", title = TranslateCap("cloakroom")},
		{icon = "fas fa-shirt", title = TranslateCap('citizen_wear'), value = 'citizen_wear'},
		{icon = "fas fa-shirt", title = TranslateCap('mechanic_wear'), uniform = grade}
	}

	ESX.OpenContext("center", elements, function(menu,element)
		cleanPlayer(playerPed)
		local data = {current = element}

		if data.current.value == 'citizen_wear' then			
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)			
		end

		if data.current.uniform then
			setUniform(data.current.uniform, playerPed)
		elseif data.current.value == 'freemode_ped' then
			local modelHash

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = joaat(data.current.maleModel)
				else
					modelHash = joaat(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)
					SetPedDefaultComponentVariation(PlayerPedId())

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(menu)
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = TranslateCap('open_cloackroom')
		CurrentActionData = {}
	end)

end

RegisterNetEvent('esx_mechanicjob:onHijack')
AddEventHandler('esx_mechanicjob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			CreateThread(function()
				Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(TranslateCap('veh_unlocked'))
				else
					ESX.ShowNotification(TranslateCap('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onCarokit')
AddEventHandler('esx_mechanicjob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			CreateThread(function()
				Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(TranslateCap('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end
		if DoesEntityExist(vehicle) then
			FreezeEntityPosition(playerPed, true)
			FreezeEntityPosition(vehicle, true)
			local carr = ESX.Game.GetVehicleProperties(vehicle)
			print(carr.engineHealth, "enginehp")
			print(carr.bodyHealth, "bodyhp")

			if lib.progressCircle({
				duration = 5000,
				position = 'bottom',
				useWhileDead = false,
				canCancel = true,
				anim = {
					dict = 'mp_car_bomb',
					clip = 'car_bomb_mechanic'
				},
			}) then
				ESX.Game.SetVehicleProperties(vehicle, {
					engineHealth = 500,
				}) 
				-- SetVehicleBodyHealth(vehicle, 1000)
				SetVehicleUndriveable(vehicle, false)
				ESX.ShowNotification(TranslateCap('veh_repaired'))
				ClearPedTasksImmediately(playerPed)
				FreezeEntityPosition(playerPed, false)
				FreezeEntityPosition(vehicle, false)				
				TriggerServerEvent("esx_mechanicjob:finishedFixkit")				
			else 
				ESX.ShowNotification("Przerwałeś naprawianie pojazdu")
				FreezeEntityPosition(vehicle, false)
				FreezeEntityPosition(playerPed, false)
				ClearPedTasksImmediately(playerPed)
			end			
		end
	else
		ESX.ShowNotification("W pobliżu nie ma żadnego pojazdu")
	end
end)

AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = TranslateCap('press_remove_obj')
		CurrentActionData = {entity = entity}
		ESX.TextUI(CurrentActionMsg)
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
	ESX.HideUI()
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = TranslateCap('mechanic'),
		number     = 'mechanic',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Pop NPC mission vehicle when inside area
CreateThread(function()
	while true do
		local Sleep = 1500

		if NPCTargetTowableZone and not NPCHasSpawnedTowable then
			Sleep = 0
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if #(coords - zone.Pos) < Config.NPCSpawnDistance then
				local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

				ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
					NPCTargetTowable = vehicle
				end)

				NPCHasSpawnedTowable = true
			end
		end

		if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
			Sleep = 500
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if #(coords - zone.Pos) < Config.NPCNextToDistance then
				Sleep = 0
				ESX.ShowNotification(TranslateCap('please_tow'))
				NPCHasBeenNextToTowable = true
			end
		end
	Wait(Sleep)
	end
end)

CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	while true do
		Wait(500)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, joaat(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = #(coords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mechanicjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_mechanicjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

RegisterCommand('mechanicjob', function()
	local playerPed = PlayerPedId()
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if NPCOnJob then
				if GetGameTimer() - NPCLastCancel > 5 * 60000 then
					StopNPCJob(true)
					NPCLastCancel = GetGameTimer()
				else
					ESX.ShowNotification(TranslateCap('wait_five'), "error")
				end
			else
				if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `flatbed`) then
					StartNPCJob()
				else
					ESX.ShowNotification(TranslateCap('must_in_flatbed'), "error")
				end
			end
		end
end, false)

function startTowingJob() 
	local playerPed = PlayerPedId()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
		if NPCOnJob then
			if GetGameTimer() - NPCLastCancel > 5 * 60000 then
				StopNPCJob(true)
				NPCLastCancel = GetGameTimer()
			else
				ESX.ShowNotification(TranslateCap('wait_five'), "error")
			end
		else
			if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `flatbed`) then
				StartNPCJob()
			else
				ESX.ShowNotification(TranslateCap('must_in_flatbed'), "error")
			end
		end
	end
end

exports('startTowingJob', startTowingJob)

function getTowId()
	local ped = PlayerPedId()
	local currentVehicle = GetVehiclePedIsUsing(ped)
	local carModel = GetEntityModel(currentVehicle)
	print(currentVehicle)
	print(carModel)
	if carModel == 1353720154 then
		ESX.ShowNotification("Pomyślnie zarejestrowałeś pojazd jako lawetę.")	
		registeredTowable = currentVehicle	
		isActive = true
	else 
		ESX.ShowNotification("Nie znajdujesz sie w autolawecie")
	end
end

exports('getTowId', getTowId)

RegisterCommand("checkcar", function()
	print(carId, "XD")
	SetVehicleDoorsLocked(carId, 2)
	print(takenCar, "X")
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()), 15.0)
end, false)

-- RegisterKeyMapping('mechanicMenu', 'Open Mechanic Menu', 'keyboard', 'F6')
-- RegisterKeyMapping('mechanicjob', 'Togggle NPC Job', 'keyboard', 'F6')

exports.ox_target:addGlobalVehicle({{  
	name = "mechanic:attachEntity",
	icon = 'fa-solid fa-hand-sparkles',
	label = 'Wrzuć pojazd na lawete',
	canInteract = function(entity, distance, coords, name, bone)
		if GetEntityModel(entity) == 1353720154 then return end
		if ESX.PlayerData.job.name == 'mechanic' and isActive then
			return true
		end
	end,
	onSelect = function(data)
		TriggerEvent('esx_mechanicjob:attachCar', data.entity)
		print("dotad dziala")
	end,
	}
})

exports.ox_target:addGlobalVehicle({{  
	name = "mechanic:detachEntity",
	icon = 'fa-solid fa-hand-sparkles',
	label = 'Zrzuć pojazd z lawety',
	canInteract = function(entity, distance, coords, name, bone)
		if ESX.PlayerData.job.name == 'mechanic' and isAttached then
			if GetEntityModel(entity) == 1353720154 and registeredTowable == entity then
				return true
		   end
		end		
	end,
	onSelect = function(data)
		TriggerEvent('esx_mechanicjob:detachCar', data.entity)		
	end,
	}
})

exports.ox_target:addGlobalVehicle({{  
	name = "mechanic:repairMenu",
	icon = 'fa-solid fa-hand-sparkles',
	label = 'Umyj pojazd',
	canInteract = function(entity, distance, coords, name, bone)
		if ESX.PlayerData.job.name == 'mechanic' then
			return true
		end
	end,
	onSelect = function(data)
		TriggerEvent('esx_mechanicjob:cleanCar', data.entity)
	end,
	}
})

exports.ox_target:addGlobalVehicle({
    {
        name = 'mechanic:checkVehicle',
        icon = 'fa-solid fa-wrench',
        label = 'Sprawdzanie stanu pojazdu',
        bones = 'bonnet',
        canInteract = function(entity, distance, coords, name, boneId)
			if ESX.PlayerData.job.name == 'mechanic' then
				return true
			end           
        end,
        onSelect = function(data)            
			TriggerEvent("esx_mechanicjob:checkVehicle", data.entity)
        end
    }
})

exports.ox_target:addGlobalVehicle({{  
	name = "mechanic:repairVehicle",
	icon = 'fa-solid fa-toolbox',
	label = 'Naprawianie pojazdu',
	bones = 'bonnet',
	canInteract = function(entity, distance, coords, name, bone)
		if ESX.PlayerData.job.name == 'mechanic' then
			return true
		end
	end,
	onSelect = function(data)
		if carId == nil then ESX.ShowNotification("Musisz najpierw sprawdzić pojazd") return end

		if carId ~= data.entity then ESX.ShowNotification("To nie tym pojazdem sie zajmujesz") return end
		
		if Entity(carId).state.checked ~= "true" then
			print("Sprawdz pojazd najpierw")
		else
			TriggerEvent("esx_mechanicjob:repairVehicle", data.entity)
		end
	end,
	}
})

exports.ox_target:addGlobalVehicle({
    {
        name = 'mechanic:checkVehicle',
        icon = 'fa-solid fa-screwdriver',
        label = 'Wyłam zamek w pojeździe',
		bones = { 'door_dside_f', 'seat_dside_f', 'door_pside_f', 'seat_pside_f' , 'door_dside_r', 'seat_dside_r',  'door_pside_r', 'seat_pside_r' },
        canInteract = function(entity, distance, coords, name, boneId)
			local hasItem = ESX.SearchInventory('lockpick', 1)
			if ESX.PlayerData.job.name == 'mechanic' and hasItem >= 1 then
				return true
			end           
        end,
        onSelect = function(data)            
			TriggerEvent('esx_mechanicjob:breakIn', data.entity)
        end
    }
})

exports.ox_target:addGlobalVehicle({
    {
        name = 'mechanic:checkVehicle',
        icon = 'fa-solid fa-truck-pickup',
        label = 'Odholuj pojazd',
        canInteract = function(entity, distance, coords, name, boneId)
			if ESX.PlayerData.job.name == 'mechanic' then
				return true
			end           
        end,
        onSelect = function(data)            
			TriggerEvent('esx_mechanicjob:deleteVehicle', data.entity)
        end
    }
})

function spawnMechanicCar()	
	local elements2 = {
		{unselectable = true, icon = "fas fa-car", title = TranslateCap('service_vehicle')},
		{icon = "fas fa-truck", title = TranslateCap('flat_bed'),  value = 'flatbed'},
		{icon = "fas fa-truck", title = TranslateCap('tow_truck'), value = 'towtruck2'},
		{icon = "fas fa-truck", title = 'Slamvan', value = 'slamvan3'},
		{icon = "fas fa-truck", title = 'Burrito', value = 'burrito2'},
	}
	ESX.OpenContext("center", elements2, function(menu2,element2)
		if Config.MaxInService == -1 then
			ESX.CloseContext()
			ESX.Game.SpawnVehicle(element2.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
				local playerPed = PlayerPedId()
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				takenCar = vehicle
			end)
		else
			ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
				if canTakeService then
					ESX.CloseContext()
					ESX.Game.SpawnVehicle(element2.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
						local playerPed = PlayerPedId()
						
						TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
					end)
				else
					ESX.ShowNotification(TranslateCap('service_full') .. inServiceCount .. '/' .. maxInService)
				end
			end, 'mechanic')
		end
	end)

end

function removeCar()
	if takenCar then
        local carPos = GetEntityCoords(takenCar, false)
        print(carPos)
        if #(carPos - Config.Zones.VehicleSpawnPoint.Pos) > 5 then
            ESX.ShowNotification("Twój pojazd nie znajduje się na miejscu jego spawnu")
        else
            ESX.Game.DeleteVehicle(takenCar)
            takenCar = nil         
			ESX.ShowNotification("Schowałeś pojazd poprawnie")
        end
    else
        ESX.ShowNotification('Nie pobierałeś jeszcze swojego pojazdu')
    end    
end

RegisterNetEvent('esx_mechanicjob:attachCar', function (entity) 
	brokenCar = entity
	local towCoords = GetEntityCoords(registeredTowable)
	local carCoords = GetEntityCoords(brokenCar)
	local dist = #(towCoords - carCoords)
	
	if dist < 14 then 
		if lib.progressCircle({
			duration = 5000,
			position = 'bottom',
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
			},
			anim = {
				dict = 'mp_car_bomb',
				clip = 'car_bomb_mechanic'
			},
		}) then 

			AttachEntityToEntity(brokenCar, registeredTowable, 0, 0, -2.0, 1, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			SetEntityCollision(brokenCar, false, false)
			ESX.ShowNotification("Pomyślnie wciągnąłeś pojazd na lawetę")
			isAttached = true
			isActive = false
		else
			ESX.ShowNotification("Przerwałeś wciąganie pojazdu na lawetę")
		end
	else 
		ESX.ShowNotification("Pojazd znajduje się za daleko lawety")
	end
end)

RegisterNetEvent('esx_mechanicjob:detachCar', function (entity) 
	local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)

	if lib.progressCircle({
		duration = 5000,
		position = 'bottom',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			dict = 'mp_car_bomb',
			clip = 'car_bomb_mechanic'
		},
	}) then 
		DetachEntity(brokenCar, true, true)
		local offset = GetOffsetFromEntityInWorldCoords(registeredTowable, 0.0, -10.0, 0.0)
		SetEntityCollision(brokenCar, true, true)
		SetEntityCoordsNoOffset(brokenCar, offset.x, offset.y, offset.z, false, false, false)
		isAttached = false
		ESX.ShowNotification("Pojazd został opuszczony z lawety")	
	else
		ESX.ShowNotification("Przerwałeś opuszczanie pojazdu z lawety")
	end
	
	
end)

RegisterNetEvent('esx_mechanicjob:checkVehicle', function(entity)
	local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
	carId = entity
	local dist = #(pCoords - Config.Zones.MechanicActions.Pos)
	local dist2 = #(pCoords - GetEntityCoords(carId))

	if dist2 > 1.7 and dist2 < 3.5 then 
		if dist < 20 then
			if GetVehicleDoorLockStatus(carId) > 1 then return end
			SetVehicleDoorOpen(carId, 4, false, false)
			FreezeEntityPosition(ped, true)

			if lib.progressCircle({
				duration = 5000,
				position = 'bottom',
				useWhileDead = false,
				canCancel = true,
				disable = {
					car = true,
				},
				anim = {
					dict = 'mp_car_bomb',
					clip = 'car_bomb_mechanic'
				},
			}) then 
				local carProperties = ESX.Game.GetVehicleProperties(carId)
				carBodyHP = carProperties.bodyHealth
				carEngineHP = carProperties.engineHealth
				carPlate = carProperties.plate
				Entity(carId).state:set('checked', 'true', true)
				ClearPedTasksImmediately(ped)
				FreezeEntityPosition(ped, false)
				SetVehicleDoorShut(carId, 4, false)
			else 
				ESX.ShowNotification("Przerwałeś sprawdzanie pojazdu")
				SetVehicleDoorShut(carId, 4, false)
				FreezeEntityPosition(ped, false)
			end

		else
			ESX.ShowNotification("Nie znajdujesz się na warsztacie")
		end
	else
		ESX.ShowNotification("Jesteś za daleko od maski pojazdu, podejdź bliżej")
	end
end)

RegisterNetEvent('esx_mechanicjob:repairVehicle', function(entity)

	local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
	carId = entity
	local dist = #(pCoords - Config.Zones.MechanicActions.Pos)
	local dist2 = #(pCoords - GetEntityCoords(carId))


	if dist2 > 1.7 and dist2 < 3.5 then 
		if dist < 20 then			
			if GetVehicleDoorLockStatus(carId) > 1 then return end
			SetVehicleDoorOpen(carId, 4, false, false)
			FreezeEntityPosition(ped, true)
			if lib.progressCircle({
				duration = 5000,
				position = 'bottom',
				useWhileDead = false,
				canCancel = true,
				disable = {
					car = true,
				},
				anim = {
					dict = 'mp_car_bomb',
					clip = 'car_bomb_mechanic'
				},
			}) then 
				SetVehicleFixed(carId)
				SetVehicleDeformationFixed(carId)
				SetVehicleUndriveable(carId, false)
				ClearPedTasksImmediately(ped)
				FreezeEntityPosition(ped, false)
				SetVehicleDoorShut(carId, 4, false)
			else 
				ESX.ShowNotification("Przerwałeś sprawdzanie pojazdu")
				SetVehicleDoorShut(carId, 4, false)
				FreezeEntityPosition(ped, false)
			end

		else
			ESX.ShowNotification("Nie znajdujesz się na warsztacie")
		end
	else
		ESX.ShowNotification("Jesteś za daleko od maski pojazdu, podejdź bliżej")
	end
end)

RegisterNetEvent('esx_mechanicjob:cleanCar', function(entity) 

	local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
	carId = entity
	local dist = #(pCoords - Config.Zones.MechanicActions.Pos)
	local dist2 = #(pCoords - GetEntityCoords(carId))

	if dist2 < 4 then
		if dist < 20 then
			FreezeEntityPosition(ped, true)
			if lib.progressCircle({
				duration = 5000,
				position = 'bottom',
				useWhileDead = false,
				canCancel = true,
				disable = {
					car = true,
				},
				anim = {
					dict = 'mp_car_bomb',
					clip = 'car_bomb_mechanic'
				},
			}) then 
				SetVehicleDirtLevel(carId, 0.0) -- 0 - czysty, 15 - upierdolony jak szwedzki stół	
				ClearPedTasksImmediately(ped)
				FreezeEntityPosition(ped, false)
				
			else 
				ESX.ShowNotification("Przerwałeś sprawdzanie pojazdu")			
				FreezeEntityPosition(ped, false)
			end

		else
			ESX.ShowNotification("Nie znajdujesz się na warsztacie")
		end
	else
		ESX.ShowNotification("Znajdujesz się za daleko pojazdu")
	end




end)

RegisterNetEvent('esx_mechanicjob:breakIn', function(entity) 

	local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
	carId = entity
	local dist2 = #(pCoords - GetEntityCoords(carId))


	if dist2 < 4 then	
		if GetVehicleDoorLockStatus(carId) >= 1 then ESX.ShowNotification("Drzwi tego pojazdu są otwarte!") return end

		FreezeEntityPosition(ped, true)
		if lib.progressCircle({
			duration = 5000,
			position = 'bottom',
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
			},
			anim = {
				dict = 'mp_car_bomb',
				clip = 'car_bomb_mechanic'
			},
		}) then 
			SetVehicleDoorsLocked(carId, 1)
			SetVehicleDoorsLockedForAllPlayers(carId, false)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, false)
			ESX.ShowNotification(TranslateCap('vehicle_unlocked'))
			
		else 
			ESX.ShowNotification("Przerwałeś otwieranie pojazdu")			
			FreezeEntityPosition(ped, false)
		end		
	else
		ESX.ShowNotification("Znajdujesz się za daleko pojazdu")
	end

end)

RegisterNetEvent('esx_mechanicjob:deleteVehicle', function(entity) 

	local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
	carId = entity
	local dist2 = #(pCoords - GetEntityCoords(carId))


	if dist2 < 4 then	
		FreezeEntityPosition(ped, true)
		if lib.progressCircle({
			duration = 5000,
			position = 'bottom',
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
			},
			anim = {
				dict = 'mp_car_bomb',
				clip = 'car_bomb_mechanic'
			},
		}) then 
			ESX.Game.DeleteVehicle(carId)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, false)
			ESX.ShowNotification(TranslateCap('vehicle_impounded'))
		
		else 
			ESX.ShowNotification("Przerwałeś odholowywanie pojazdu")			
			FreezeEntityPosition(ped, false)
		end		
	else
		ESX.ShowNotification("Znajdujesz się za daleko pojazdu")
	end

end)