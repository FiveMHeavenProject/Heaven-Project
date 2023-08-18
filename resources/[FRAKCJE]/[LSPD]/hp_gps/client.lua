ESX = exports["es_extended"]:getSharedObject()
local UsingGPS = false
local GPSs = {}
local blips = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

    if UsingGPS then
        if Config.RestrictedJobs[ESX.PlayerData.job.name] ~= nil then
            UsingGPS = true

            RegisterGPS()
        end
    end
end)

local function RefreshGPS()
    local job = ESX.PlayerData.job.name

    for k, v in pairs(GPSs) do
        if Config.RestrictedJobs[job][v.job] == true then
            local TargetPed = GetPlayerPed(GetPlayerFromServerId(k))
            if GetBlipFromEntity(TargetPed) == 0 then
                print("TARGET: "..TargetPed)
                local blip = AddBlipForEntity(TargetPed)
                SetBlipSprite(blip, 1)
                SetBlipColour(blip, Config.BlipData[v.job].color)
                SetBlipCategory(blip, 7)
                SetBlipAsShortRange(blip, false)
                SetBlipDisplay(blip, 2)
                PulseBlip(blip)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("#["..v.badgenumber.."] "..v.grade_label.." "..v.fullname)
                EndTextCommandSetBlipName(blip)
                blips[k] = blip
                print(k)
            end
        end
    end
end

local function RegisterGPS()
    local badge = exports["hp_badges"]:GetDefaultBadge()
    local success = lib.callback.await("hp_gps:RegisterGPS", false, badge)

    if success then
        GPSs = lib.callback.await("hp_gps:RecieveGPS", false)

        PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
        ESX.ShowNotification("GPS aktywowany")

        RefreshGPS()
    else
        ESX.ShowNotification(GetCurrentResourceName().." - Wystapil blad, zglos to do administracji")
    end
end

local function RemoveTarget(id)
    RemoveBlip(blips[id])
    blips[id] = nil
    GPSs[id] = nil
end

local function RemoveBlips()
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    blips = {}
    GPSs = {}
end

local function UnRegisterGPS()
    TriggerServerEvent("hp_gps:UnRegisterGPS", false)

    PlaySoundFrontend(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 1)
    ESX.ShowNotification("GPS dezaktywowany")

    RemoveBlips()
end

exports("UseGPS", function()
    local elements = {
        {label = "Wlacz GPS", value = "on"},
        {label = "Wylacz GPS", value = "off"},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'GPS', {
        title    = 'GPS - Wybierz opcje',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        if data.current.value == "on" then
            if UsingGPS then return end
            if Config.RestrictedJobs[ESX.PlayerData.job.name] == nil then return (ESX.ShowNotification("Nie mozesz uzyc tego przedmiotu")) end
            UsingGPS = true

            menu.close()

            RegisterGPS()
        elseif data.current.value == "off" then
            if not UsingGPS then return end
            UsingGPS = false

            menu.close()

            UnRegisterGPS()
        end
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('hp_gps:UpdateGPSlist')
AddEventHandler('hp_gps:UpdateGPSlist', function(gps)
    GPSs = gps

    RefreshGPS()
end)

RegisterNetEvent('hp_gps:RemoveTarget')
AddEventHandler('hp_gps:RemoveTarget', function(id, lost, coords)
    if blips[id] then
        local FullName = GPSs[id].fullname
        RemoveTarget(id)
        if lost then
            if coords then
                ESX.ShowNotification("Utracono polaczenie z nadajnikiem "..FullName, "info")
                local blip = AddBlipForCoord(coords)
                SetBlipSprite(blip, 1)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, 5)
                SetBlipAsShortRange(blip, false)
                SetBlipFlashTimer(blip, 7000)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('# OSTATNIA POZYCJA NADAJNIKA '..FullName)
                EndTextCommandSetBlipName(blip)
                for i=1,3,1 do
                    PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
                    Citizen.Wait(500)
                end
                Citizen.Wait(45000)
                RemoveBlip(blip)
            end
        end
    end
end)

AddEventHandler('esx:removeInventoryItem', function(item, count)
    if item == "gps" then
        local GpsCount = exports.ox_inventory:Search('count', 'gps')
        if GpsCount <= 0 then
            if UsingGPS then
                TriggerServerEvent("hp_gps:UnRegisterGPS", true, GetEntityCoords(PlayerPedId()))
            
                PlaySoundFrontend(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 1)
                ESX.ShowNotification("GPS utracony (Dezaktywacja!)")
            
                RemoveBlips()
            end
        end
    end
end)