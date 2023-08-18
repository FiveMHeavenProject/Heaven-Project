ESX = exports['es_extended']:getSharedObject()
local cautionPlayers = {}
local loadedClientSide = {}
local l = [[
    ESX = exports['es_extended']:getSharedObject()
    local grapeZone, blips = {}, {}
    local Uniforms = {
        male = {
            ['tshirt_1'] = 59, ['tshirt_2'] = 1,
            ['torso_1'] = 55, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 41,
            ['pants_1'] = 25, ['pants_2'] = 2,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['helmet_1'] = 46, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 36, ['tshirt_2'] = 1,
            ['torso_1'] = 48, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 44,
            ['pants_1'] = 34, ['pants_2'] = 0,
            ['shoes_1'] = 27, ['shoes_2'] = 0,
            ['helmet_1'] = 45, ['helmet_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['ears_1'] = 2, ['ears_2'] = 0
        }
    }
    local Data = {
        pedsInteraction = nil,
        grapeInfo = nil,
        grapeZone = nil
    }
    local pData = {
        isBusy = false,
        isWorking = false,
        vehicle = nil
    }
    Data.pedsInteraction = {
        {
            coords=vector4(-1928.94, 2059.64, 139.90, 345.45), 
            action = 'hp_winiarnia:startWorking', 
            model = 'ig_joeminuteman', 
            icon = 'fa-solid fa-star', 
            label = 'Rozpocznij pracę',
            prompt = "# 1.Rozpocznij pracę"
        },
        {
            coords=vector4(-1200.95, 352.17, 71.27, 206.15), 
            action = 'hp_winiarnia:startTransformWine', 
            model = 'a_m_m_mexcntry_01', 
            icon = 'fa-solid fa-right-left',
            label = 'Przerób winogrono',
            prompt = "# 2. Przerób winogrono"
        },
        {
            coords=vector4(1200.95, 352.17, 71.27, 206.15), 
            action = 'hp_winiarnia:startTransformToWine', 
            model = 'a_m_m_mexcntry_01', 
            icon = 'fa-solid fa-right-left',
            label = 'Przerób sok winogronowy',
            prompt = "# 3. Przerób sok winogronowy"
        },
        {
            coords=vector4(1100.95, 352.17, 71.27, 206.15), 
            action = 'hp_winiarnia:sellWine', 
            model = 'a_m_m_mexcntry_01', 
            icon = 'fa-solid fa-right-left',
            label = 'Sprzedaj wino',
            prompt = "# 4. Sprzedaj wino"
        },
    }
    Data.grapeInfo = {
        {coords = vector3(-1895.89, 2186.72, 103.15)},
        {coords = vector3(-1871.95,2182.29,110.72)}, 
        {coords = vector3(-1835.87,2176.13,107.67)},
        {coords = vector3(-1847.87,2156.45,116.58)},
        {coords = vector3(-1885.57,2159.57,117.08)},
        {coords = vector3(-1906.76,2147.68,116.28)},
        {coords = vector3(-1867.4,2144.36,123.55)},
        {coords = vector3(-1843.27,2142.36,121.18)},
        {coords = vector3(-1867.39,2121.77,131.43)},
        {coords = vector3(-1902.35,2124.86,126.37)}
    }
    local function RemoveJobBlips()
        if JobBlips then
            for i=1, #JobBlips do
                RemoveBlip(JobBlips[i])
            end
        end
    end
    local function SetJobBlips()
        if ESX.PlayerData.job.name == 'winiarz' then
            for i=1, #Data.pedsInteraction do
                local blip = AddBlipForCoord(Data.pedsInteraction[i].coords)
                SetBlipSprite(blip, 401)
                SetBlipScale(blip, 1.4)
                SetBlipDisplay (blip, 4)
                SetBlipCategory(blip, 3)
                SetBlipColour  (blip, 5)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(Data.pedsInteraction[i].prompt)
                EndTextCommandSetBlipName(blip)
                JobBlips[#JobBlips+1] = blip
            end
        end
    end
    local function ResetProgress()
        DeleteEntity(vehicle)
        pData = {isBusy = false,isWorking = false, vehicle = nil}
        if blips then
            for i=1, #blips do
                RemoveBlip(blips[i])
            end
        end
        RemoveJobBlips()
        for i=1, #grapeZone do
            exports.ox_target:removeZone(grapeZone[i])
        end
    end
    local function createGrapeBlip(coords, index)
        local blip = AddBlipForCoord(coords)
        SetBlipSprite(blip, 594)
        SetBlipScale(blip, 0.5)
        SetBlipDisplay (blip, 4)
        SetBlipCategory(blip, 3)
        SetBlipColour  (blip, 13)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Zbierz Winogrono")
        EndTextCommandSetBlipName(blip)
        blips[index] = blip
    end
    local function startCollectingWine(data)
        pData.isBusy = true
        ESX.Streaming.RequestAnimDict('missmechanic')
        local pos = GetEntityCoords(PlayerPedId())
        local scissorsObj = CreateObject(GetHashKey("p_cs_scissors_s"), pos.x, pos.y, pos.z, true, true, true)
        AttachEntityToEntity(scissorsObj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.01, 0.0, -300.0, -2020.0, 330.0, true, true, false, true, 1, true)
        TaskPlayAnim(PlayerPedId(), 'missmechanic', 'work2_base', 1.0, 1.0, -1, 49, 1.0)
        exports.hp_progressbar:startProgressbar(5000, 'Ścinasz winogrono', {
            Freeze = true,
            onFinish = function()
                ClearPedTasks(PlayerPedId())
                DeleteEntity(scissorsObj)
                TriggerServerEvent('hp_winiarz:harvestedWine', data)
                RemoveBlip(blips[data.index])
                exports.ox_target:removeZone(data.zone)
                pData.isBusy = false
            end,onCancel = function()
                ClearPedTasks(PlayerPedId())
                DeleteEntity(scissorsObj)
                pData.isBusy = false
            end
        })
    end
    local function SpawnGrapeZones()
        ESX.Game.SpawnVehicle('bison3',vector3(-1923.99, 2072.57, 140.26), 346.64, function(vehicle)
            local plate = "WORK"..math.random(1111,9999)
            pData.vehicle = vehicle
            SetVehicleNumberPlateText(vehicle, plate)
            SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
            TriggerServerEvent('hp_winiarnia:cautionCheck', plate)
            for i=1, #Data.grapeInfo do
                local grape = Data.grapeInfo[i]
                createGrapeBlip(grape.coords,i)
                grapeZone[i] = exports.ox_target:addBoxZone({
                    coords = grape.coords,
                    size = vector3(1.5,1.5,1.5),
                    debug = true,
                    drawSprite = true,
                    options = {
                        {
                            label = 'Zbierz winogrono',
                            icon = "fa-solid fa-wine-bottle",
                            index = i,
                            onSelect = function(data)
                                startCollectingWine(data)
                            end,
                            canInteract = function(entity,dist)
                                return dist < 5 and ESX.PlayerData.job.name == 'winiarz' and not pData.isBusy
                            end
                        },
                    },
                })
            end
            
        end)
        
    end
    local function spawnPeds()
        for i=1, #Data.pedsInteraction do
            local pedData = Data.pedsInteraction[i]
            RequestModel(pedData.model)
            while not HasModelLoaded(pedData.model) do
                Wait(0)
            end
            local ped = CreatePed(4, pedData.model,pedData.coords.x, pedData.coords.y, pedData.coords.z, pedData.coords.h, false,false)
            Wait(100)
            SetEntityAsMissionEntity(ped)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            if not pedData.action == 'hp_winiarnia:startWorking' then
                exports.ox_target:addLocalEntity(ped, {
                    {
                        label = pedData.label,
                        event = pedData.action,
                        icon = pedData.icon,
                        canInteract = function(entity,dist)
                            return dist < 3 and ESX.PlayerData.job.name == 'winiarz' and not pData.isBusy
                        end
                    }
                })
            else
                exports.ox_target:addLocalEntity(ped, {
                    {
                        label = pedData.label,
                        event = pedData.action,
                        icon = pedData.icon,
                        canInteract = function(entity,dist)
                            return dist < 3 and ESX.PlayerData.job.name == 'winiarz' and not pData.isBusy and not pData.isWorking
                        end
                    },
                    {
                        label = "Zakończ pracę",
                        event = "hp_winiarnia:stopWorking",
                        icon = pedData.icon,
                        canInteract = function(entity,dist)
                            return dist < 3 and ESX.PlayerData.job.name == 'winiarz' and not pData.isBusy and pData.isWorking
                        end
                    },
                    {
                        label = "Zwróć pojazd",
                        event = "hp_winiarnia:returnVehicle",
                        icon = pedData.icon,
                        canInteract = function(entity,dist)
                            return dist < 3 and ESX.PlayerData.job.name == 'winiarz' and not pData.isBusy and pData.isWorking and pData.vehicle
                        end
                    }
                })
            end
            SetModelAsNoLongerNeeded(pedData.model)
        end
    end

    local function _RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
            RequestModel(model)
        end
    end

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerLoaded = true
        ESX.PlayerData = xPlayer
        RemoveJobBlips()
        SetJobBlips()
    end)
    
    RegisterNetEvent('esx:onPlayerLogout')
    AddEventHandler('esx:onPlayerLogout', function()
        ESX.PlayerLoaded = false
        ESX.PlayerData = {}
    end)
    
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
        RemoveJobBlips()
        SetJobBlips()
        if ESX.PlayerData.job.name ~= 'winiarz' then
            ResetProgress()  

        end
    end)
    RegisterNetEvent('hp_winiarnia:startWorking',function()
        pData.isBusy = true
        exports.hp_progressbar:startProgressbar(10000, 'Przygotowujesz się do pracy', {
            Freeze = true,
            onFinish = function()
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadClothes', skin, Uniforms.male)
                    else
                        TriggerEvent('skinchanger:loadClothes', skin, Uniforms.female)
                    end
                    SpawnGrapeZones()
                    isWorking = true
                    pData.isBusy = false
                end)
            end, onCancel = function()
                pData.isBusy = false
            end
        })        
    end)
    RegisterNetEvent('hp_winiarnia:stopWorking', function()
        pData.isBusy = true
        exports.hp_progressbar:startProgressbar(10000, 'Zdajesz sprzęt służbowy', {
            Freeze = true,
            onFinish = function()
                isWorking = false
                pData.isBusy = false
                ResetProgress() 
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end,onCancel = function()
                pData.isBusy = false
                exports.hp_progressbar:startProgressbar(12000, 'Przetwarzasz sok winogronowy',{
                    Freeze = true,
                    onFinish = function()
                        pData.isBusy = false
                        TriggerServerEvent('hp_winiarnia:swapJuice',canSwap)
                    end,onCancel = function()
                        pData.isBusy = false
                    end
                })
            end
        })
    end)

    RegisterNetEvent('hp_winiarnia:sellWine', function()
        ESX.TriggerServerCallback('hp_winiarnia:getItemCount',function(canSwap)
            if not canSwap then exports.okokNotify:Alert('[WINIARZ]', 'Nie posiadasz wina przy sobie',5000,'error') return end
            pData.isBusy = true
            exports.hp_progressbar:startProgressbar(12000, 'Sprzedajesz wino',{
                Freeze = true,
                onFinish = function()
                    pData.isBusy = false
                    TriggerServerEvent('hp_winiarz:sellWine',canSwap)
                end,onCancel = function()
                    pData.isBusy = false
                end
            })
        end, 'winiarz_wino')
    end)

    RegisterNetEvent('hp_winiarnia:startTransformToWine', function()
        ESX.TriggerServerCallback('hp_winiarnia:getItemCount',function(canSwap)
            if not canSwap then exports.okokNotify:Alert('[WINIARZ]', 'Nie posiadasz soku winogronowego przy sobie!', 5000,'error') return end
            pData.isBusy = true
            exports.hp_progressbar:startProgressbar(12000, 'Przetwarzasz sok winogronowy',{
                Freeze = true,
                onFinish = function()
                    TriggerServerEvent('hp_winiarnia:swapJuice',canSwap)   
                end,onCancel = function()
                end
            })
        end,'winiarz_winejuice')
    end)
    RegisterNetEvent('hp_winiarnia:startTransformWine',function()
        ESX.TriggerServerCallback('hp_winiarnia:getItemCount',function(canSwap)
            if not canSwap then exports.okokNotify:Alert('[WINIARZ]', 'Nie posiadasz przy sobie winogron!', 5000, 'error') return end
            pData.isBusy = true
            exports.hp_progressbar:startProgressbar(12000, 'Przetwarzasz winogrono',{
                Freeze = true,
                onFinish = function()
                    TriggerServerEvent('hp_winiarnia:swapGrape',canSwap)
                    pData.isBusy = false
                end,onCancel = function()
                    pData.isBusy = false
                end
            })
        end, 'winiarz_winogrono')
    end)
    RegisterNetEvent('hp_winiarnia:returnVehicle',function(data)
        if not DoesEntityExist(pData.vehicle) then return end
        local vehCoords = GetEntityCoords(pData.vehicle)
        local distance = #(vehCoords - GetEntityCoords(PlayerPedId()))
        if not distance < 30 then exports.okokNotify:Alert('WINIARZ','Musisz podjechać bliżej miejsca skąd brałeś pojazd!', 5000, 'error') return end
        TriggerServerEvent('hp_winiarnia:returnCaution',pData.vehicle)
        DeleteVehicle(pData.vehicle)
        pData.vehicle = nil  
    end)
    CreateThread(function()
        Wait(2000)
        spawnPeds()
    end)
]]

