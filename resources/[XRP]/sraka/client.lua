ESX = exports["es_extended"]:getSharedObject()



RegisterCommand("test34", function(source, args, rawCommand)
    print(math.ceil(4.5))
end, true) -- set this to false to allow anyone.

RegisterCommand("test2", function(source, args, rawCommand)
	local pozycja = GetEntityCoords(PlayerPedId())
	local kordy = vector3(546.326233, 2662.804688, 42.156551)
	print(#(pozycja - kordy))
end, true)



inspectingVeh = false
gotSpots = false
inspectSpots = {}

AddEventHandler('heaven:checkCar', function()
    if ESX.PlayerData.job.name == 'mechanic' then
        local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
        print(vehicle)
    else
        ESX.ShowNotification("Nie jesteś mechanikiem, ciężko określić co jest z pojazdem", "error", 2500)
    end
end)





local carry = {
    InProgress = false,
    targetSrc = -1,
    type = "",
    personCarrying = {
        animDict = "missfinale_c2mcs_1",
        anim = "fin_c2_mcs_1_camman",
        flag = 49,
    },
    personCarried ={
        animDict = "nm",
        anim = "firemans_carry",
        attachX = 0.27,
        attachY = 0.15,
        attachZ = 0.63,
        flag = 33,
    }
}

local function GetCLosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(10)
        end
    end
    return animDict
end

RegisterNetEvent("xrp_carry:carryingFaggot")
AddEventHandler("xrp_carry:carryingFaggot", function(targetSrc)
    if not carry.InProgress then
		if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
		local closestPlayer = ESX.Game.GetClosestPlayer()
        print(closestPlayer)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				carry.InProgress = true
				carry.targetSrc = targetSrc
				TriggerServerEvent("xrp_carry:sync",targetSrc)
				ensureAnimDict(carry.personCarrying.animDict)
				carry.type = "carrying"
			else
				ESX.ShowNotification("Nie masz kogo podnieść!")
			end
		else
			ESX.ShowNotification("Nie masz kogo podnieść!")
		end
	end
	else
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("xrp_carry:stop",carry.targetSrc)
		carry.targetSrc = 0
	end  
end)


RegisterCommand("podnies", function(source, args)
    if not carry.InProgress then
		if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
		local closestPlayer = ESX.Game.GetClosestPlayer()
        print(closestPlayer)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				carry.InProgress = true
				carry.targetSrc = targetSrc
				TriggerServerEvent("xrp_carry:sync",targetSrc)
				ensureAnimDict(carry.personCarrying.animDict)
				carry.type = "carrying"
			else
				ESX.ShowNotification("Nie masz kogo podnieść!")
			end
		else
			ESX.ShowNotification("Nie masz kogo podnieść!")
		end
	end
	else
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("xrp_carry:stop",carry.targetSrc)
		carry.targetSrc = 0
	end  
end, false)

RegisterNetEvent("xrp_carry:syncTarget")
AddEventHandler("xrp_carry:syncTarget", function(targetSrc)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	carry.InProgress = true
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	carry.type = "beingcarried"
end)

RegisterNetEvent("xrp_carry:cl_stop")
AddEventHandler("xrp_carry:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if carry.InProgress then
			if carry.type == "beingcarried" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
			elseif carry.type == "carrying" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
			end
		end
		Wait(100)
	end
end)


-- siedzenie


local chairs = {
	`prop_bench_01a`, 		
	`prop_bench_01b`, 		
	`prop_bench_01c`, 		
	`prop_bench_02`, 		
	`prop_bench_03`, 		
	`prop_bench_04`, 		
	`prop_bench_05`, 		
	`prop_bench_06`, 		
	`prop_bench_07`, 				
	`prop_bench_08`, 		
	`prop_bench_09`, 				
	`prop_bench_10`, 		
	`prop_bench_11`, 		
	`prop_fib_3b_bench`, 	
	`prop_ld_bench01`, 	
	`prop_wait_bench_01`, 	
	`v_club_stagechair`, 	
	`hei_prop_heist_off_chair`,
	`hei_prop_hei_skid_chair`,
	`prop_chair_01a`, 		
	`prop_chair_01b`, 		
	`prop_chair_02`, 		
	`prop_chair_03`, 		
	`prop_chair_04a`,		
	`prop_chair_04b`, 		
	`prop_chair_05`, 		
	`prop_chair_06`, 		
	`prop_chair_07`, 		
	`prop_chair_08`, 		
	`prop_chair_09`, 		
	`prop_chair_10`, 		
	`prop_chateau_chair_01`, 
	`prop_clown_chair`, 	
	`prop_cs_office_chair`, 
	`prop_direct_chair_01`, 
	`prop_direct_chair_02`, 
	`prop_gc_chair02`, 	
	`prop_off_chair_01`, 	
	`prop_off_chair_03`, 	
	`prop_off_chair_04`, 	
	`prop_off_chair_04b`, 	
	`prop_off_chair_04_s`, 
	`prop_off_chair_05`, 			
	`prop_old_deck_chair`, 
	`prop_old_wood_chair`, 
	`prop_rock_chair_01`, 	
	`prop_skid_chair_01`, 	
	`prop_skid_chair_02`, 	
	`prop_skid_chair_03`, 	
	`prop_sol_chair`, 		
	`prop_wheelchair_01`, 	
	`prop_wheelchair_01_s`, 
	`p_armchair_01_s`,	
	`p_clb_officechair_s`, 
	`p_dinechair_01_s`, 	
	`p_ilev_p_easychair_s`, 
	`p_soloffchair_s`, 	
	`p_yacht_chair_01_s`, 	
	`v_club_officechair`, 	
	`v_corp_bk_chair3`, 	
	`v_corp_cd_chair`, 	
	`v_corp_offchair`, 	
	`v_ilev_chair02_ped`, 	
	`v_ilev_hd_chair`, 	
	`v_ilev_p_easychair`, 	
	`v_ret_gc_chair03`, 	
	`prop_ld_farm_chair01`,
	`prop_table_04_chr`, 			
	`prop_table_05_chr`,	
	`prop_table_06_chr`, 	
	`v_ilev_leath_chr`, 	
	`prop_table_01_chr_a`, 
	`prop_table_01_chr_b`, 
	`prop_table_02_chr`, 	
	`prop_table_03b_chr`, 	
	`prop_table_03_chr`, 	
	`prop_torture_ch_01`, 	
	`v_ilev_fh_dineeamesa`, 
	`v_ilev_tort_stool`, 	
	`v_ilev_fh_kitchenstool`, 
	`hei_prop_yah_seat_01`,
	`hei_prop_yah_seat_02`, 
	`hei_prop_yah_seat_03`, 
	`prop_waiting_seat_01`, 
	`prop_yacht_seat_01`, 	
	`prop_yacht_seat_02`, 	
	`prop_yacht_seat_03`, 	
	`prop_hobo_seat_01`, 		
	`prop_rub_couch01`, 	
	`miss_rub_couch_01`, 	
	`prop_ld_farm_couch01`,
	`prop_ld_farm_couch02`, 
	`prop_rub_couch02`, 	
	`prop_rub_couch03`, 	
	`prop_rub_couch04`, 	
	`p_lev_sofa_s`,	
	`p_res_sofa_l_s`, 		
	`p_v_med_p_sofa_s`, 	
	`p_yacht_sofa_01_s`, 	
	`v_ilev_m_sofa`, 		
	`v_res_tre_sofa_s`, 	
	`v_tre_sofa_mess_a_s`, 
	`v_tre_sofa_mess_b_s`, 
	`v_tre_sofa_mess_c_s`, 
	`prop_roller_car_01`,
	`prop_roller_car_02`,
	`v_ret_gc_chair02`,
	`v_serv_ct_chair02`
}

Citizen.CreateThread(function()
    exports['qtarget']:AddTargetModel(beds, {
        options = {
            {
                event = "bed:layBack",
                icon = "fas fa-chair",
                label = "Połóż się na plecach",
            },
            {
                event = "bed:layStomach",
                icon = "fas fa-chair",
                label = "Połóż się na brzuchu",
            },
        },
        distance = 2
    })
    exports['qtarget']:AddTargetModel(chairs, {
        options = {
            {
                event = "chair:sit",
                icon = "fas fa-chair",
                label = "Usiądź",
            },
        },
        distance = 2
    })
end)

RegisterNetEvent("chair:sit")
AddEventHandler("chair:sit", function()
	oPlayer = PlayerPedId()
		local pedPos = GetEntityCoords(oPlayer)
		for k,v in pairs(Config.objects.locations) do
			local oSelectedObject = GetClosestObjectOfType(pedPos.x, pedPos.y, pedPos.z, 0.8, GetHashKey(v.object), 0, 0, 0)
			local oEntityCoords = GetEntityCoords(oSelectedObject)
			local objectexits = DoesEntityExist(oSelectedObject)
			if objectexits then
				if GetDistanceBetweenCoords(oEntityCoords.x, oEntityCoords.y, oEntityCoords.z,pedPos) < 15.0 then
					if oSelectedObject ~= 0 then
						local objects = Config.objects
						if oSelectedObject ~= objects.object then
							objects.object = oSelectedObject
							objects.ObjectVertX = v.verticalOffsetX
							objects.ObjectVertY = v.verticalOffsetY
							objects.ObjectVertZ = v.verticalOffsetZ
							objects.OjbectDir = v.direction
							objects.isBed = v.bed
						end
					end
				end
			end
            local objects = Config.objects
            if objects.object ~= nil and objects.ObjectVertX ~= nil and objects.ObjectVertY ~= nil and objects.ObjectVertZ ~= nil and objects.OjbectDir ~= nil and objects.isBed ~= nil then
                local player = oPlayer
                local getPlayerCoords = GetEntityCoords(player)
                local objectcoords = GetEntityCoords(objects.object)
                if GetDistanceBetweenCoords(objectcoords.x, objectcoords.y, objectcoords.z,getPlayerCoords) < 1.8 and not using then
                    PlayAnimOnPlayer(objects.object,objects.ObjectVertX,objects.ObjectVertY,objects.ObjectVertZ,objects.OjbectDir, objects.isBed, player, objectcoords)
                    FreezeEntityPosition(player, false)
                end
            end
            if using == true then
                ClearPedTasksImmediately(player)
                using = false
                local x,y,z = table.unpack(lastPos)
                if GetDistanceBetweenCoords(x, y, z,getPlayerCoords) < 10 then
                    SetEntityCoords(player, lastPos)
                end
                FreezeEntityPosition(player, false)
            end
        end
end)

function PlayAnimOnPlayer(object,vertx,verty,vertz,dir, isBed, ped, objectcoords)
	lastPos = GetEntityCoords(ped)
	FreezeEntityPosition(object, true)
	SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z+-1.4)
	FreezeEntityPosition(ped, true)
	using = false
	if isBed == false then
		TaskStartScenarioAtPosition(ped, Config.objects.SitAnimation, objectcoords.x+vertx, objectcoords.y-verty, objectcoords.z-vertz, GetEntityHeading(object)+dir, 0, true, true)
	else
		if anim == "back" then
			TaskStartScenarioAtPosition(ped, Config.objects.LayBackAnimation, objectcoords.x+vertx, objectcoords.y+verty, objectcoords.z-vertz, GetEntityHeading(object)+dir, 0, true, true)
		elseif anim == "stomach" then
			TaskStartScenarioAtPosition(ped, Config.objects.LayStomachAnimation, objectcoords.x+vertx, objectcoords.y+verty, objectcoords.z-vertz, GetEntityHeading(object)+dir, 0, true, true)
		elseif anim == "sit" then
			TaskStartScenarioAtPosition(ped, Config.objects.SitAnimation, objectcoords.x+vertx-0.1, objectcoords.y-verty+0.4, objectcoords.z-vertz-1.0, GetEntityHeading(object)+dir-80, 0, true, true)
		end
	end
