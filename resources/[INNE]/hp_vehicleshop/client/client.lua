local lastSelectedVehicleEntity
local startCountDown
local testDriveEntity
local lastPlayerCoords
local inTheShop = false
local lokalnaSprzedazAuta = {
	{ -50.9230, -1113.7290, 26.4358 },
}
local cd = 0

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-32.04, -1097.46, 27.27)
    SetBlipSprite(blip, 326)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Car Dealer')
    EndTextCommandSetBlipName(blip)

    for i = 1, #lokalnaSprzedazAuta do
        local coords = lokalnaSprzedazAuta[i]
        local blip2 = AddBlipForCoord(coords[1], coords[2], coords[3])
        SetBlipSprite(blip2, 500)
        SetBlipDisplay(blip2, 4)
        SetBlipScale(blip2, 0.8)
        SetBlipAsShortRange(blip2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Sprzedaż Aut')
        EndTextCommandSetBlipName(blip2)
    end

    exports['qtarget']:AddBoxZone("vehicleshop", vec3(-32.04, -1097.46, 25.27), 1.4, 5.6, {
        name="vehicleshop",
        heading=91,
        debugPoly=false,
        minZ = 26.27,
        maxZ = 27.57,
    }, {
        options = {
            {
                event = "nt_vehicleshop:openShop",
                icon = "fas fa-car",
                label = "Przejrzyj pojazdy",
            }
        },
        job = {"all"},
        distance = 1.5
    })
end)

RegisterNetEvent('nt_vehicleshop:sussessbuy')
AddEventHandler('nt_vehicleshop:sussessbuy', function(vehicleName, vehiclePlate, value)
    CloseNui()
end)

local vehiclesTable = {}
local provisoryObject = {}

RegisterNetEvent('nt_vehicleshop:vehiclesInfos')
AddEventHandler('nt_vehicleshop:vehiclesInfos', function(tableVehicles)
    for _, value in pairs(tableVehicles) do
        vehiclesTable[value.category] = {}
    end
    for _, value in pairs(tableVehicles) do
        local vehicleModel = joaat(value.model)
        local brandName = GetLabelText(GetMakeNameFromVehicleModel(vehicleModel))
        provisoryObject = {
            brand = brandName,
            name = value.name,
            price = value.price,
            model = value.model
        }
        vehiclesTable[value.category][#vehiclesTable[value.category] + 1] = provisoryObject
    end
end)

RegisterNetEvent('nt_vehicleshop:openShop', function()
    if cd > 0 then
        return ESX.ShowNotification("Cooldown! Odczekaj jeszcze "..ESX.Math.Round(cd/10, 1).." sekund!")
    end
    inTheShop = true
    local ped = PlayerPedId()
    TriggerServerEvent("nt_vehicleshop:requestInfo")
    Citizen.Wait(500)
    SendNUIMessage({
        data = vehiclesTable,
        type = "display"
    })
    SetNuiFocus(true, true)
    RequestCollisionAtCoord(x, y, z)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -45.5528, -1093.0923, 26.4224, -10.0, 0.0, 170.0, 40.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1, true, true)
    SetFocusPosAndVel(-46.86, -1085.10, 28.27, 295.5, 0.0, 0.0)
    TriggerEvent('hideHud')
    if lastSelectedVehicleEntity ~= nil then
        DeleteEntity(lastSelectedVehicleEntity)
    end
end)

