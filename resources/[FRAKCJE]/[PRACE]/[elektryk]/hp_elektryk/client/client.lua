ESX = exports['es_extended']:getSharedObject()
local JobBlips = {}
local taskBlip
local onResettingTask = false
local taskCheck = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
}

local playerProgress = {
    completedTasks = {},
    actualPoint = nil,
    isWorking = false,
    tookTools = false,
    prop = nil,
    currentLocation = nil,
    vehicle = nil,
    checkFuses = false,
    tookTablet = false,
    multimeterStatus = false,
    switchReplaced = false
} 


function TaskToDo()
    local retval = 4
    for i=1, #taskCheck do
        if taskCheck[i] then
            retval = retval -1
        end
    end
    if retval == 0 then
        TriggerServerEvent('hp_elektryk:payForJob',playerProgress)
        playerProgress.completedTasks[playerProgress.actualPoint] = true
        local location = getLocation()
        playerProgress.actualPoint = location.ProjectLocations.main.Id
        createWorkZone(location)
        
    else
        return retval
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
    spawnPed()
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
    if ESX.PlayerData.job.name == 'elektryk' then
        deleteBlips()
        refreshBlips()
        resetProgress()
    end
    if ESX.PlayerData.job.name ~= 'elektryk' then
        deleteBlips()
        resetProgress()
    end
end)

RegisterNetEvent('hp_elektryk:startWorking', function()
    if onResettingTask then return exports.okokNotify:Alert("KURIER", "Nie możesz tak często anulować zleceń...", 5000, 'info') end
    ESX.TriggerServerCallback('hp_elektryk:checkCaution', function(status)
        if not status then return end
        playerProgress.isWorking = true
         ESX.Game.SpawnVehicle(Config.VehicleModel, Config.VehicleCoords, Config.VehicleHeading, function(vehicle)
             SetVehicleNumberPlateText(vehicle, "WORK"..math.random(1111,9999))
             SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
             playerProgress.vehicle = vehicle
             exports.ox_target:addLocalEntity(vehicle, {
                 {
                     label = "Wyciągnij tablet",
                     icon = 'fa-solid fa-tablet',
                     canInteract = function(entity, distance)
                         return distance < 5 and not playerProgress.tookTablet and ESX.PlayerData.job.name == 'elektryk'
                     end,
                     onSelect = function()
                         TakeTabletFromCar()
                     end
                 },
                 {
                     label = "Wyciągnij narzędzia",
                     icon = 'fa-solid fa-screwdriver-wrench',
                     canInteract = function(entity, distance)
                         return distance < 5 and not playerProgress.tookTools and ESX.PlayerData.job.name == 'elektryk'
                     end,
                     onSelect = function()
                         createToolProp()
                     end
                 },
                 {
                    label = "Zwróć pojazd",
                    icon = 'fa-solid fa-car',
                    canInteract = function(entity, distance)
                        return distance < 5 and ESX.PlayerData.job.name == 'elektryk'
                    end,
                    onSelect = function(data)
                        ReturnVehicle(data)
                    end
                }
             })
             local location = getLocation()
             playerProgress.actualPoint = location.ProjectLocations.main.Id
             createWorkZone(location)
         end)
    end)
end)

function CompleteTask(task)
    if not playerProgress.checkFuses and task.action ~= 'fuses' then shockPlayer() return end
    if task.action == 'fuses' then
        DoFuseCheck()
    elseif task.action == 'pcupdate' then
        UpdateDrivers()
    elseif task.action == 'checkVoltage' then
        CheckVoltage()
    elseif task.action == 'replaceSwitches' then
        ReplaceSwitches()
    end
end

function ReplaceSwitches()
    if not playerProgress.tookTools then exports.okokNotify:Alert("ELEKTRYK", 'A może weźmiesz jakieś narzędzia z auta?', 5000, 'info') return end
    if not playerProgress.switchReplaced then
        DeleteEntity(playerProgress.prop)
        exports.hp_progressbar:startProgressbar(8000, "Szukasz przepalonego przełącznika",{
            Freeze = true, 
            onFinish = function()
                playerProgress.switchReplaced = true
            end, onCancel = function()
                playerProgress.tookTools = false
            end
        })
    end
    exports.hp_progressbar:startProgressbar(18000, "Wymieniasz przełącznik",{
        Freeze = true, 
        onFinish = function()
            playerProgress.switchReplaced = false
            taskCheck[2] = true
            exports.okokNotify:Alert("ELEKTRYK", 'Zostało Ci jeszcze: '..TaskToDo()..' zadań w tym miejscu', 5000, 'success')
        end, onCancel = function()
            playerProgress.tookTools = false
            playerProgress.switchReplaced = false
        end
    })
