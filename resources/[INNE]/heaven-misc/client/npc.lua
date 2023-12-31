SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_LOST"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_WEICHENG"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("ARMY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("DEALER"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("CIVMALE"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("HEN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("PRIVATE_SECURITY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("SECURITY_GUARD"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AGGRESSIVE_INVESTIGATE"), GetHashKey('PLAYER'))

CreateThread(function()
	local id = GetPlayerServerId(PlayerId())
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', '~b~Heaven Project ~c~| ~b~ID: ~w~'..id..' ('..GetPlayerName(PlayerId())..')')
	Citizen.InvokeNative(0xC54A08C85AE4D410, 0.5)
	DisablePlayerVehicleRewards(PlayerId())
end)

CreateThread(function()
	while true do
		Wait(5)
		
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(14)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(19)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)
		HideHudComponentThisFrame(141)
	end
end)

-- remove health and armour stats on minimap

CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end

end)