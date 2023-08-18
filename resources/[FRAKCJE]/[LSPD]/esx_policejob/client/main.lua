local CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask = {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true

	if ESX.PlayerData.job.name == "police" then
		AddTargetRemoval()
		PlaceableObjectsRadial()
	end
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

--[[KRIS - CLOAKROOM]]
function setUniform(uniform, playerPed, sub)
	if sub == nil then
		TriggerEvent('skinchanger:getSkin', function(skin)
			local uniformObject
			
			sex = (skin.sex == 0) and "male" or "female"

			uniformObject = Config.Uniforms[uniform][sex]

			if uniformObject then
				TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

				if uniform == 'bullet_wear' then
					SetPedArmour(playerPed, 100)
				end
			else
				ESX.ShowNotification(TranslateCap('no_outfit'))
			end
		end)
	else
		local elements = {
			{unselectable = true, icon = "fas fa-shirt", title = TranslateCap("cloakroom")},
		}
		for k,v in pairs(sub) do
			table.insert(elements, {
				icon = "fas fa-shirt",
				title = k,
			})
		end

		ESX.OpenContext("right", elements, function(menu,element)
			local data = {current = element}
			if data.current then
				local value = data.current.title
				ESX.CloseContext()

				local elements = {
					{unselectable = true, icon = "fas fa-shirt", title = TranslateCap("cloakroom")},
				}
				for k,v in pairs(sub[value]) do
					if ESX.PlayerData.job.grade >= v.grade then -- LUB MA LICKE - POZNIEJ
						table.insert(elements, {
							icon = "fas fa-shirt",
							title = k,
							male = v.male,
							female = v.female,
							armour = v.armour,
						})
					end
				end
				ESX.OpenContext("right", elements, function(menu2,element2)
					local data = {current = element2}

					if data.current then
						TriggerEvent('skinchanger:getSkin', function(skin)
							local uniformObject
			
							sex = (skin.sex == 0) and "male" or "female"
				
							uniformObject = data.current[sex]

							if uniformObject then
								SetPedArmour(playerPed, 0)
								if data.current.armour then
									SetPedArmour(playerPed, data.current.armour)
								end
								TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
							else
								ESX.ShowNotification(TranslateCap('no_outfit'))
							end
						end)
					end
				end, function(menu)
					setUniform(uniform, playerPed, sub)
				end)

			end
		end, function(menu)
			OpenCloakroomMenu()
		end)
	end
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{unselectable = true, icon = "fas fa-shirt", title = TranslateCap("cloakroom")},
	}
	for i = 1, #Config.UniformCategories do
		table.insert(elements, {
			icon = "fas fa-shirt",
			title = Config.UniformCategories[i].label,
			value = Config.UniformCategories[i].value,
			subcategory = Config.UniformCategories[i].subcategories
		})
	end

	ESX.OpenContext("right", elements, function(menu,element)
		cleanPlayer(playerPed)
		local data = {current = element}

		if data.current.value == 'civil' then
			ESX.CloseContext()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'fraction' then
			if data.current.subcategory then
				ESX.CloseContext()
				setUniform(data.current.value, playerPed, data.current.subcategory)
			else
				setUniform(data.current.value, playerPed)
			end
		elseif data.current.value == 'private' then
			print("TODO")
		end
	end)
end