end

function CheckVoltage()
    if not playerProgress.tookTools then exports.okokNotify:Alert("ELEKTRYK", 'A może weźmiesz jakieś narzędzia z auta?', 5000, 'info') return end
    if not playerProgress.multimeterStatus then 
        exports.hp_progressbar:startProgressbar(8000, "Szukasz multimetru w torbie",{
            Freeze = true, 
            animation ={
                type = "anim",
                dict = "amb@world_human_bum_wash@male@low@idle_a", 
                lib ="idle_a"
            },
            onFinish = function()
                DeleteEntity(playerProgress.prop)
                playerProgress.multimeterStatus = true
                playerProgress.tookTools = false
            end, onCancel = function()
                DeleteEntity(playerProgress.prop)
                playerProgress.tookTools = false
            end
        })
    end
    exports.hp_progressbar:startProgressbar(12000, "Mierzysz odpowiednio fazy L1,L2,L3 do masy",{
        Freeze = true, 
        onFinish = function()
            playerProgress.multimeterStatus = false
            playerProgress.tookTools = false
            taskCheck[1] = true
            exports.okokNotify:Alert("ELEKTRYK", 'Wygląda na to że wszystko jest w porządku.', 5000, 'success')
        end, onCancel = function()
        
        end
    })
    

end

function UpdateDrivers()
    if not playerProgress.tookTablet then exports.okokNotify:Alert("ELEKTRYK", 'Czym chcesz to zrobić?', 5000, 'error') return end
    DeleteEntity(playerProgress.prop)

    exports.hp_progressbar:startProgressbar(25000, "Aktualizujesz sterownik szafy",{
        Freeze = true, 
        animation ={
            type = "anim",
            dict = "amb@prop_human_parking_meter@male@idle_a", 
            lib ="idle_a" 
        }, 
        onFinish = function()
            taskCheck[3] = true
            exports.okokNotify:Alert("SUKCES", "Świetnie, wygląda na to że urządzenie się zaktualizowało!", 5000, 'info')
            exports.okokNotify:Alert("ELEKTRYK", 'Zostało Ci jeszcze: '..TaskToDo()..' zadań w tym miejscu', 5000, 'success')

        end, onCancel = function()
            ClearPedTasks(PlayerPedId())        --Code here
        end
    })
end

function DoFuseCheck()
    if not playerProgress.checkFuses then 
        SendNUIMessage({RequestType = "Visibility", RequestData = true})
        SetNuiFocus(true, true)
    end
end

function createWorkZone(data)
    CreateTaskBlip(data.ProjectLocations.main)
    for k,v in pairs(data) do
        for i=1, #v.tasks do
            exports.ox_target:addBoxZone({
                coords = v.tasks[i].coords,
                size = vector3(2,2,2),
                debug = true,
                drawSprite = true,
                options = {
                    {
                        label = v.tasks[i].label,
                        icon = v.tasks[i].icon,
                        action = v.tasks[i].action or nil,
                        canInteract = function(entity,distance)
                            return distance < 5 and not taskCheck[i] and ESX.PlayerData.job.name == 'elektryk'
                        end,
                        onSelect = function(data)
                            CompleteTask(data)
                        end,
                    }
                }
            })
        end
    end
end

