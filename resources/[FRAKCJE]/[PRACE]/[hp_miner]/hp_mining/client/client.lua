ESX = exports['es_extended']:getSharedObject()
local pStatus = {
    isWorking = false,
    isBusy = false,
    onCooldown = false,
    resetCooldown = false,
}
local spawnedPeds = {}
local spawnedCrystals = {}
local JobBlips = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
    spawnInteractionPed()
    deleteBlips()
    refreshBlips()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
    if ESX.PlayerData.job.name ~= 'miner' then
        for i=1, #spawnedCrystals do
            ESX.Game.DeleteObject(spawnedCrystals[i])
        end
        deleteBlips()
        return
    else
        deleteBlips()
        refreshBlips()
    end
end)


function spawnInteractionPed()
    ESX.TriggerServerCallback('hp_mining:getPedData', function(data)
        for i=1, #data do
            Wait(1000)
            _RequestModel(data[i].model)
            local ped = CreatePed(4, data[i].model, data[i].coords, data[i].heading, false, false)
            FreezeEntityPosition(ped, true)
            SetEntityAsMissionEntity(ped)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            spawnedPeds[#spawnedPeds+1] = ped
            if data[i].event == 'startworking' then

                exports.ox_target:addLocalEntity(ped, {
                    {
                        label = data[i].label,
                        icon = data[i].icon,
                        event = 'hp_mining:'..data[i].event,
                        canInteract = function(entity, distance)
                            return distance < 2 and ESX.PlayerData.job.name == 'miner' and not pStatus.isWorking
                        end,
                    },
                    {
                        label = "Zakończ pracę",
                        event = 'hp_mining:stopWorking',
                        icon = 'fa-regular fa-bell-slash',
                        canInteract = function(entity, distance)
                            return distance < 2 and ESX.PlayerData.job.name == 'miner' and pStatus.isWorking
                        end,
                        
                    },
                    {
                        label = "Top 10 pracowników",
                        icon = 'fa-regular fa-bell-slash',
                        onSelect = function(data)
                            TriggerEvent('hp_panel:openJobPanel','miner')
                        end,
                        canInteract = function(entity, distance)
                            return distance < 2 and ESX.PlayerData.job.name == 'miner'
                        end,
                        
                    },
                    {
                        label = "Oferuję pracę tylko górnikom..",
                        icon = 'fa-regular fa-bell-slash',
                        canInteract = function(entity, distance)
                            return distance < 2 and not ESX.PlayerData.job.name == 'miner'
                        end,
                        
                    },
                })
            else
                exports.ox_target:addLocalEntity(ped, {
                    {
                        label = data[i].label,
                        event = data[i].event,
                        icon = data[i].icon,
                        typ = data[i].typ or nil,
                        price = data[i].price or nil,
                        canInteract = function(entity, distance)
                            return distance < 2 and ESX.PlayerData.job.name == 'miner'
                        end,
                        event = 'hp_mining:'..data[i].event
                    },
                })
            end
            SetModelAsNoLongerNeeded(data[i].model)
        end


    end)
end


RegisterNetEvent('hp_mining:startworking', function()
    if pStatus.resetCooldown then exports.okokNotify:Alert('GÓRNIK', 'Nie możesz tak rzucać roboty a potem wracać jak Ci się podoba.. daj mi przemyślec..', 5000, 'info') return end
    
    exports.hp_progressbar:startProgressbar(8000, "Przebierasz się do pracy",{
        Freeze = true, 
        animation ={
            type = "anim",
            dict = "move_m@_idles@shake_off", 
            lib ="shakeoff_1"
        },
        onFinish = function()
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
                end
            end)
            pStatus.isWorking = true
            spawnCrystals()
        end
    })
end)

RegisterNetEvent('hp_mining:stopWorking', function()
    pStatus.isWorking = false
    pStatus.resetCooldown = true
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    for i=1, #spawnedCrystals do
        ESX.Game.DeleteObject(spawnedCrystals[i])
    end
end)

RegisterNetEvent('hp_mining:spawnCrystals', function(data)
    ESX.Game.SpawnObject(data.model, data.coords, function(obj)
        SetEntityAsMissionEntity(obj)
        FreezeEntityPosition(obj, true)
        
        exports.ox_target:addLocalEntity(obj, {
            {
                label = "Wykop kryształ",
                icon = 'fa-regular fa-ring-diamond',
                index = i,
                chance = data.chance,
                crystalType = data.crystalType,
                canInteract = function(entity, distance)
                    return distance < 2 and ESX.PlayerData.job.name == 'miner' and not pStatus.isBusy
                end,
                onSelect = function(data)
                    StartDiggingEmerald(data)
                end
            }
        })
        spawnedCrystals[data.index] = obj
    end)

end)

