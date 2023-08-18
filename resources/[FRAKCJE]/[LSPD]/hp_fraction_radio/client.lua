--TODO

ESX = exports["es_extended"]:getSharedObject()
local CurrentFrequency = 0
local RadioDisplayed, onRadio = false, false
local radioProp = 0
local RadioVolume = 50
local PlayerListUiOpen = false
local cd = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
    RegisterRadial()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

CreateThread(function()
    RegisterFractionRadioInRadial()
end)

--FUNCTIONS
RegisterRadial = function()
    lib.registerRadial({
        id = "restrictedradios",
        items = {}
    })
end

local Cooldown = function()
    CreateThread(function()
        cd = true
        Wait(100)
        cd = false
    end)
end

RegisterRestrictedRadiosInRadial = function(JobName)
    local Items = {}
    for i=1, #Config.RestrictedChannels, 1 do
        if Config.RestrictedChannels[i][ESX.PlayerData.job.name] then
            if Config.RestrictedChannels[i].data and Config.RestrictedChannels[i].data.display then
                if Config.RestrictedChannels[i].data.mainjob == JobName then
                    table.insert(Items, {
                        icon = "fas fa-box",
                        label = Config.RestrictedChannels[i].data.label,
                        onSelect = function()
                            ConnectToRadio(i)
                        end
                    })
                end
            end
        end
    end
    lib.registerRadial({
        id = "restrictedradios",
        items = Items
    })
end

RegisterFractionRadioInRadial = function()
    local Items = {}
    for i=1, #Config.RestrictedJobs, 1 do
        table.insert(Items, {
            icon = "fas fa-box",
            label = Config.RestrictedJobs[i].label,
            menu = "restrictedradios",
            onSelect = function(menu, index)
                if Config.RestrictedJobs[i].allowedJobs[ESX.PlayerData.job.name] ~= true then
                    lib.hideRadial()
                    ESX.ShowNotification("Brak Dostepu", "error")
                else
                    RegisterRestrictedRadiosInRadial(Config.RestrictedJobs[i].value)
                end
            end
        })
    end
    lib.registerRadial({
        id = "fractionradio",
        items = Items
    })
end

ConnectToRadio = function(Channel)
    if not cd then
        Cooldown()
        CurrentFrequency = Channel
        if onRadio then
            exports["pma-voice"]:setRadioChannel(0)
        else
            exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
            onRadio = true
        end
        exports["pma-voice"]:setRadioChannel(CurrentFrequency)
        ESX.ShowNotification("Polaczono z czestotliwoscia "..((CurrentFrequency/10)+100).." MHz", "success")

        if Config.RestrictedChannels[Channel] ~= nil then
            local Players = lib.callback.await("hp_fraction_radio:GetPlayersInChannel", false, Channel)

            SendNUIMessage({
                type = "DisplayPlayers",
                value = true,
                channel = Channel,
                players = Players,
                title = (Config.RestrictedChannels[Channel].data and Config.RestrictedChannels[Channel].data.label or "RADIO")
            })
            PlayerListUiOpen = true
        else
            if PlayerListUiOpen then
                SendNUIMessage({
                    type = "DisplayPlayers",
                    value = false,
                }) 
                PlayerListUiOpen = false
            end
        end
    else
        ESX.ShowNotification("Odczekaj chwile")
    end
end

local FrequencyNext = function()
    if CurrentFrequency == 0 then return end
    local TempFreq = CurrentFrequency + 1

    if TempFreq <= Config.MaxFrequency then
        if Config.RestrictedChannels[TempFreq] ~= nil then
            if Config.RestrictedChannels[TempFreq][ESX.PlayerData.job.name] then
                ConnectToRadio(TempFreq)
            else
                ESX.ShowNotification("Brak Dostepu", "error")
            end
        else
            ConnectToRadio(TempFreq)
        end
    else
        ESX.ShowNotification("Bledne radio", "error")
    end
end

local FrequencyPrev = function()
    if CurrentFrequency == 0 then return end
    local TempFreq = CurrentFrequency - 1

    if TempFreq > 0 then
        if Config.RestrictedChannels[TempFreq] ~= nil then
            if Config.RestrictedChannels[TempFreq][ESX.PlayerData.job.name] then
                ConnectToRadio(TempFreq)
            else
                ESX.ShowNotification("Brak Dostepu", "error")
            end
        else
            ConnectToRadio(TempFreq)
        end
    else
        ESX.ShowNotification("Bledne radio", "error")
    end
end

local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(100)
        end
    end
end