end

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end

function sit(object, modelName, data)
	-- Fix for sit on chairs behind walls
	if not HasEntityClearLosToEntity(PlayerPedId(), object, 17) then
		return
	end
	disableControls = true
	currentObj = object
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(PlayerPedId())
	local objectCoords = pos.x .. pos.y .. pos.z

	ESX.TriggerServerCallback('esx_sit:getPlace', function(occupied)
		if occupied then
			ShowNotification("zajente kurwa")
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('esx_sit:takePlace', objectCoords)
			
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, false)

			Wait(2500)
			if GetEntitySpeed(PlayerPedId()) > 0 then
				ClearPedTasks(PlayerPedId())
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end

			sitting = true
		end
	end, objectCoords)
end

lib.registerMenu({
    id = 'some_menu_id',
    title = 'Tworzenie organizacji',
    position = 'top-right',
    onSideScroll = function(selected, scrollIndex, args)
        print("Scroll: ", selected, scrollIndex, args)
    end,
    onSelected = function(selected, secondary, args)
        if not secondary then
            print("Normal button")
        else
            if args.isCheck then
                print("Check button")
            end

            if args.isScroll then
                print("Scroll button")
            end
        end
        print(selected, secondary, json.encode(args, {indent=true}))
    end,
    onCheck = function(selected, checked, args)
        print("Check: ", selected, checked, args)
    end,
    onClose = function(keyPressed)
        print('Menu closed')
        if keyPressed then
            print(('Pressed %s to close the menu'):format(keyPressed))
        end
    end,
    options = {
        {label = 'Simple button', description = 'It has a description!'},
        {label = 'Checkbox button', checked = true},
        {label = 'Scroll button with icon', icon = 'arrows-up-down-left-right', values={'hello', 'there'}},
        {label = 'Button with args', args = {someArg = 'nice_button'}},
        {label = 'List button', values = {'You', 'can', 'side', 'scroll', 'this'}, description = 'It also has a description!'},
        {label = 'List button with default index', values = {'You', 'can', 'side', 'scroll', 'this'}, defaultIndex = 5},
        {label = 'List button with args', values = {'You', 'can', 'side', 'scroll', 'this'}, args = {someValue = 3, otherValue = 'value'}},
    }
}, function(selected, scrollIndex, args)
    print(selected, scrollIndex, args)
end)

RegisterCommand('testmenu', function()
    lib.showMenu('some_menu_id')
end)

RegisterCommand("input", function()
	local input = lib.inputDialog('Tworzenie organizacji', {
		{ type = "input", label = "Nazwa organizacji:" },
		{ type = "input", label = "ID lidera organizacji:" },
		{ type = "input", label = "Koordy szafki:" },
		{ type = "input", label = "Koordy menu lidera:" },
		{ type = "checkbox", label = "???" },
	})
	print(json.encode(input, {indent=true}))

	local newOrg = {}	

	for _,v in ipairs(input) do
		newOrg[#newOrg +1] = {v}		
	end

	print(json.encode(newOrg))
	print(json.encode(newOrg[1]))

end)

RegisterCommand("gcoords", function()
    local coords = GetEntityCoords(PlayerPedId())
    SendNUIMessage({
        coords = ("vector3(%f, %f, %f)"):format(coords.x, coords.y, coords.z)
    })
end)