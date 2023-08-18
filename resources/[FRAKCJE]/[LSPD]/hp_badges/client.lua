ESX = exports["es_extended"]:getSharedObject()
local badges = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    local badgesdata = lib.callback.await("hp_badges:recieveBadges")

    badges = json.decode(badgesdata)

    for k, v in pairs(badges) do
        if v.default == true then
            TriggerServerEvent("hp_badges:setDefaultBadge", v.number)
            break;
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("hp_badges:AddBadge", function(data)
    if data.default == true then
        for k, v in pairs(badges) do
            v.default = false
        end
    end

    table.insert(badges, {
        type = data.type,
        name = data.name,
        number = data.number,
        grade = data.grade,
        anon = data.anon,
        default = data.default,
    })

    TriggerServerEvent("hp_badges:UpdateUserBadges", json.encode(badges))
end)

RegisterNetEvent("hp_badges:RemoveBadge", function(badgeid)
    --badges[badgeid] = nil
    if badges[badgeid].default then
        table.remove(badges, badgeid)
        TriggerServerEvent("hp_badges:UpdateUserBadges", json.encode(badges), true)
    else
        table.remove(badges, badgeid)
        TriggerServerEvent("hp_badges:UpdateUserBadges", json.encode(badges))
    end
end)

RegisterNetEvent("hp_badges:EditBadge", function(badgeid, data)
    print(data.default)
    if data.default == true then
        for k, v in pairs(badges) do
            v.default = false
        end
    end

    badges[badgeid] = data

    TriggerServerEvent("hp_badges:UpdateUserBadges", json.encode(badges))
end)

ShowDefaultBadge = function()
    if Config.AuthorizedJobs[ESX.PlayerData.job.name] ~= true or #badges < 1 then return end

    for k, v in pairs(badges) do
        if v.default == true then
            return (ShowBadge(v))
        end
    end
    return (ESX.ShowNotification("Nie posiadasz Defaultowej odznaki! Znajdz odznake pod Menu serwerowym!", "error", 4000))
end

local currentlyShowing = false

ShowBadge = function(badge)
    if Config.AuthorizedJobs[ESX.PlayerData.job.name] ~= true or currentlyShowing then return end
    local PlayerPed = PlayerPedId()
    local model = `prop_fib_badge`
    currentlyShowing = true

    Citizen.CreateThread(function()
        RequestAnimDict('paper_1_rcm_alt1-9')
        while not HasAnimDictLoaded('paper_1_rcm_alt1-9') do		
            Citizen.Wait(0)
        end

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

        local coords = GetEntityCoords(PlayerPed, true)
		local object = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
        SetModelAsNoLongerNeeded(model)

        TriggerServerEvent("hp_badges:DisplayBadgeInChat", badge)

        AttachEntityToEntity(object, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.115, -0.011, -0.045, 90.0, 90.0, 60.0, true, true, false, false, 2, true)
        TaskPlayAnim(PlayerPed, 'paper_1_rcm_alt1-9', 'player_one_dual-9', 0.8, -0.8, -1, 48, 0.0, 0, 0, 0)
        Citizen.Wait(3000)

        DeleteObject(object)
        Citizen.Wait(500)
        StopAnimTask(PlayerPed, 'paper_1_rcm_alt1-9', 'player_one_dual-9', 1.0)
        currentlyShowing = false
    end)
end

BadgeMenu = function()
    if Config.AuthorizedJobs[ESX.PlayerData.job.name] ~= true then return end
    if #badges < 1 then return (ESX.ShowNotification("Nie posiadasz zadnych odznak!", "error", 4000)) end

    local elements = {}
    for i = 1, #badges, 1 do
        if badges[i] ~= nil then
            table.insert(elements, {label = badges[i].type.." | "..badges[i].name.." | "..badges[i].number, value = badges[i]})
        end
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Badge_Menu", {
        title = "Menu Odznak",
        align    = 'bottom-right',
        elements = elements
    }, function(data,menu)
        if data.current.value then
            ShowBadge(data.current.value)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterCommand("badgeMenu", function()
    ShowDefaultBadge()
end)

exports("BadgeMenu", BadgeMenu)

RegisterKeyMapping("badgeMenu", "Otwórz menu odznak", "keyboard", "I")

--[[
RegisterCommand("badgeTest", function()
    TriggerServerEvent("hp_badges:AddUserBadge", GetPlayerServerId(PlayerId()), {
        type = "id",
        name = "Policjanta",
        number = "Yankee-01",
        grade = "Oficer I",
        anon = true,
        default = false,
    })
end)
]]

RegisterCommand("hp_badges:AddBadge", function(source)
    ESX.TriggerServerCallback("hp_badges:isAdmin", function(cb)
        if cb then
            local elements2 = {
				{unselectable = true, icon = "fas fa-user", title = "Wybierz rodzaj"},
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
										TriggerServerEvent("hp_badges:AddUserBadge", GetPlayerServerId(PlayerId()), data)
									end
								end
							end
						end
					end
				end
			end)
        else
            ESX.ShowNotification("Brak uprawnień", "error")
        end
    end)
end)

exports("GetDefaultBadge", function()
    for k, v in pairs(badges) do
        if v.default == true then
            return v
        end
    end
    return nil
end)