local function ToggleRadioAnimation(State)
	LoadAnimDict("cellphone@")
    local PlayerPed = PlayerPedId()
	if State then
		TaskPlayAnim(PlayerPed, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPed, GetPedBoneIndex(PlayerPed, 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPed, "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPed)
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

local UseRadioUI = function(toggle)
    RadioDisplayed = toggle
    SetNuiFocus(RadioDisplayed, RadioDisplayed)
    ToggleRadioAnimation(RadioDisplayed)

    if RadioDisplayed then
        SendNUIMessage({
            type = "open",
            value = CurrentFrequency,
        })
    else
        SendNUIMessage({type = "close"})
    end
end

local LeaveRadio = function()
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    CurrentFrequency = 0
    onRadio = false
    ESX.ShowNotification("Rozlaczono", "info")

    if PlayerListUiOpen then
        SendNUIMessage({
            type = "DisplayPlayers",
            value = false,
        }) 
        PlayerListUiOpen = false
    end
end

--CALLBACKS
RegisterNUICallback('joinRadio', function(data, cb)
    local RadioChannel = tonumber(data.channel)
    if RadioChannel ~= nil then
        if RadioChannel <= Config.MaxFrequency and RadioChannel ~= 0 then
            if RadioChannel ~= CurrentFrequency then
                if Config.RestrictedChannels[RadioChannel] ~= nil then
                    if Config.RestrictedChannels[RadioChannel][ESX.PlayerData.job.name] then
                        ConnectToRadio(RadioChannel)
                    else
                        ESX.ShowNotification("Brak Dostepu", "error")
                    end
                else
                    ConnectToRadio(RadioChannel)
                end
            else
                ESX.ShowNotification("Jestes juz polaczony z tym radiem", "error")
            end
        else
            ESX.ShowNotification("Bledne radio", "error")
        end
    else
        ESX.ShowNotification("Bledne radio", "error")
    end
end)


RegisterNUICallback('leaveRadio', function(data, cb)
    if CurrentFrequency == 0 then
        ESX.ShowNotification("Nie jestes polaczony z zadnym radiem", "error")
    else
        LeaveRadio()
    end
end)

RegisterNUICallback('escape', function(data, cb)
    UseRadioUI(false)
end)

RegisterNUICallback("volumeUp", function()
	if RadioVolume <= 95 then
		RadioVolume = RadioVolume + 5
        ESX.ShowNotification("Zwiekszono glosnosc("..RadioVolume.."%)", "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	end
end)

RegisterNUICallback("volumeDown", function()
	if RadioVolume >= 10 then
		RadioVolume = RadioVolume - 5
        ESX.ShowNotification("Zmniejszono glosnosc ("..RadioVolume.."%)", "success")
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	end
end)

RegisterNUICallback('ChangePowerState', function(data, cb)
    if onRadio then
        LeaveRadio()
    else
        local RadioChannel = tonumber(data.channel)
        if RadioChannel ~= nil then
            if RadioChannel <= Config.MaxFrequency and RadioChannel ~= 0 then
                if RadioChannel ~= CurrentFrequency then
                    if Config.RestrictedChannels[RadioChannel] ~= nil then
                        if Config.RestrictedChannels[RadioChannel][ESX.PlayerData.job.name] then
                            ConnectToRadio(RadioChannel)
                        else
                            ESX.ShowNotification("Brak Dostepu", "error")
                        end
                    else
                        ConnectToRadio(RadioChannel)
                    end
                else
                    ESX.ShowNotification("Jestes juz polaczony z tym radiem", "error")
                end
            else
                ESX.ShowNotification("Bledne radio", "error")
            end
        else
            ESX.ShowNotification("Bledne radio", "error")
        end
    end
end)

RegisterNUICallback("increaseradiochannel", function(data, cb)
    FrequencyNext()
end)

RegisterNUICallback("decreaseradiochannel", function(data, cb)
    FrequencyPrev()
end)

--KEYMAPS
RegisterCommand("FractionRadioUp", function()
    if IsControlPressed(0, 21) then -- SHIFT
        FrequencyNext()
    end
end)

RegisterCommand("FractionRadioDown", function()
    if IsControlPressed(0, 21) then -- SHIFT
        FrequencyPrev()
    end
end)

RegisterKeyMapping('FractionRadioUp', 'Przycisk do szybkiej zmiany czestotliwosci o jeden w gore (Z SHIFTEM)', 'keyboard', 'RIGHT')
RegisterKeyMapping('FractionRadioDown', 'Przycisk do szybkiej zmiany czestotliwosci o jeden w dol (Z SHIFTEM)', 'keyboard', 'LEFT')

--EVENTS
RegisterNetEvent('hp_radio:use', function()
    UseRadioUI(not RadioDisplayed)
end)

--EXPORTY
local function IsRadioOn()
    return onRadio
end
exports("IsRadioOn", IsRadioOn)

local function GetFrequency()
    return CurrentFrequency
end
exports("GetFrequency", GetFrequency)

--TESTOWE
RegisterNetEvent("pma-voice:addPlayerToRadio")
AddEventHandler("pma-voice:addPlayerToRadio", function(source)
    if Config.RestrictedChannels[CurrentFrequency] ~= nil then
        local data = lib.callback.await("hp_fraction_radio:GetPlayerData", false, source)

        SendNUIMessage({
            type = "AddPlayer",
            plyid = source,
            player = data,
        })
    end
end)

RegisterNetEvent("pma-voice:removePlayerFromRadio")
AddEventHandler("pma-voice:removePlayerFromRadio", function(source)
    if Config.RestrictedChannels[CurrentFrequency] ~= nil then
        SendNUIMessage({
            type = "RemovePlayer",
            plyid = source
        })
    end
end)