function CreateTaskBlip(data)
    taskBlip = AddBlipForCoord(data.coords)
    SetBlipSprite  (taskBlip,  773)
    SetBlipDisplay (taskBlip, 4)
    SetBlipScale   (taskBlip, 1.4)
    SetBlipCategory(taskBlip, 3)
    SetBlipColour  (taskBlip, 1)
    SetBlipAsShortRange(taskBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(data.label)
    EndTextCommandSetBlipName(taskBlip)
    SetBlipRoute(taskBlip, true)
    SetBlipRouteColour(taskBlip, 1)
end

function _RequestModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
end
function _RequestAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
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
    if ESX.PlayerData.job ~= nil then
        if ESX.PlayerData.job.name == 'elektryk' then
            local blip = AddBlipForCoord(531.18, -1600.55, 28.10)
            SetBlipSprite  (blip,  779)
            SetBlipDisplay (blip, 4)
            SetBlipScale   (blip, 1.0)
            SetBlipCategory(blip, 3)
            SetBlipColour  (blip, 27)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("# Biuro Electric & Industries")
            EndTextCommandSetBlipName(blip)
            table.insert(JobBlips, blip)
        end
    end
end

function spawnPed()
    _RequestModel('a_m_y_vindouche_01')
    local ped = CreatePed(4, 'a_m_y_vindouche_01', Config.JobLocations.coords, Config.JobLocations.heading, false, false)
    Wait(1000)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded('a_m_y_vindouche_01')
    exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Rozpocznij zlecenie',
            icon = 'fa-solid fa-bolt',
            event = 'hp_elektryk:startWorking',
            canInteract = function(entity, distance)
                return distance < 3 and not playerProgress.isWorking and ESX.PlayerData.job.name == 'elektryk'
            end,
        },
        {
            label = 'Top 10 pracowników! ',
            icon = 'fa-solid fa-bolt',
            canInteract = function(entity, distance)
                return distance < 3 and not playerProgress.isWorking and ESX.PlayerData.job.name == 'elektryk'
            end,
            onSelect = function(data)
                TriggerEvent('hp_panel:openJobPanel','elektryk')
            end,
        },
        {
            label = 'Zakończ zlecenie',
            icon = 'fa-solid fa-bolt',
            event = 'hp_elektryk:stopWorking',
            canInteract = function(entity, distance)
                return distance < 3 and playerProgress.isWorking and ESX.PlayerData.job.name == 'elektryk'
            end,
        }
    })
end
RegisterNetEvent('hp_elektryk:stopWorking', function()
    resetProgress()
    onResettingTask = true
end)

function resetProgress()
    taskCheck = {
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
    }
    if DoesBlipExist(taskBlip) then
        RemoveBlip(taskBlip)
    end
    if DoesEntityExist(playerProgress.prop) then
        DeleteEntity(playerProgress.prop)
    end
    DeleteVehicle(playerProgress.vehicle)

    playerProgress = {
        isWorking = false,
        tookTools = false,
        prop = nil,
        currentLocation = nil,
        vehicle = nil,
        checkFuses = false,
        tookTablet = false,
        multimeterStatus = false,
        switchReplaced = false
    } 
end

