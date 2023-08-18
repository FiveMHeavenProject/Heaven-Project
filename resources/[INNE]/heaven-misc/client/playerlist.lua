---@diagnostic disable: missing-parameter
local CheckingPlayersDecor = "_IS_CHECKING_ID"

Citizen.CreateThread(function()
    DecorRegister(CheckingPlayersDecor, 1)
end)

local players = {}
RegisterNetEvent('heaven-misc:updateConnectedPlayers')
AddEventHandler('heaven-misc:updateConnectedPlayers', function(connectedPlayers)
	players = connectedPlayers

    local authorities = {
        ["police"] = 0,
        ["ambulance"] = 0,
        ["mechanic"] = 0,
        ["doj"] = 0
    }
    playercount = 0;
    for k, v in pairs(players) do
        playercount = playercount + 1
        if authorities[v.job] then
            authorities[v.job] = authorities[v.job] + 1
        end
    end

    SendNUIMessage({
        action = 'updateInfo',
        players = playercount,
        police = authorities["police"],
        ems = authorities["ambulance"],
        mechanic = authorities["mechanic"],
        doj = authorities["doj"],
    })
end)

local function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2.5
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then

        SetTextScale(0.7 * scale, scale)
        SetTextFont(4)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- Sprawdzanie id graczy w pobliżu
RegisterCommand("CheckClosePlayers", function()
    DecorSetInt(PlayerPedId(), CheckingPlayersDecor, 1)
    SendNUIMessage({
        action = 'toggle',
        state = true,
    })
    while IsControlPressed(0, 20) do
        local playerPed = PlayerPedId()
        local PlayersTab = GetActivePlayers()
        for k, v in pairs(PlayersTab) do
            local TargetPlayer = GetPlayerServerId(v)
            local TargetPed = Citizen.InvokeNative(0x43A66C31C68491C0, v)
            local TargetCoords = GetPedBoneCoords(TargetPed, 31086, -0.4, 0.0, 0.0)
            if #(TargetCoords - GetEntityCoords(playerPed)) < 25 then
                local ssn = players[TargetPlayer] and players[TargetPlayer].ssn or 'null'
                DrawText3D(TargetCoords.x, TargetCoords.y, TargetCoords.z + 1.0, TargetPlayer..' ['..ssn..']', (NetworkIsPlayerTalking(v) and {0, 0, 255} or {255, 255, 255}))
            end
        end
        Wait(1)
    end
    SendNUIMessage({
        action = 'toggle',
        state = false,
    })
    DecorRemove(PlayerPedId(), CheckingPlayersDecor)
end)

-- Podświetlanie osób używających z'tki w pobliżu
CreateThread(function()
    local sleep = true
    while true do
        if not sleep then
            sleep = true
            local playerPed = PlayerPedId()
            for k, v in pairs(GetActivePlayers()) do
                local TargetPlayer = GetPlayerServerId(v)
                local TargetPed = Citizen.InvokeNative(0x43A66C31C68491C0, v)
                if TargetPed ~= playerPed then
                    local TargetCoords = GetEntityCoords(TargetPed)
                    if DecorExistOn(TargetPed, CheckingPlayersDecor) then
                        if #(TargetCoords - GetEntityCoords(playerPed)) < 25 and not IsControlPressed(0, 20) then
                            sleep = false
                            DrawText3D(TargetCoords.x, TargetCoords.y, TargetCoords.z + 1.2, TargetPlayer, {0, 0, 255})
                        end
                    end
                end
            end
        else
            sleep = false
            Wait(250)
        end
        Wait(1)
    end
end)

RegisterKeyMapping("CheckClosePlayers", "Sprawdź id pobliskich graczy", "keyboard", "z")