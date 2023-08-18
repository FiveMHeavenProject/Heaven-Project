StoreVehicle = function(vehicle, garage)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    ESX.TriggerServerCallback('xrp_garage:checkVehicleOwner', function(IsOwner)
        if not IsOwner then return ESX.ShowNotification("To nie twój pojazd", 'error') end

        ESX.Game.DeleteVehicle(vehicle)
        TriggerServerEvent('xrp_garage:updateOwnedVehicle', true, garage, { vehicleProps = vehicleProps })
    end, vehicleProps.plate)
end

TaskSpawnVeh = function(stored, data)
    local playerPed = PlayerPedId()
    local spawncoords = GetEntityCoords(playerPed)

    RequestModel(data.model)
    while not HasModelLoaded(data.model) do
        Wait(100)
    end

    if not IsPedInAnyVehicle(playerPed, false) then
        if inZone then
            if ESX.Game.IsSpawnPointClear(spawncoords, 2.5) and inZone then
                TriggerServerEvent('xrp_garage:updateOwnedVehicle', stored, nil, { vehicleProps = data }, spawncoords,
                    GetEntityHeading(playerPed))
            else
                ESX.ShowNotification("Miejsce spawnu jest zajęte", "error", 3000)
            end
        else
            ESX.ShowNotification("Oddaliłeś się od garażu", "error", 3000)
        end
    end
end

OpenGarageMenu = function(job)
    ESX.TriggerServerCallback('xrp_garage:getVehiclesInParking', function(vehicles)
        local elements = {}
        for i = 1, #vehicles, 1 do
            table.insert(elements,
                {
                    label = GetDisplayNameFromVehicleModel(vehicles[i].vehicle.model),
                    value = vehicles[i].vehicle.model,
                    props = vehicles[i].vehicle
                })
        end


        if #elements == 0 then
            ESX.ShowNotification("Nie masz żadnych samochodów", "error", 3000)
        else
            SendNUIMessage({
                vehicles = elements,
                action = "openGarage"
            })
            SetNuiFocus(true, true)
        end
    end, job)
end

OpenImpoundMenu = function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        ESX.TriggerServerCallback('xrp_garage:getVehiclesInImpound', function(vehicles)
            local elements = {}
            for i = 1, #vehicles, 1 do
                table.insert(elements,
                    {
                        label = GetDisplayNameFromVehicleModel(vehicles[i].vehicle.model) ..
                            " | <span style='color: tomato;'>" .. Config.ImpoundPrice .. "$</span>",
                        value = vehicles[i].vehicle.model,
                        props = vehicles[i].vehicle
                    })
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage', {
                title    = 'Odholuj pojazd',
                align    = 'right',
                elements = elements
            }, function(data, menu)
                if data.current.value ~= nil then
                    ESX.TriggerServerCallback("xrp_garage:hasMoney", function(cb)
                        if cb then
                            TaskSpawnVeh(false, data.current.props)
                        else
                            ESX.ShowNotification("Nie masz wystarczająco pieniędzy", "error", 2000)
                        end
                    end, Config.ImpoundPrice)

                    menu.close()
                end
            end, function(data, menu)
                menu.close()
            end)
        end)
    end
end



-- ROBOCZE

RegisterNUICallback('closeGarage', function(data, cb)
    SendNUIMessage({
        action = "closeGarage"
    })
    SetNuiFocus(false, false)
end)

RegisterNUICallback('selectCar', function(data, cb)
    TaskSpawnVeh(false, data.selectedCar)
    SendNUIMessage({
        action = "closeGarage"
    })
    SetNuiFocus(false, false)
end)

RegisterCommand("test-menu", function()
    local Elements = {
        { label = "Zakuj/Rozkuj",       name = "element1" },
        {
            label = "Bread - £200",
            name = "bread",
            value = 1,
            type =
            'slider',
            min = 1,
            max = 100
        },
        { label = '<span>SRAKA!/span>', name = "geen_element" }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Example_Menu", {
        title    = "Kajdanki", -- The Name of Menu to show to users,
        align    = 'center',   -- top-left | top-right | bottom-left | bottom-right | center |
        elements = Elements    -- define elements as the pre-created table
    }, function(data, menu)    -- OnSelect Function
        --- for a simple element
        if data.current.name == "element1" then
            print("Element 1 Selected")
            menu.close()
        end

        -- for slider elements

        if data.current.name == "bread" then
            print(data.current.value)

            if data.current.value == 69 then
                print("Nice!")
                menu.close()
            end
        end
    end, function(data, menu) -- Cancel Function
        print("Closing Menu")
        menu.close()          -- close menu
    end)
end)



exports("OpenGarageMenu", OpenGarageMenu)
exports("OpenImpoundMenu", OpenImpoundMenu)