ESX.RegisterServerCallback('hp_winiarnia:getItemCount', function(playerId, cb, item)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local itemCount = exports.ox_inventory:Search(playerId, 'count', item)
    if itemCount then
        if itemCount > 0 then
            cb(true)
        end
    else
        cb(false)
    end
end)

RegisterNetEvent('7XBTPiLTjTKbpd1_Wp9ireiYa2n34K0:ZTnMO9Hu6mccVlk', function()
    if loadedClientSide[source] then exports.hp_logs:cheatAlert(source, 'Próba striggerowania kodu po załadowaniu skryptu') return end
    TriggerClientEvent('DLbFwSxSL7HsGwdr043Bovjh:sGswr0Bovjh', source,l)
    loadedClientSide[source] = true
end)
RegisterNetEvent('hp_winiarz:harvestedWine', function(data)
    if not data then exports.hp_logs:cheatAlert(source, 'Brak data w argumencie funkcji') return end
    local xPlayer = ESX.GetPlayerFromId(source)
    if exports.ox_inventory:CanCarryItem(source, 'winiarz_winogrono', 1) then
        exports.ox_inventory:AddItem(source, 'winiarz_winogrono', 1)
        TriggerEvent('hp-logs:sendLog', source, '[WINIARZ]','**Gracz: **'..GetPlayerName(source)..'\n**Zebrał winogron: 1x winogron**', 'hp_winiarz_zebral')
        xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Zebrałeś 1 dorodną kiść winogrono', 5000, 'info')
    else
        xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Nie uniesiesz więcej winogrona..', 5000, 'info')
    end
end)
RegisterNetEvent('hp_winiarz:sellWine', function(canSwap)
    if not canSwap then exports.hp_logs:cheatAlert(source, 'Naruszony trigger do przerabiania soku winogronowego w wino') return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local wine = exports.ox_inventory:Search(source, 'count', 'winiarz_wino')
    if not wine then return end
    if wine > 0 then
        xPlayer.removeInventoryItem('winiarz_wino', wine)
        xPlayer.addAccountMoney('bank',math.floor(wine * 500))
        TriggerEvent('hp-logs:sendLog', source, '[WINIARZ]','**Gracz: **'..GetPlayerName(source)..'\n**Sprzedał: ** winiarz_wino \n**Ilość: **'..wino..'\n**Za kwotę: **: '..math.floor(wine *500), 'hp_winiarz_przerobil')
        xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Udało Ci się sprzedać wino za: '..math.floor(wine * 500), 5000, 'success')
    end
end)
RegisterNetEvent('hp_winiarnia:swapJuice', function(canSwap)
    if not canSwap then exports.hp_logs:cheatAlert(source, 'Naruszony trigger do przerabiania soku winogronowego w wino') return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local grapeJuice = exports.ox_inventory:Search(source, 'count', 'winiarz_winejuice')
    if not grapeJuice then return end
    if grapeJuice > 0 then
        xPlayer.removeInventoryItem('winiarz_winejuice', 1)
        xPlayer.addInventoryItem('winiarz_wino', 1)
        TriggerEvent('hp-logs:sendLog', source, '[WINIARZ]','**Gracz: **'..GetPlayerName(source)..'\n**Przerobił: ** winiarz_winejuice na winiarz_wino', 'hp_winiarz_przerobil')
        xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Udało Ci się przerobić sok winogronowy na dobre wino!', 5000, 'success')
    end
end)
RegisterNetEvent('hp_winiarnia:swapGrape', function(canSwap)
    if not canSwap then exports.hp_logs:cheatAlert(source, 'Naruszony trigger do przerabiania winogrona w winogron') return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local grapeCount = exports.ox_inventory:Search(source, 'count', 'winiarz_winogrono')
    if not grapeCount then return end
    if grapeCount > 0 then 
        xPlayer.removeInventoryItem('winiarz_winogrono', 1)
        xPlayer.addInventoryItem('winiarz_winejuice', 1)
        xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Udało Ci się przerobić winogrona w dobry sok winogronowy', 5000, 'success')
        TriggerEvent('hp-logs:sendLog', source, '[WINIARZ]','**Gracz: **'..GetPlayerName(source)..'\n**Przerobił: ** winiarz_winogrono na winiarz_winejuice', 'hp_winiarz_przerobil')
    end

end)
RegisterNetEvent('hp_winiarnia:cautionCheck', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    local veh = GetVehiclePedIsIn(ped, false)
    if not GetVehicleNumberPlateText(veh) == plate then exports.hp_logs:cheatAlert(source, 'Odebranie aukcji bez zgadzającej się rejestracji auta') return end
    xPlayer.removeAccountMoney('bank', 500)
    cautionPlayers[source][plate] = plate
    xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Została Ci zabrana kaucja z konta bankowego za wypożyczenie pojazdu.', 5000, 'info')
end)
RegisterNetEvent('hp_winiarnia:returnCaution', function(veh)
    if not veh then exports.hp_logs:cheatAlert(source, 'Próba zwrotu kaucji za pojazd nie wyciągając go') return end
    if not cautionPlayers[source][plate] then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = GetVehicleNumberPlateText(veh)
    if cautionPlayers[source][plate] == plate then
        cautionPlayers[source][plate] = nil
        xPlayer.addAccountMoney('bank', 500)
        xPlayer.triggerEvent('okokNotify:Alert', '[WINIARZ]', 'Zwrócono Ci pieniądze za kaucje na konto bankowe.', 5000, 'info')
    end
    

end)
--[[
    ['winiarz_winejuice'] = {
        label = "Sok winogronowy",
        weight = 100,
        close = false,
        stack = true,
        description = 'Sok winogronowy gotowy do rozlania w butelki',
        client = {
			status = { thirst = 200000 },
        }
    },
    ['winiarz_wino'] = {
        label = "Wino ze świeżych winogron",
        weight = 150,
        close = false,
        stack = true,
        description = 'Wino wytrawne. 14% objętości alkoholu',
    }
]]