function createToolProp()
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 57005)
    local coords = GetEntityCoords(PlayerPedId())
    if playerProgress.prop then
        DeleteEntity(playerProgress.prop)
        playerProgress.prop = nil
    end
    playerProgress.tookTablet = false
    playerProgress.tookTools = true
    _RequestAnimDict('rcmepsilonism8')
    TaskPlayAnim(PlayerPedId(), 'rcmepsilonism8', 'bag_handler_idle_a', 8.0, 8.0, -1, 49, 1.0)
    _RequestModel('prop_tool_box_04')

    local object = CreateObject('prop_tool_box_04', vector3(coords.x,coords.y,coords.z+2), false, false)
    AttachEntityToEntity(object, PlayerPedId(), boneIndex, 0.43, 0.00, -0.02, -90.0 , 0.0 , 90.0 , true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded('prop_tool_box_04')
    playerProgress.prop = object
end

function getLocation()
    math.randomseed(GetGameTimer())
    if #playerProgress.completedTasks == 4 then exports.okokNotify:Alert("ELEKTRYK", 'Wykonałeś wszystkie zadania! Czekaj na dyspozycje..', 5000, 'info') return end

    local random =  Config.Projects[math.random(#Config.Projects)]
    if playerProgress.completedTasks[random.ProjectLocations.main.Id] then
        Wait(1000)
        getLocation()
        return
    end
    return random
end

function TakeTabletFromCar()
    playerProgress.tookTablet = true
    playerProgress.tookTools = false
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)
    local coords = GetEntityCoords(PlayerPedId())
    if playerProgress.prop then
        DeleteEntity(playerProgress.prop)
        playerProgress.prop = nil
    end
    _RequestAnimDict('rcmepsilonism8')
    TaskPlayAnim(PlayerPedId(), 'mb@code_human_in_bus_passenger_idles@female@tablet@idle_a', 'idle_a', 8.0, 8.0, -1, 49, 1.0)
    _RequestModel('prop_cs_tablet')

    local object = CreateObject('prop_cs_tablet', vector3(coords.x,coords.y,coords.z+2), false, false)
    AttachEntityToEntity(object, PlayerPedId(), boneIndex, -0.05, 0, 0, 0.0 , 0.0 , 0.0 , true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded('prop_cs_tablet')
    playerProgress.prop = object
end

local particleCount = 0
function shockPlayer()
    -- Make some variables for the particle dictionary and particle name.
    local dict = "core"
    local particleName = "ent_col_electrical"
-- Create a new thread.
    if not playerProgress.actualPoint then return end
    CreateThread(function()
        -- Request the particle dictionary.
        RequestNamedPtfxAsset(dict)
        -- Wait for the particle dictionary to load.
        while not HasNamedPtfxAssetLoaded(dict) do
            Wait(0)
        end
        
        -- Get the position of the player, this will be used as the
        -- starting position of the particle effects.
        local ped = PlayerPedId()

       _RequestAnimDict('melee@unarmed@streamed_variations')
        TaskPlayAnim(PlayerPedId(), 'melee@unarmed@streamed_variations', 'victim_takedown_front_slap', 6.0, -6.0, 6000, 2, 0, 0, 0, 0)
        while particleCount < 11 do
            -- Tell the game that we want to use a specific dictionary for the next particle native.
            local x,y,z = table.unpack(GetEntityCoords(ped, true))
            UseParticleFxAssetNextCall(dict)
            -- Create a new non-looped particle effect, we don't need to store the particle handle because it will
            -- automatically get destroyed once the particle has finished it's animation (it's non-looped).
            StartParticleFxNonLoopedAtCoord(particleName, x, y, z, 0.0, 0.0, 0.0, 1.0, false, false, false)
        
            particleCount = particleCount + 1
            
            -- Wait 500ms before triggering the next particle.
            Wait(300)
        end
        RemoveAnimDict('melee@unarmed@streamed_variations')
        math.randomseed(GetGameTimer())
        if(math.random() >= 0.6) then
            ClearPedTasks(PlayerPedId())
            exports.okokNotify:Alert("ELEKTRYK", 'Zostałeś porażony prądem.Sprawdź czy bezpieczniki są opuszczone...', 5000, 'error') 
        else
            CreateThread(function()
                DoScreenFadeOut(800)
                while not IsScreenFadedOut() do
                    Wait(10)
                end

                SetEntityHealth(PlayerPedId(), 0)
			    DoScreenFadeIn(800)
                exports.okokNotify:Alert("ELEKTRYK", 'Zostałeś porażony prądem, nie odłączyłeś zasilania przed pracą.', 5000, 'error') 
            end)
        end
    end)
end

function ReturnVehicle(data)
    local vCoords = GetEntityCoords(playerProgress.vehicle)
    local pCoords = vector3(528.56, -1602.86, 28.29)
    local distance = #(vCoords - pCoords)
    if not distance < 15 then exports.okokNotify:Alert("BŁĄD", 'Musisz podjechać bliżej bazy...', 7000, 'error') return end
    TriggerServerEvent('hp_elektryk:returnCaution', playerProgress.vehicle, distance)
    DeleteVehicle(playerProgress.vehicle)
    DeleteEntity(playerProgress.vehicle)
    ESX.Game.DeleteVehicle(playerProgress.vehicle)
    playerProgress.vehicle = nil
end

RegisterNUICallback("main", function(RequestData)
	if RequestData.ReturnType == "EXIT" then
		SetNuiFocus(false, false)
		SendNUIMessage({RequestType = "Visibility", RequestData = false})
	elseif RequestData.ReturnType == "DONE" then
		SetNuiFocus(false, false)
		SendNUIMessage({RequestType = "Visibility", RequestData = false})
        playerProgress.checkFuses = not playerProgress.checkFuses
        TriggerEvent("Mx::StartMinigameElectricCircuit", '50%', '50%', '1.0', '50vmin', '1.ogg', function()
            SetNuiFocus(false, false)
            taskCheck[4] = true
        end)

        exports.okokNotify:Alert("ELEKTRYK", 'Zostało Ci jeszcze: '..TaskToDo()..' zadań w tym miejscu', 5000, 'success')
	end
end)
CreateThread(function()
    while true do
        Wait(0)
        if onResettingTask then
            Wait(30000)
            onResettingTask = false
        else
            Wait(3000)
        end
    end
end)