function StartDiggingEmerald(data)
    pStatus.isBusy = true

    LoadAnimDict('melee@large_wpn@streamed_core')
    TaskPlayAnim(PlayerPedId(), 'melee@large_wpn@streamed_core', 'ground_attack_-90' , 1.0, 1.0, -1, 1, 0, false, false, false)
    local pos = GetEntityCoords(PlayerPedId(), true)
    local DrillObject = CreateObject(GetHashKey("prop_tool_pickaxe"), pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.01, 0.0, 300.0, 720.0, 330.0, true, true, false, true, 1, true)
    

    exports.hp_progressbar:startProgressbar(14000, "Wykopujesz kryształ",{
        Freeze = true, 
        onFinish = function()
            TriggerServerEvent('hp_mining:checkReward', data)
            ESX.Game.DeleteObject(spawnedCrystals[data.index])
            pStatus.isBusy = false
            pStatus.onCooldown = false
            ClearPedTasks(PlayerPedId())
            DeleteObject(DrillObject)
            DeleteEntity(DrillObject)
        
        end,onCancel=function()
            pStatus.isBusy = false
            pStatus.onCooldown = false
            DeleteObject(DrillObject)
            DeleteEntity(DrillObject)
            ClearPedTasks(PlayerPedId())
        end
    })
end

function spawnCrystals()
    ESX.TriggerServerCallback('hp_mining:getGamesCoords', function(data)
        for i=1, #data do
            ESX.Game.SpawnObject(data[i].model, data[i].coords, function(obj)
                SetEntityAsMissionEntity(obj)
                FreezeEntityPosition(obj, true)
                exports.ox_target:addLocalEntity(obj, {
                    {
                        label = "Wykop kryształ",
                        icon = 'fa-regular fa-ring-diamond',
                        index = i,
                        chance = data[i].chance,
                        crystalType = data[i].crystalType,
                        canInteract = function(entity, distance)
                            return distance < 2 and ESX.PlayerData.job.name == 'miner' and not pStatus.isBusy
                        end,
                        onSelect = function(data)
                            StartDiggingEmerald(data)
                        end
                    }
                })
                spawnedCrystals[i] = obj
            end)
        end
    end)
end

CreateThread(function()
    while true do
        Wait(0)
        if pStatus.resetCooldown then
            Wait(25000)
            pStatus.resetCooldown = false
        else
            Wait(3000)
        end
    end
end)
function _RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
end

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
    ESX.TriggerServerCallback('hp_mining:getPedData', function(svData)
        if ESX.PlayerData.job.name == 'miner' then
            for i=1,#svData do
                if svData[i].prompt ~= nil then
                    local blip = AddBlipForCoord(svData[i].coords)            
                    SetBlipSprite  (blip, svData[i].sprite)
                    SetBlipDisplay (blip, 4)
                    SetBlipScale   (blip, 1.2)
                    SetBlipCategory(blip, 3)
                    SetBlipColour  (blip, svData[i].blipColour)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(svData[i].prompt)
                    EndTextCommandSetBlipName(blip)
                    table.insert(JobBlips, blip)
                end
            end
        end
    end)
end

RegisterNetEvent('hp_mining:sellGold', function(data)
    ESX.TriggerServerCallback('hp_mining:extractStones', function(hasGold)
        if hasGold[1] then
            local alert = lib.alertDialog({
                header = 'Sprzedaj złoto.',
                content = 'Czy na pewno chcesz sprzedać '..hasGold[3]..' x'..hasGold[2]..' za '..math.floor(hasGold[2] * data.price)..'$',
                centered = true,
                cancel = true
            })
            if alert == 'confirm' then
                TriggerServerEvent('hp_mining:sellGold', hasGold[1], hasGold[2], data.typ)
            end
        else
            exports.okokNotify:Alert("INFO", 'Nie masz mi nic do zaoferowania..', 5000, 'error')
        end
    end,data.typ)

end)

RegisterNetEvent('hp_mining:extractStones', function()
    ESX.TriggerServerCallback('hp_mining:extractStones', function(hasStones)
        if not hasGold[1] then exports.okokNotify:Alert("INFO", "Nie posiadasz urobku ze sobą.. wygląda na to że musisz skoczyć po niego do kopalni.", 5000, 'info') return end
       
        ESX.Progressbar("Czekasz do końca procesu uszlachetniania", 25000,{
            FreezePlayer = true, 
            onFinish = function()
                TriggerServerEvent('hp_mining:extractedStone')
            end
        })
    end, 'stone')
end)


function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

AddEventHandler('onClientResourceStop', function(res)
    if res == GetCurrentResourceName() then 
        if spawnedPeds then
            for i=1, #spawnedPeds do
                DeleteEntity(spawnedPeds[1])
            end
            for i=1, #spawnedCrystals do
                ESX.Game.DeleteObject(spawnedCrystals[i])
            end
            deleteBlips()
        end
    end
end)
