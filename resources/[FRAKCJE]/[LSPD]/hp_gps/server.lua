ESX = exports["es_extended"]:getSharedObject()
local GPSs = {}

local function UpdateGps()
    for k, v in pairs(GPSs) do
        TriggerClientEvent("hp_gps:UpdateGPSlist", k, GPSs)
    end
end

local function RemoveTarget(TargetID, lost, coords)
    for k, v in pairs(GPSs) do
        TriggerClientEvent("hp_gps:RemoveTarget", k, TargetID, lost, coords)
    end
end

lib.callback.register("hp_gps:RegisterGPS", function(source, badgeData)
    local xPlayer = ESX.GetPlayerFromId(source)

    if GPSs[source] ~= true then
        if badgeData then
            GPSs[source] = {
                fullname = xPlayer.getName(),
                job = xPlayer.getJob().name,
                grade_label = xPlayer.getJob().grade_label,
                badgenumber = badgeData.number,
            }
        else
            GPSs[source] = {
                fullname = xPlayer.getName(),
                job = xPlayer.getJob().name,
                grade_label = xPlayer.getJob().grade_label,
                badgenumber = "unidentified",
            }
        end
        UpdateGps()
        return true
    end
    return false
end)

RegisterNetEvent("hp_gps:UnRegisterGPS", function(lost, coords)
    GPSs[source] = nil

    RemoveTarget(source, lost, coords)
end)

lib.callback.register("hp_gps:RecieveGPS", function(source)
    return GPSs
end)

AddEventHandler('playerDropped', function(reason)
    GPSs[source] = nil
    RemoveTarget(source, false)
end)