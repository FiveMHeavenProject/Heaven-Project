ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("chuj", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(xPlayer.identifier)
    print(xPlayer.org)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    local organisations = {}
    local numOrganisations = 3
    local numId = 5

    for i = 1, numOrganisations do
        local ID = {}

        for j = 1, numId do
            ID["ID_"..j] = "value"..i
        end
        organisations["Organisations_"..i] = ID
    end
    

    print(json.encode(organisations))
end)


local carrying = {}
local carried = {}

RegisterServerEvent("xrp_carry:sync")
AddEventHandler("xrp_carry:sync", function(targetSrc)
	local source = source
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
        local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 3.0 then 
		TriggerClientEvent("xrp_carry:syncTarget", targetSrc, source)
		carrying[source] = targetSrc
		carried[targetSrc] = source
	end
end)

RegisterServerEvent("xrp_carry:stop")
AddEventHandler("xrp_carry:stop", function(targetSrc)
	local source = source

	if carrying[source] then
		TriggerClientEvent("xrp_carry:cl_stop", targetSrc)
		carrying[source] = nil
		carried[targetSrc] = nil
	elseif carried[source] then
		TriggerClientEvent("xrp_carry:cl_stop", carried[source])			
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if carrying[source] then
		TriggerClientEvent("xrp_carry:cl_stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	end

	if carried[source] then
		TriggerClientEvent("xrp_carry:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_sit:getPlace', function(source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)