function updateSelectedVehicle(model)
    local hash = joaat(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    if lastSelectedVehicleEntity ~= nil then
        DeleteEntity(lastSelectedVehicleEntity)
    end

    lastSelectedVehicleEntity = CreateVehicle(hash, -47.2496, -1098.9601, 26.4224, 32.0242, 295.5, 0, 1)
    FreezeEntityPosition(lastSelectedVehicleEntity, true)
    local vehicleData = {}
    vehicleData.traction = GetVehicleMaxTraction(lastSelectedVehicleEntity)
    vehicleData.breaking = GetVehicleMaxBraking(lastSelectedVehicleEntity) * 0.9650553
    if vehicleData.breaking >= 1.0 then
        vehicleData.breaking = 1.0
    end
    vehicleData.maxSpeed = GetVehicleEstimatedMaxSpeed(lastSelectedVehicleEntity) * 0.9650553
    if vehicleData.maxSpeed >= 50.0 then
        vehicleData.maxSpeed = 50.0
    end
    vehicleData.acceleration = GetVehicleAcceleration(lastSelectedVehicleEntity) * 2.6
    if  vehicleData.acceleration >= 1.0 then
        vehicleData.acceleration = 1.0
    end
    SendNUIMessage({
        data = vehicleData,
        type = "updateVehicleInfos",
    })
    SetEntityHeading(lastSelectedVehicleEntity, 295.5)
end

function rotation(dir)
    local entityRot = GetEntityHeading(lastSelectedVehicleEntity) + dir
    SetEntityHeading(lastSelectedVehicleEntity, entityRot % 360)
end

local shouldrotate = false
function rotationHandler()
    while shouldrotate and inTheShop do
        Citizen.Wait(8)
        rotation(-0.5)
    end
end

RegisterNUICallback("rotate", function(data, cb)
    if shouldrotate == data.rot then return end
    shouldrotate = data.rot
    if (data.key == "left") then
        while shouldrotate and inTheShop do
            print('a')
            Citizen.Wait(8)
            rotation(0.5)
        end
    elseif(data.key == "right") then
        while shouldrotate and inTheShop do
            Citizen.Wait(8)
            rotation(-0.5)
        end
    end
    cb("ok")
end)

RegisterNUICallback("SpawnVehicle", function(data, cb)
    if inTheShop then
        updateSelectedVehicle(data.modelcar)
    end
end)

RegisterNUICallback("Buy", function(data, cb)
    local newPlate = GeneratePlate()
    local vehicleProps = ESX.Game.GetVehicleProperties(lastSelectedVehicleEntity)
    vehicleProps.plate = newPlate
    TriggerServerEvent('nt_vehicleshop:CheckMoneyForVeh', data.modelcar, data.paymenttype, vehicleProps)
end)

RegisterNetEvent('nt_vehicleshop:spawnVehicle')
AddEventHandler('nt_vehicleshop:spawnVehicle', function(model, plate)
    local hash = joaat(model)
    lastPlayerCoords = GetEntityCoords(PlayerPedId())
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    local vehicleBuy = CreateVehicle(hash, -11.87, -1080.87, 25.71, 132.0, 1, 1)
    SetPedIntoVehicle(PlayerPedId(), vehicleBuy, -1)
    print(plate)
    SetVehicleNumberPlateText(vehicleBuy, plate)
end)

RegisterNUICallback("TestDrive", function(data, cb)
    startCountDown = true
    local hash = joaat(data.vehicleModel)
    lastPlayerCoords = GetEntityCoords(PlayerPedId())
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    if testDriveEntity ~= nil then
        DeleteEntity(testDriveEntity)
    end
    SetEntityCoords(PlayerPedId(), vector3(-2128.68,1105.84,-26.79))
    local interior = GetInteriorAtCoords(vector3(-2128.68,1105.84,-27.79))
    local room = GetRoomKeyFromEntity(GetPlayerPed(PlayerId()))
    testDriveEntity = CreateVehicle(hash, vector3(-2128.68,1105.84,-26.79), 312.0, 1, 1)
    SetPedIntoVehicle(PlayerPedId(), testDriveEntity, -1)
    RefreshInterior(interior)
    ForceRoomForEntity(testDriveEntity, interior, room)
    local timeGG = GetGameTimer()
    CloseNui()
    while startCountDown do
        local countTime
        if GetGameTimer() < timeGG + tonumber(1000 * Config.TestDriveTime) then
            local secondsLeft = GetGameTimer() - timeGG
            drawTxt('Jazda testowa: ' .. math.ceil(Config.TestDriveTime - secondsLeft/1000), 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)

            if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                DeleteEntity(testDriveEntity)
                SetEntityCoords(PlayerPedId(), lastPlayerCoords)
                startCountDown = false
                break
            end
        else
            DeleteEntity(testDriveEntity)
            SetEntityCoords(PlayerPedId(), lastPlayerCoords)
            startCountDown = false
        end
        Citizen.Wait(0)
    end
    -- dodane
    SetCooldown()
    DeleteEntity(testDriveEntity)
end)

RegisterNUICallback("menuSelected", function(data, cb)
    local categoryVehicles
    local playerIdx = GetPlayerFromServerId(source)
    local ped = GetPlayerPed(playerIdx)
    if data.menuId ~= 'all' then
        categoryVehicles = vehiclesTable[data.menuId]
    else
        SendNUIMessage({
            data = vehiclesTable,
            type = "display",
            playerName = GetPlayerName(ped)
        })
        return
    end
    SendNUIMessage({
        data = categoryVehicles,
        type = "menu"
    })
end)

RegisterNUICallback("Close", function(data, cb)
    CloseNui()
end)

function CloseNui()
    SendNUIMessage({
        type = "hide"
    })
    SetNuiFocus(false, false)
    if inTheShop then
        if lastSelectedVehicleEntity ~= nil then
            DeleteVehicle(lastSelectedVehicleEntity)
        end
        RenderScriptCams(false)
        DestroyAllCams(true)
        SetFocusEntity(GetPlayerPed(PlayerId())) 
        --DisplayHud(true)
        --DisplayRadar(true)
        TriggerEvent('showHud')
    end
    inTheShop = false
    SetCooldown()
end

function SetCooldown()
    CreateThread(function()
        cd = 30
        while cd > 0 do
            Wait(100)
            cd = cd - 0.1
        end
    end)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseNui()
        RemoveBlip(blip)
    end
end)

RegisterNetEvent('nt_vehicleshop:checkRentCar')
AddEventHandler('nt_vehicleshop:checkRentCar', function()
    if testDriveEntity ~= nil then
        DeleteEntity(testDriveEntity)
    end
end)