ESX = exports["es_extended"]:getSharedObject()
inZone, curZone, ZoneType = false, nil, nil

Citizen.CreateThread(function() 
    for name, values in pairs(Config.Garages) do
        local poly = lib.zones.poly({
            points = values.points,
            thickness = values.thickness,
            groups = {
                police
            },
            debug = false,
            onEnter = function(self)
                inZone = true
                curZone = name
                ZoneType = "garage"
                ESX.ShowNotification("Wszedłeś w strefe garażu. Wciśnij E aby otworzyć menu", "info", 4000)
            end,
            onExit = function()
                inZone = false
                curZone = nil
                ZoneType = nil
            end
        })
    end
    
    for name, values in pairs(Config.Impounds) do
        local poly = lib.zones.poly({
            points = values.points,
            thickness = values.thickness,
            debug = false,
            onEnter = function(self)
                inZone = true
                curZone = name
                ZoneType = "impound"
                ESX.ShowNotification("Wszedłeś w strefe holownika. Wciśnij E aby otworzyć menu", "info", 4000)
            end,
            onExit = function()
                inZone = false
                curZone = nil
                ZoneType = nil
            end
        })
    end
end)



RegisterCommand("GarageHandler", function()
    if not inZone then return end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if ZoneType == "garage" then
        if vehicle == 0 then
            OpenGarageMenu()
        else
            StoreVehicle(vehicle, curZone)
        end
    elseif ZoneType == "impound" then
        OpenImpoundMenu()
    end

end)

RegisterKeyMapping("GarageHandler", "Schowaj, wyciągnij lub odholuj pojazd", "keyboard", "e")

local blips = {}

Citizen.CreateThread(function()
    RequestModel(`atlas`)

    for _, info in pairs(Config.Garages) do
        local blip = AddBlipForCoord(info.blipcoords)
        SetBlipSprite(blip, info.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, info.Scale)
        SetBlipColour(blip, info.Colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garaż")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end

    for _, info in pairs(Config.Impounds) do
        local blip = AddBlipForCoord(info.blipcoords)
        SetBlipSprite(blip, info.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, info.Scale)
        SetBlipColour(blip, info.Colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garaż")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end
end)