function OpenPoliceActionsMenu()
	local elements = {
		{unselectable = true, icon = "fas fa-police", title = TranslateCap('menu_title')},
		{icon = "fas fa-car", title = TranslateCap('vehicle_interaction'), value = 'vehicle_interaction'},
		{icon = "fas fa-object", title = TranslateCap('object_spawner'), value = 'object_spawner'}
	}

	ESX.OpenContext("right", elements, function(menu,element)
		local data = {current = element}
		
		if data.current.value == 'vehicle_interaction' then
			local elements3  = {
				{unselectable = true, icon = "fas fa-car", title = element.title}
			}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				elements3[#elements3+1] = {icon = "fas fa-car", title = TranslateCap('vehicle_info'), value = 'vehicle_infos'}
				elements3[#elements3+1] = {icon = "fas fa-car", title = TranslateCap('pick_lock'), value = 'hijack_vehicle'}
				elements3[#elements3+1] = {icon = "fas fa-car", title = TranslateCap('impound'), value = 'impound'}
			end

			elements3[#elements3+1] = {
				icon = "fas fa-scroll",
				title = TranslateCap('search_database'), 
				value = 'search_database'
			}
			
			ESX.OpenContext("right", elements3, function(menu3,element3)
				local data2 = {current = element3}
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle(element3)
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(TranslateCap('vehicle_unlocked'))
						end
					elseif action == 'impound' then
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(TranslateCap('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Wait(100)
						end)

						CreateThread(function()
							while currentTask.busy do
								Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									ESX.ShowNotification(TranslateCap('impound_canceled_moved'))
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(TranslateCap('no_vehicles_nearby'))
				end
			end, function(menu)
				OpenPoliceActionsMenu()
			end)
		end
	end)
end

function LookupVehicle(elementF)
	local elements = {
		{unselectable = true, icon = "fas fa-car", title = elementF.title},
		{title = TranslateCap('search_plate'), input = true, inputType = "text", inputPlaceholder = "ABC 123"},
		{icon = "fas fa-check-double", title = TranslateCap('lookup_plate'), value = "lookup"}
	}

	ESX.OpenContext("right", elements, function(menu,element)
		local data = {value = menu.eles[2].inputValue}
		local length = string.len(data.value)
		if not data.value or length < 2 or length > 8 then
			ESX.ShowNotification(TranslateCap('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
				local elements = {
					{unselectable = true, icon = "fas fa-car", title = element.title},
					{unselectable = true, icon = "fas fa-car", title = TranslateCap('plate', retrivedInfo.plate)}			
				}

				if not retrivedInfo.owner then
					elements[#elements+1] = {unselectable = true, icon = "fas fa-user", title = TranslateCap('owner_unknown')}
				else
					elements[#elements+1] = {unselectable = true, icon = "fas fa-user", title = TranslateCap('owner', retrivedInfo.owner)}
				end

				ESX.OpenContext("right", elements, nil, function(menu)
					OpenPoliceActionsMenu()
				end)
			end, data.value)
		end
	end)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
		local elements = {
			{unselectable = true, icon = "fas fa-car", title = TranslateCap('vehicle_info')},
			{icon = "fas fa-car", title = TranslateCap('plate', retrivedInfo.plate)}
			
		}

		if not retrivedInfo.owner then
			elements[#elements+1] = {unselectable = true, icon = "fas fa-user", title = TranslateCap('owner_unknown')}
		else
			elements[#elements+1] = {unselectable = true, icon = "fas fa-user", title = TranslateCap('owner', retrivedInfo.owner)}
		end

		ESX.OpenContext("right", elements, nil, nil)
	end, vehicleData.plate)
end

--[[
RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = TranslateCap('phone_police'),
		number     = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)
-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.EnableESXService and not playerInService then
			CancelEvent()
		end
	end
end)
]]

-- Create blips
CreateThread(function()
	for k,v in pairs(Config.PoliceStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(TranslateCap('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

--[[KRIS - LICENCJE]]
function CheckLicense(name)
	local p = promise:new()

	ESX.TriggerServerCallback('esx_license:checkLicense', function(haslicense)
		p:resolve(haslicense)
	end, GetPlayerServerId(PlayerId()), name)

	return Citizen.Await(p)
end

--[[KRIS - SZAFKI]]
local function OpenEvidenceInv(PDStation) 
	local input = lib.inputDialog("Szafka ewidencyjna", {"Numer SSN"})

	if input then
		if exports.ox_inventory:openInventory('stash', PDStation..input[1]) == false then
			lib.callback.await('esx_policejob:CreateStash', false, PDStation, input[1])
			exports.ox_inventory:openInventory('stash', PDStation..input[1])
		else
			exports.ox_inventory:openInventory('stash', PDStation..input[1])
		end
	end
end

local function OpenFractionInv(PDStation, id)
	if exports.ox_inventory:openInventory('stash', PDStation..id) == false then
		lib.callback.await('esx_policejob:CreateFractionStash', false, PDStation, id)
		exports.ox_inventory:openInventory('stash', PDStation..id)
	else
		exports.ox_inventory:openInventory('stash', PDStation..id)
	end
end

function OpenDump()
	local id = lib.callback.await('esx_policejob:CreateTrashStash', false)
	exports.ox_inventory:openInventory('stash', id)
end

function OpenArmoryShop(type)
	exports.ox_inventory:openInventory('shop', {id=1, type="PD"..type})
end

--BossMenu
local function DepositMoney()
	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wpłać gotówkę"},
		{icon = "fas fa-wallet", title = "Kwota", input = true, inputType = "number", inputPlaceholder = "ilosc", inputMin = 1, inputMax = 250000, name = "Wplac"},
		{icon = "fas fa-check", title = "Potwierdz", value = "confirm"},
		{icon = "fas fa-arrow-left", title = "Wyjdz", value = "return"}
	}
	ESX.OpenContext("right", elements, function(menu,element)
		if element.value == "confirm" then
			local amount = tonumber(menu.eles[2].inputValue)
			if amount == nil then
				ESX.ShowNotification("Nieprawidlowa kwota")
			else
				TriggerServerEvent('esx_society:depositMoney', "police", amount)
				ESX.CloseContext()
			end
		elseif element.value == "return" then
			ESX.CloseContext()
			return
		end
	end)
end

local function WithdrawMoney()
	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wypłać gotówkę"},
		{icon = "fas fa-wallet", title = "Kwota", input = true, inputType = "number", inputPlaceholder = "ilosc", inputMin = 1, inputMax = 250000, name = "Wplac"},
		{icon = "fas fa-check", title = "Potwierdz", value = "confirm"},
		{icon = "fas fa-arrow-left", title = "Wyjdz", value = "return"}
	}
	ESX.OpenContext("right", elements, function(menu,element)
		if element.value == "confirm" then
			local amount = tonumber(menu.eles[2].inputValue)
			if amount == nil then
				ESX.ShowNotification("Nieprawidlowa kwota")
			else
				TriggerServerEvent('esx_society:withdrawMoney', "police", amount)
				ESX.CloseContext()
			end
		elseif element.value == "return" then
			ESX.CloseContext()
			return
		end
	end)
end

--GARAZE
local function OpenVehicleList(category, spawnpoints)
	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wybierz pojazd"}
	}

	local vehicles = lib.callback.await("esx_policejob:GetVehicles", false, category)

	for k, v in pairs(vehicles) do
		local props = json.decode(v.vehicle)

		if Config.Vehicles.AuthorizedVehicles[props.model] ~= nil then
			if (Config.Vehicles.AuthorizedVehicles[props.model].grade == nil and true or (Config.Vehicles.AuthorizedVehicles[props.model].grade <= ESX.PlayerData.job.grade)) then
				if v.stored == 1 then
					table.insert(elements, {
						icon = "fas fa-user", title = "<span style='color: lime;'>"..Config.Vehicles.AuthorizedVehicles[props.model].label.."</span> | Tablica: "..v.plate.." | Paliwo: "..props.fuelLevel.."%".." | Stan karoserii: "..(props.bodyHealth/10).."% | Stan silnika: "..(props.engineHealth/10).."%".." | SSN ostatniego kierowcy: "..(v.last_driver ~= nil and v.last_driver or "BRAK"), value = k, props = props
					})
				else
					table.insert(elements, {
						unselectable = true, icon = "fas fa-user", title = "<span style='color: red;'>"..Config.Vehicles.AuthorizedVehicles[props.model].label.."</span> | Tablica: "..v.plate.." | Paliwo: "..props.fuelLevel.."%".." | Stan karoserii: "..(props.bodyHealth/10).."% | Stan silnika: "..(props.engineHealth/10).."%".." | SSN ostatniego kierowcy: "..(v.last_driver ~= nil and v.last_driver or "BRAK"), value = k, props = props
					})
				end
			end
		end
	end

	CreateThread(function()
		ESX.OpenContext("right", elements, function(menu,element)
			if element.value then
				for i = 1, #spawnpoints do
					if ESX.Game.IsSpawnPointClear(spawnpoints[i].coords, spawnpoints[i].radius) then
						ESX.Game.SpawnVehicle(element.props.model, spawnpoints[i].coords, spawnpoints[i].heading, function(vehicle)
							ESX.ShowNotification("Pobrano pojazd", "info", 2000)
							ESX.Game.SetVehicleProperties(vehicle, element.props)
							TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
							ESX.CloseContext()
							TriggerServerEvent("esx_policejob:SetVehicleInAndOutOfGarage", element.props.plate, false)
						end)
						return
					end
				end
			end
		end)
	end)
end

local function OpenGarageMenu(spawnpoints)
	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wybierz kategorie"}
	}
	for k, v in pairs(Config.Vehicles.Categories) do
		-- Jeżeli licencja i grade sa ustawione to sprawdz
		print(json.encode(v))
		if (v.license == nil and true or CheckLicense(v.license)) and (v.grade == nil and true or (ESX.PlayerData.job.grade >= v.grade)) then
			table.insert(elements, {
				icon = "fas fa-car", title = k, value = k, perms = v
			})
		end
	end
	ESX.OpenContext("right", elements, function(menu,element)
		if element.value then
			OpenVehicleList(element.value, spawnpoints)
			ESX.CloseContext()
		else
			ESX.CloseContext()
			return
		end
	end)
end

local function HideCurrentVehicle()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if Config.Vehicles.AuthorizedVehicles[GetEntityModel(vehicle)] ~= nil then
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

		ESX.Game.DeleteVehicle(vehicle)
		TriggerServerEvent("esx_policejob:SetVehicleInAndOutOfGarage", vehicleProps.plate, true, vehicleProps)
	end
end

local function ImpoundMenu()
	local vehicles = lib.callback.await("esx_policejob:GetImpoundVehicles", false)

	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wybierz pojazd"},
	}

	for k, v in pairs(vehicles) do
		local props = json.decode(v.vehicle)

		table.insert(elements, {
			icon = "fas fa-user", title = "<span style='color: lime;'>"..Config.Vehicles.AuthorizedVehicles[props.model].label.."</span> | Tablica: "..v.plate.." | Paliwo: "..props.fuelLevel.."%".." | Stan karoserii: "..(props.bodyHealth/10).."% | Stan silnika: "..(props.engineHealth/10).."%".." | SSN ostatniego kierowcy: "..(v.last_driver ~= nil and v.last_driver or "BRAK"), value = v.plate
		})
	end

	ESX.OpenContext("right", elements, function(menu,element)
		if element.value then
			ESX.CloseContext()
			local vehiclePool = GetGamePool("CVehicle")

			for i = 1, #vehiclePool do
				if GetVehicleNumberPlateText(vehiclePool[i]) == element.value then
					for j = -1, GetVehicleMaxNumberOfPassengers(vehiclePool[i]), 1 do
						if GetPedInVehicleSeat(vehiclePool[i], j) ~= 0 then
							return (ESX.ShowNotification("Pojazd jest w użytku!"))
						end
					end
					DeleteVehicle(vehiclePool[i])
					break;
				end
			end

			TriggerServerEvent("esx_policejob:ImpoundVehicle", element.value)
			ESX.ShowNotification("Odholowano pojazd!")
		end
	end)
end

BadgesMenu = function()
	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wybierz kategorie"},
		{title = 'Daj Odznakę', icon = "fas fa-user", value = 'give'},
		{title = 'Zabierz odznakę', icon = "fas fa-user", value = 'remove'},
		{title = 'Edytuj odznaki', icon = "fas fa-user", value = 'edit'},
	} 

	ESX.OpenContext("right", elements, function(menu,element)
		if element.value == 'give' then
			local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestPlayerDistance > 3.0 then 
				ESX.ShowNotification("Brak graczy w poblizu")
				ESX.CloseContext()
				return
			end

			local elements2 = {
				{unselectable = true, icon = "fas fa-user", title = "Wybierz rodzaj (dla id: "..GetPlayerServerId(closestPlayer)..")"},
				{title = 'odznaka', icon = "fas fa-user", value = 'badge'},
				{title = 'legitymacja', icon = "fas fa-user", value = 'legit'},
				{title = 'licencja', icon = "fas fa-user", value = 'license'},
				{title = 'identyfikator', icon = "fas fa-user", value = 'id'},
			}

			ESX.OpenContext("right", elements2, function(menu,element)
				if element.value then
					local name = lib.inputDialog("Nazwa", {"Do wpisania (przykładowo Policjanta, Szeryfa, Medyka)"})

					if name then
						local number = lib.inputDialog("Numer", {"Do wpisania (przykładowo Yankee-01)"})
						if number then
							local grade = lib.inputDialog("Stopien", {"Do wpisania (przykładowo Oficer I, Lekarz etc)"})
							if grade then
								local anon = lib.inputDialog("Anonimowość", {
									{type = "checkbox", label = "Anonimowość", description = "gdy zaznaczymy to nie pokazuje imienia i nazwiska"}
								})
								if anon then
									local default = lib.inputDialog("Domyslna", {
										{type = "checkbox", label = "Domyslna", description = "gdy zaznaczyny tą opcje to ta odznaka pokazuje się pod bindem"}
									})
									if default then
										local data = {
											type = element.value,
											name = name[1], 
											number = number[1], 
											grade = grade[1], 
											anon = (anon[1] == true and true or false),
											default = (default[1] == true and true or false)
										}
										TriggerServerEvent("hp_badges:AddUserBadge", GetPlayerServerId(closestPlayer), data)
									end
								end
							end
						end
					end
				end
			end)
		elseif element.value == 'remove' then
			local employees = lib.callback.await('esx_policejob:GetEmployees', false, ESX.PlayerData.job.name)
			local elements2 = {
				{unselectable = true, icon = "fas fa-user", title = "Wybierz pracownika"}
			}

			for k, v in pairs(employees) do
				table.insert(elements2, {
					title = v.firstname.." "..v.lastname,
					value = v.identifier
				})
			end

			ESX.OpenContext("right", elements2, function(menu,element)
				if element.value then
					local badges = json.decode(lib.callback.await('esx_policejob:GetEmployeeBadges', false, element.value))
					local elements3 = {
						{unselectable = true, icon = "fas fa-user", title = "Wybierz odznake"}
					}
					for k, v in pairs(badges) do
						table.insert(elements3, {
							title = "Typ: "..v.type..", Nazwa: "..v.name..", Numer: "..v.number..", Stopień: "..v.grade..", Anonimowa: "..(v.anon == true and "Tak" or "Nie"),
							value = k
						})
					end

					ESX.OpenContext("right", elements3, function(menu,element2)
						if element2.value then
							TriggerServerEvent("hp_badges:RemoveUserBadge", element.value, element2.value)
							ESX.ShowNotification("Usunieto odznake")
							ESX.CloseContext()
						end
					end)
				end
			end)
		elseif element.value == 'edit' then
			local employees = lib.callback.await('esx_policejob:GetEmployees', false, ESX.PlayerData.job.name)
			local elements2 = {
				{unselectable = true, icon = "fas fa-user", title = "Wybierz pracownika"}
			}

			for k, v in pairs(employees) do
				table.insert(elements2, {
					title = v.firstname.." "..v.lastname,
					value = v.identifier
				})
			end

			ESX.OpenContext("right", elements2, function(menu,element)
				if element.value then
					local badges = json.decode(lib.callback.await('esx_policejob:GetEmployeeBadges', false, element.value))
					local elements3 = {
						{unselectable = true, icon = "fas fa-user", title = "Wybierz odznake"}
					}
					for k, v in pairs(badges) do
						table.insert(elements3, {
							title = "Typ: "..v.type..", Nazwa: "..v.name..", Numer: "..v.number..", Stopień: "..v.grade..", Anonimowa: "..(v.anon == true and "Tak" or "Nie"),
							value = k,
							values = v
						})
					end

					ESX.OpenContext("right", elements3, function(menu,element3)
						if element3.value then
							local elements4 = {
								{unselectable = true, icon = "fas fa-user", title = "Wybierz właściwość"},
								{icon = "fas fa-user", title = "Nazwa "..element3.values.name, value = "name"},
								{icon = "fas fa-user", title = "Numer "..element3.values.number, value = "number"},
								{icon = "fas fa-user", title = "Stopień "..element3.values.grade, value = "grade"},
								{icon = "fas fa-user", type = "checkbox", title = "Anonimowa "..(element3.values.anon == true and "Tak" or "Nie"), value = "anon"},
								{icon = "fas fa-user", type = "checkbox", title = "Defaultowa "..(element3.values.default == true and "Tak" or "Nie"), value = "default"},
								{icon = "fas fa-user", title = "Zapisz", value = "save"}
							}
							local data = {
								type = element3.values.type,
								name = element3.values.name, 
								number = element3.values.number, 
								grade = element3.values.grade, 
								anon = (element3.values.anon == true and true or false), 
								default = (element3.values.default == true and true or false)
							}

							ESX.OpenContext("right", elements4, function(menu,element4)
								if element4.value ~= "save" then
									if element4.type == "checkbox" then
										data[element4.value] = lib.inputDialog(element4.value, {
											{type = "checkbox", label = element4.value}
										})[1]
									else
										data[element4.value] = lib.inputDialog(element4.value, {element4.value})[1]
									end
								else
									TriggerServerEvent("hp_badges:EditUserBadge", element.value, element3.value, data)
									ESX.CloseContext()
								end
							end)
						end
					end)
				end
			end)
		end
	end)
end

LicenseMenu = function()
	local elements = {
		{unselectable = true, icon = "fas fa-user", title = "Wybierz kategorie"},
		{title = 'Nadaj licencje', icon = "fas fa-user", value = 'give'},
		{title = 'Zabierz licencje', icon = "fas fa-user", value = 'remove'},
	} 

	ESX.OpenContext("right", elements, function(menu,element)
		if element.value == "give" then
			local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestPlayerDistance > 3.0 then 
				ESX.ShowNotification("Brak graczy w poblizu")
				ESX.CloseContext()
				return
			end

			local elements = {
				{unselectable = true, icon = "fas fa-user", title = "Wybierz licencje (Gracz: "..GetPlayerServerId(closestPlayer)..")"},
			} 
			for k, v in pairs(Config.AuthorizedLicenses) do
				table.insert(elements, {title = v, value = k})
			end

			ESX.OpenContext("right", elements, function(menu,element)
				if element.value then
					TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), element.value)
					ESX.CloseContext()
					ESX.ShowNotification("Nadano licencje "..element.value.." graczu o id:"..GetPlayerServerId(closestPlayer))
				end
			end)
		elseif element.value == "remove" then 
			local employees = lib.callback.await('esx_policejob:GetEmployees', false, ESX.PlayerData.job.name)
			local elements = {
				{unselectable = true, icon = "fas fa-user", title = "Wybierz pracownika"}
			}

			for k, v in pairs(employees) do
				table.insert(elements, {
					title = v.firstname.." "..v.lastname,
					value = v.identifier
				})
			end

			ESX.OpenContext("right", elements, function(menu,element)
				if element.value then
					local licenses = lib.callback.await('esx_policejob:GetEmployeeLicenses', false, element.value)
					local elements2 = {
						{unselectable = true, icon = "fas fa-user", title = "Wybierz licencje"}
					}

					for k,v in pairs(licenses) do
						table.insert(elements2, {value = v.id, title = v.type})
					end

					ESX.OpenContext("right", elements2, function(menu,element2)
						if element2.value then
							local removed = lib.callback.await('esx_policejob:RemoveEmployeeLicense', false, element.value, element2.value, element2.title)
							print(removed)
							if removed then
								ESX.CloseContext()
								ESX.ShowNotification("Usunieto licencje ")
							end
						end
					end)
				end
			end)
		end
	end)
end

CreateThread(function()
	for k,v in pairs(Config.PoliceStations) do
		local PDStation = k
		-- Szafki
		for k,v in pairs(v.Stashes) do
			if v.evidence then
				exports.ox_target:addBoxZone({
					coords = v.target.loc,
					size = vector3(v.target.width, v.target.length,v.target.height),
					options = {
						{
							name = "evidence"..PDStation..k,
							icon = 'fa-regular fa-id-badge',
							label = "Szafka SSN",
							groups = "police",
							distance = 3,
							onSelect = function()
								OpenEvidenceInv(PDStation) 
							end
						}
					}
				})
			else
				exports.ox_target:addBoxZone({
					coords = v.target.loc,
					size = vector3(v.target.width, v.target.length,v.target.height),
					options = {
						{
							name = "fraction"..PDStation..k,
							icon = 'fa-regular fa-id-badge',
							label = "Szafka Frakcyjna",
							groups = "police",
							distance = 3,
							onSelect = function()
								OpenFractionInv(PDStation, k) 
							end
						}
					}
				})
			end
		end
		-- Przebieralnia
		for k, v in pairs(v.Cloakrooms) do
			exports.ox_target:addBoxZone({
				coords = v.location,
				size = v.size,
				options = {
					{
						name = "cloakroom"..PDStation..k,
						icon = 'fa-regular fa-id-badge',
						label = "Szatnia Frakcyjna",
						groups = "police",
						distance = 3,
						onSelect = function()
							OpenCloakroomMenu() 
						end
					}
				}
			})
		end
		-- Zbrojownia
		for k, v in pairs(v.Armories) do
			exports.ox_target:addBoxZone({
				coords = v.location,
				size = v.size,
				options = v.data
			})
		end
		-- Boss menu
		for k, v in pairs(v.BossActions) do
			exports.ox_target:addBoxZone({
				coords = v.coords,
				size = v.size,
				options = {
					{
						name = "bossmenu"..PDStation..k,
						label = "Boss Menu",
						groups = {
							["police"] = v.grade,
						},
						distance = 3,
						onSelect = function()
							ESX.CloseContext()
							TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
								--menu.close()
							end, { wash = false }) -- disable washing money
						end,
						canInteract = function()
							if ESX.PlayerData.job.grade_name == 'boss' then
								return true
							end
						end
					},
					{
						name = "badges"..PDStation..k,
						label = "Odznaki (WIP)",
						groups = {
							["police"] = 4,
						},
						distance = 3,
						onSelect = function()
							BadgesMenu()
						end,
						canInteract = function()
							if ESX.PlayerData.job.grade_name == 'boss' then
								return true
							end
						end
					},
					{
						name = "licenses"..PDStation..k,
						label = "Licencje (WIP)",
						groups = {
							["police"] = 4,
						},
						distance = 3,
						onSelect = function()
							LicenseMenu()
						end,
						canInteract = function()
							if ESX.PlayerData.job.grade_name == 'boss' then
								return true
							end
						end
					},
					{
						name = "putmoney"..PDStation..k,
						label = "Wpłać pieniądze",
						groups = "police",
						distance = 3,
						onSelect = function()
							DepositMoney()
						end
					},
					{
						name = "getmoney"..PDStation..k,
						label = "Wypłać pieniądze",
						groups = {
							["police"] = 4,
						},
						distance = 3,
						onSelect = function()
							WithdrawMoney()
						end,
						canInteract = function()
							if ESX.PlayerData.job.grade_name == 'boss' then
								return true
							end
						end
					},
				}
			})
		end
		-- Veh menu
		for k, v in pairs(v.Vehicles) do
			exports.ox_target:addBoxZone({
				coords = v.coords,
				size = v.size,
				options = {
					{
						name = "PDgetvehicle"..PDStation..k,
						label = "Pobierz pojazd",
						groups = "police",
						distance = 3,
						onSelect = function()
							OpenGarageMenu(v.SpawnPoints)
						end
					}
				}
			})
		end
		for k, v in pairs(v.Garages) do
			lib.zones.box({
				coords = v.coords,
				size = v.size,
				rotation = 15,
				inside = function()
					if IsControlJustPressed(0, 38) then
						HideCurrentVehicle()
					end
				end
			})
			exports.ox_target:addBoxZone({
				coords = v.coords,
				size = v.size,
				options = {
					{
						name = "PDgarage"..PDStation..k,
						label = "Pobierz pojazd",
						groups = "police",
						distance = 3,
						onSelect = function()
							OpenGarageMenu(v.SpawnPoints)
						end
					}
				}
			})
		end
		for k, v in pairs(v.Impounds) do
			exports.ox_target:addBoxZone({
				coords = v.coords,
				size = v.size,
				options = {
					{
						name = "PDimpoundvehicle"..PDStation..k,
						label = "Odholuj pojazd",
						groups = "police",
						distance = 3,
						onSelect = function()
							ImpoundMenu()
						end
					}
				}
			})
		end
	end
end)

local ents = {
	[`prop_roadcone02a`] = "Stożek drogowy",
	[`prop_barrier_work05`] = "barierka",
	[`p_ld_stinger_s`] = "kolczatka",
}

local registered = false
function PlaceableObjectsRadial()
	if not registered then
		local items = {}
		for k,v in pairs(ents) do
			table.insert(items, {
				icon = "fas fa-box",
				label = v,
				keepOpen = true,
				onSelect = function()
					local playerPed = PlayerPedId()
					local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
					local objectCoords = (coords + forward * 1.0)
		
					ESX.Game.SpawnObject(k, objectCoords, function(obj)
						SetEntityHeading(obj, GetEntityHeading(playerPed))
						PlaceObjectOnGroundProperly(obj)
					end)
				end
			})
		end
		lib.registerRadial({
			id = "placeobject",
			items = items
		})
		registered = true
	end
end

local removableents = { 
	`prop_roadcone02a`, 
	`prop_barrier_work05`, 
	`p_ld_stinger_s`
}

local added = false
function AddTargetRemoval()
	if not added then
		exports.ox_target:addModel(removableents, {
			{
				label = "Usun obiekt",
				name = "removeobject",
				icon = "fa-trash",
				onSelect = function(data)
					if data.distance < 2.5 then
						DeleteEntity(data.entity)
					end
				end,
				canInteract = function()
					if ESX.PlayerData.job.name == "police" then
						return true
					end
				end
			},
			{
				label = "Obroc obiekt",
				name = "rotateobject",
				icon = "fa-trash",
				onSelect = function(data)
					if data.distance < 2.5 then
						SetEntityHeading(data.entity, GetEntityHeading(data.entity)+22.5)
					end
				end,
				canInteract = function()
					if ESX.PlayerData.job.name == "police" then
						return true
					end
				end
			},
		})
		added = true
	end
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	if job.name == 'police' then
		Wait(1000)
		AddTargetRemoval()
		PlaceableObjectsRadial()
	end
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	isDead = false

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

--[[
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(TranslateCap('impound_successful'))
	currentTask.busy = false
end]]

RegisterCommand("esx_policejob:BuyVehicle", function()
    ESX.TriggerServerCallback("hp_badges:isAdmin", function(cb)
        if cb then
			local elements = {
				{unselectable = true, icon = "fas car", title = "Wybierz pojazd"},
			}
			for k, v in pairs(Config.Vehicles.AuthorizedVehicles) do
				table.insert(elements, {
					title = GetDisplayNameFromVehicleModel(k).." | "..v.label.." "..v.price.."$",
					value = k
				})
			end

			ESX.OpenContext("right", elements, function(menu,element)
				if element.value then
					local input = lib.inputDialog('Wpisz kategorie', {
						{type = "input", label = 'Nazwa kategorii', placeholder = Config.Vehicles.AuthorizedVehicles[element.value].DefaultCategory}
					})
					if input and (Config.Vehicles.Categories[input[1]] ~= nil) then
						local PlayerPed = PlayerPedId()
						local PlayerCoords = GetEntityCoords(PlayerPed)

						ESX.Game.SpawnLocalVehicle(element.value, vector3(405.4063, -954.6062, -99.0042), 177.8206, function(vehicle)
							TaskWarpPedIntoVehicle(PlayerPed, vehicle, -1)

							local elements2 = {
								{unselectable = true, icon = "fas car", title = "Pojazd: "..GetDisplayNameFromVehicleModel(element.value).." Cena: "..Config.Vehicles.AuthorizedVehicles[element.value].price.." Kategoria: "..input[1]},
								{icon = "fas car", title = "Potwierdz ✅", value = "accept"},
								{icon = "fas car", title = "Anuluj ❌", value = "reject"},
							}

							ESX.OpenContext("right", elements2, function(menu2,element2)
								if element2.value == "accept" then
									local newPlate = exports['hp_vehicleshop']:GeneratePlate()
									local vehProperties = ESX.Game.GetVehicleProperties(vehicle)
									vehProperties.plate    = newPlate

									local bought = lib.callback.await("esx_policejob:BuyVehicle", false, element.value, vehProperties, Config.Vehicles.AuthorizedVehicles[element.value].price, input[1])

									if bought then
										if bought ~= "limit" then
											DeleteVehicle(vehicle)
											SetEntityCoords(PlayerPed, PlayerCoords)
											ESX.ShowNotification("Zakupiono pojazd!")
											return (ESX.CloseContext())
										else
											DeleteVehicle(vehicle)
											SetEntityCoords(PlayerPed, PlayerCoords)
											ESX.ShowNotification("Osiagnieto limit pojazdow! Sprawdz config!")
											return (ESX.CloseContext())
										end
									else
										DeleteVehicle(vehicle)
										SetEntityCoords(PlayerPed, PlayerCoords)
										ESX.ShowNotification("Brak srodkow!")
										return (ESX.CloseContext())
									end
								elseif element2.value == "reject" then
									DeleteVehicle(vehicle)
									SetEntityCoords(PlayerPed, PlayerCoords)
									ESX.ShowNotification("Anulowano!")
									return (ESX.CloseContext())
								end
							end)
						end)
					end
				end
			end)
        else
            ESX.ShowNotification("Brak uprawnień", "error")
        end
    end)
end)

RegisterCommand("esx_policejob:AddLicense", function(source, args)
    ESX.TriggerServerCallback("hp_badges:isAdmin", function(cb)
        if cb then
			TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(PlayerId()), args[1])
        else
            ESX.ShowNotification("Brak uprawnień", "error")
        end
    end)
end)

--Exporty
exports("BadgesMenu", BadgesMenu) -- Menu odznak (nadawanie, edytowanie, usuwanie)
exports("LicenseMenu", LicenseMenu) -- Menu licencji (nadawanie, usuwanie)
exports("CheckLicense", function(license_name)
	CheckLicense(license_name)
end) -- Sprawdzanie czy gracz posiada licencje