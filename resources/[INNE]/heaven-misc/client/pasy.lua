local Config = {
    ejectVelocity = (120 / 3.6),
    unknownEjectVelocity = (120 / 3.6),
    unknownModifier = 17.0,
    minDamage = 2000,
}

SetFlyThroughWindscreenParams(Config.ejectVelocity, Config.unknownEjectVelocity, Config.unknownModifier, Config.minDamage)
local seatbeltOn = false



CreateThread(function()
    while true do
        Wait(10)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if seatbeltOn then
                DisableControlAction(0, 75, true) -- Disable exit vehicle when stop
                DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
                toggleUI(false)
            else
                toggleUI(true)
            end
        else 
            if seatbeltOn then
                seatbeltOn = false
                toggleSeatbelt(false, false)
            end
            toggleUI(false)
            Wait(1000)
        end
    end
end)

function toggleSeatbelt(makeSound, toggle)
    if not toggle then
        if seatbeltOn then
            playSound('beltoff') --false unbuckle
            SetFlyThroughWindscreenParams(Config.ejectVelocity, Config.unknownEjectVelocity, Config.unknownModifier, Config.minDamage)
        else
            playSound('belton') -- true buckle
            SetFlyThroughWindscreenParams(10000.0, 10000.0, 17.0, 500.0);
        end
        seatbeltOn = not seatbeltOn
    else
        if toggle then
            playSound('belton') -- true buckle
            SetFlyThroughWindscreenParams(10000.0, 10000.0, 17.0, 500.0);
        else
            playSound('beltoff') --false unbuckle
            SetFlyThroughWindscreenParams(Config.ejectVelocity, Config.unknownEjectVelocity, Config.unknownModifier, Config.minDamage)
        end
        seatbeltOn = toggle
    end
end

function playSound(action)
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    local maxpeds = GetVehicleMaxNumberOfPassengers(vehicle) - 2
    local passengers = {}
    for i = -1, maxpeds do
        if not IsVehicleSeatFree(vehicle, i) then
            local ped = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, i)))
            passengers[#passengers+1] = ped
        end
    end
    TriggerServerEvent('heaven-misc:pasy', action, passengers)
end

local toggleIcon = false
function toggleUI(status)
    if toggleIcon ~= status then
        toggleIcon = status
        TriggerEvent('xrp_core:BeltStatusChange', toggleIcon)
    end
end

RegisterCommand('pasy', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local class = GetVehicleClass(GetVehiclePedIsIn(ped))
        if class ~= 8 and class ~= 13 and class ~= 14 then
            toggleSeatbelt(true)
        end
    end
end)

RegisterKeyMapping('pasy', 'Zapinanie pasów', 'keyboard', 'B')