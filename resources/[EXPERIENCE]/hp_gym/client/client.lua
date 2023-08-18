ESX = exports['es_extended']:getSharedObject()
local onCooldown = false
local zones = {}
local cashierPed = nil
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew)
	ESX.PlayerData = xPlayer
    CreateBlip()
    SpawnZones()
    UpdateStats()
end)

RegisterNetEvent('hp_gym:startTraining:sztanga', function(data)
    ESX.TriggerServerCallback('hp_gym:checkCarnet', function(carnetTime)
        if not carnetTime.status then exports.okokNotify:Alert("SIŁOWNIA", "Udaj się do recepcji by zakupić karnet!", 5000, 'info') return end
        if onCooldown then exports.okokNotify:Alert("SIŁOWNIA", 'Musisz chwilę poczekać przed następnym treningiem!', 5000, 'info') return end
        TriggeServerEvent('hp_gym:disarmPed', data)
        TaskStartScenarioInPlace(PlayerPedId(), "world_human_muscle_free_weights", 0, true)
        StartMiniGame(data.skill)
    end)
end) 


function PushScaleForm(points, check)
    local tekstOnString = points.."/3 z wykonanych ćwiczeń"
    local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
    local sec = 3
    BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')
    ScaleformMovieMethodAddParamTextureNameString(tekstOnString)
    EndScaleformMovieMethod()

    PlaySoundFrontend(-1, 'HUD_AWARDS', 'COLLECTED', false)

    CreateThread(function()
        while sec > 0 do
            Wait(0)
            sec = sec - 0.01

            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end

function CreateBlip()
    local blip = AddBlipForCoord(-1203.98, -1570.85, 4.61)
	SetBlipSprite(blip, 311)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.2)
	SetBlipColour(blip, 48)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Heaven Gym")
	EndTextCommandSetBlipName(blip)
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        for k,v in pairs(zones) do
            v:destroy()
        end
   end
end)

RegisterNetEvent('hp_gym:refreshSkill', function()
    UpdateStats()
end)

RegisterNetEvent('hp_gym:buyPass', function()
    lib.showContext('hp_gym_buy_pass')
end)

function dayBalance(howLong)
    ESX.TriggerServerCallback('hp_gym:checkMoneyBalance', function(canBuy)
        if not canBuy then  exports.okokNotify:Alert("SIŁOWNIA", "Nie stać Cie na zakup karnetu!", 5000, 'info') return end 

        _RequestAnimDict('mp_common')
        entityFacingToEntity(PlayerPedId(),cashierPed)
        TaskPlayAnim(cashierPed, 'mp_common', 'givetake1_a',8.0, 8.0, -1, 1, 1.0)
        Wait(2000)
        ClearPedTasks(cashierPed)
    end, howLong)
end
function entityFacingToEntity(player,entity)

    local p1 = GetEntityCoords(entity, true)
	local p2 = GetEntityCoords(player, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading(entity, heading )
end
function _RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        RequestAnimDict(anim)
        Wait(0)
    end
end
function _RequestModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(100)
    end
end
function BuyKarnet()
    ESX.TriggerServerCallback('hp_gym:checkCarnet', function(carnetTime)
        if not carnetTime.status then 
           lib.showContext('hp_gym_buy_account')
        else
            exports.okokNotify:Alert('SIŁOWNIA', 'Posiadasz jeszcze ważny karnet!', 5000, 'info')
        end
    end)
end
function UpdateStats()
    ESX.TriggerServerCallback('hp_gym:updateStats', function(data)
        StatSetInt('MP0_STAMINA', math.floor(data.stamina+.5) , true)
        StatSetInt('MP0_STRENGTH', math.floor(data.strength+.5) , true)
    end)
end
function startTraining(types)
    if onCooldown then ESX.ShowNotification("Musisz chwilę odpocząć przed następnym treningiem") return end
    if types == 'strength' then
        TaskStartScenarioInPlace(PlayerPedId(), "world_human_muscle_free_weights", 0, true)
        local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'medium'}, {'w', 'a', 's', 'd'})
        if success then
            onCooldown = true
            TriggerServerEvent('hp_gym:addPoint', 'strength')
        end
        
    end
end
--Czas trwania karnetów
lib.registerContext({
    id = 'hp_gym_buy_account',
    title = 'Płatność tylko gotówką!',
    options = {
      {
        title = '1 dzień',
        description = '200 $',
        icon = 'fa-solid fa-money-bill',
        onSelect = function()
          dayBalance(1)
        end
      },
      {
        title = '3 dni',
        description = '600 $',
        icon = 'fa-brands fa-cc-visa',
        onSelect = function()
            dayBalance(2)
        end
      },
      {
        title = '7 dni',
        description = '1200 $',
        icon = 'fa-solid fa-money-bill',
        onSelect = function()
            dayBalance(7)
        end
      },
      {
        title = 'Powrót',
        description = 'Wróć do ostatniego menu',
        icon = 'fa-solid fa-arrow-left',
        onSelect = function()
            lib.hideContext('hp_gym_buy_account')
            lib.showContext('hp_gym_buy_pass')
        end
      }
    }
})
--Głowne menu 
lib.registerContext({
    id = 'hp_gym_buy_pass',
    title = 'Karnet | Informacje',
    options = {
      {
        title = 'Zakup karnet',
        description = 'Zakup karnet na siłownię!',
        icon = 'fa-solid fa-play',
        onSelect = function()
            BuyKarnet()
        end
      },
      {
        title = 'Sprawdź ważność karnetu',
        description = '',
        icon = 'fa-solid fa-hourglass',
        onSelect = function()
            CheckCarnetTime()
        end
      }
    }
})

function SpawnZones()
    local propFind = nil
    ESX.TriggerServerCallback('hp_gym:sendData', function(svData)
        for k,v in pairs(svData.Peds) do
            _RequestModel(v.model)
            local ped = CreatePed(4, v.model, v.coords, 99.28,false, false)
            if v.event == 'buyPass' then
                cashierPed = ped
            end
            SetEntityAsMissionEntity(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            exports.ox_target:addLocalEntity(ped, {
                {
                    event = "hp_gym:"..v.event,
                    label = v.label,
                    icon = v.icon,
                    canInteract = function(entity, distance)
                        return distance < 5 
                    end
                }
            })
        end
        local trainEntity
        for k,v in pairs(svData.boxZones) do
            for i=1, #v do
                
                v[i].name = BoxZone:Create(v[i].coords, v[i].length,v[i].width, {
                    name = "silownia" .. k,
                    heading = v[i].heading,
                    minZ = v[i].minZ,
                    maxZ = v[i].maxZ,
                    debugPoly = v[i].debug,
                    skill = v[i].skill
                })
                table.insert(zones, v[i].name)
                if k=='sztanga' then 
                    v[i].name:onPlayerInOut(function(isPointInside, point, zone)
                        if isPointInside then
                            if k == 'sztanga' then
                                propFind = 'prop_weight_squat'
                                trainEntity = GetClosestObjectOfType(v[i].coords, v[i].propRange, GetHashKey(propFind), false, false, false)
                                exports.ox_target:addLocalEntity(trainEntity, {
                                    {
                                        name = k..'xd'..i,
                                        event = "hp_gym:startTraining:sztanga",
                                        skill = v[i].skill,
                                        icon = "fa-solid fa-dumbbell",
                                        label = "Zacznij trening",
                                    }
                                })
                            end
                        else
                            exports.ox_target:removeLocalEntity(trainEntity, k..'xd'..i)
                        end
                    end)
                end
            end
        end
    end)
end

function CheckCarnetTime()
    ESX.TriggerServerCallback('hp_gym:checkCarnet', function(hasCarnet)
        if not hasCarnet.status then exports.okokNotify:Alert('INFO', 'Nie posiadasz ważnego karnetu!', 5550, 'info') return end
        exports.okokNotify:Alert('INFO', 'Karnet ważny do: '..hasCarnet.time, 5550, 'info')
    end)

end
function StartMiniGame(skill)
    local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 0.8}, 'easy'}, {'w', 'a', 's', 'd'})
        if not success then
            ClearPedTasks(PlayerPedId())
            ESX.ShowNotification("Wykonałeś Źle ćwiczenie, musisz odpocząć!")
            onCooldown = true
            return
        end
        PushScaleForm(1, false)
        Wait(3100)
        local success2 = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 0.8}, 'easy'},{'q', 'w', 'e', 'r'})
        if not success2 then
            ClearPedTasks(PlayerPedId())
            ESX.ShowNotification("Wykonałeś Źle ćwiczenie, musisz odpocząć!")
            onCooldown = true
            return
        end
        PushScaleForm(2, false)
        Wait(3100)
        local success3 = lib.skillCheck({'easy', 'easy', {areaSize = 50, speedMultiplier = 0.8}, 'easy'},{'w', 'a', 's', 'd'})
        if not success3 then
            ClearPedTasks(PlayerPedId())
            ESX.ShowNotification("Wykonałeś Źle ćwiczenie, musisz odpocząć!")
            onCooldown = true
            return
        end
        PushScaleForm(3, true)
        Wait(3100)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('hp_gym:addPoint', skill)
        exports.okokNotify:Alert('INFO', 'Wykonałeś dobrze ćwiczenie. Czujesz się silniejszy', 5000, 'info')
        onCooldown = false
end

