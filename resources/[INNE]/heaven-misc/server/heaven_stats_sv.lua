local PlayersInSession, sortedPlayers = {}, {}
local debugMode = true

RegisterNetEvent('heaven_misc:setMeta', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setMeta('gym_stamina', {points=1})
    xPlayer.setMeta('gym_strength', {points=1})
    xPlayer.setMeta('gym_karnet', {hasCarnet=false, time = nil})
    xPlayer.setMeta('hp_points',{points=1})
    xPlayer.setMeta('gym_dexterity', {points=1})
end)




ESX.RegisterServerCallback('heaven_stats:getTopWorkers', function(source, cb, pJob)
    local xPlayer = ESX.GetPlayerFromId(source)
    local response = MySQL.query.await("SELECT identifier, JSON_EXTRACT(`job`,?) AS points FROM `users_job_progress` ",
        { '$.' .. pJob })
    local top10 = {}
    if response then
        for i = 1, #response do
            sortedPlayers[#sortedPlayers + 1] = {
                identifier = response[i].identifier, points = response[i].points
            }
        end
        table.sort(sortedPlayers, (function(a, b)
            return tonumber(a.points) > tonumber(b.points)
        end))
        Wait(10)
        for k, v in pairs(sortedPlayers) do
            if v.identifier == xPlayer.identifier then
                top10.ranking = k
                break
            end
        end
        top10.list = {}
        if #sortedPlayers == 10 then
            for i = 1, 10 do
                local charInfo = MySQL.query.await('SELECT `lastname`,`firstname` FROM `users` WHERE `identifier` = ?',
                    { sortedPlayers[i].identifier })

                
                if charInfo then
                    top10.jobName = pJob
                    top10.list[i] = {
                        charname = charInfo[1].firstname .. ' ' .. charInfo[1].lastname,
                        points = sortedPlayers[i].points,
                    }
                end
            end
        end
        cb(top10)
    else
        cb(top10)
    end 
end)

RegisterNetEvent('heaven_stats:addPointForRanking', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local result = MySQL.query.await('SELECT `job` FROM `users_job_progress` WHERE identifier = ?', { identifier })

    if next(result) then
        local data = json.decode(result[1].job)
        if data[xPlayer.job.name] then
            data[xPlayer.job.name] = data[xPlayer.job.name] + 1
        end
        local update = MySQL.update.await('UPDATE `users_job_progress` SET job = ? WHERE identifier = ?', {
            json.encode(data), identifier
        })
    else
        local points = {
            [xPlayer.job.name] = 1
        }
        local insert = MySQL.insert.await('INSERT INTO `users_job_progress` (identifier, job) VALUES(?,?)', {
            identifier, json.encode(points)
        })
    end
end)


ESX.RegisterServerCallback('heaven_stats:getPlayerCardInfo', function(playerId, cb)
    local data = {}
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local result = MySQL.query.await(
        'SELECT `totalPlayTime`, `created_at`, `firstname`, `lastname`, `id` FROM `users` WHERE identifier = ?',
        { xPlayer.identifier })
    if result then
        local dutyTimes          = tonumber(os.time() - PlayersInSession[playerId]["dutyStart"])
        local sessionTime        = GetSessionTime(playerId)
        local pData              = result[1]
        data.totalPlayTime       = {
            label = "Czas na serwerze",
            value = SecondsToClock(pData.totalPlayTime) or "1"
        }
        data.created_at          = {
            label = "Data utworzenia postaci",
            value = pData.created_at or "BŁĄD"
        }
        data.hp_points           = {
            label = "Punkty HP",
            value = xPlayer.getMeta('hp_points', 'points') or "BŁĄD"
        }
        data.stamina             = {
            label = "Punkty wytrzymałości",
            value = xPlayer.getMeta('gym_stamina', 'points') or "BŁĄD"
        }
        data.strength            = {
            label = "Punkty siły",
            value = xPlayer.getMeta('gym_strength', 'points') or "BŁĄD"
        }
        data.dexterity           = {
            label = "Punkty zręczności",
            value = xPlayer.getMeta('gym_dexterity', 'points') or "BŁĄD"
        }
        data.name                = {
            label = "Imię i nazwisko",
            value = pData.firstname .. ' ' .. pData.lastname
        }
        data.jobName             = {
            label = "Aktualna praca",
            value = xPlayer.job.label
        }
        data.jobPosition         = {
            label = "Stanowisko",
            value = xPlayer.job.grade_label
        }
        data.currentSessionTime  = {
            label = "Czas sesji",
            value = sessionTime ~= 'Błąd' and sessionTime or "BŁĄD ZLICZANIA CZASU. ZGŁOŚ TO NA BŁĘDY NA DISCORDZIE"
        }
        data.onDuty              = {
            label = "Na służbie",
            value = PlayersInSession[playerId]["onDuty"] and PlayersInSession[playerId]["dutyStart"] and
                "Na służbie od: " .. SecondsToClock(dutyTimes) or
                PlayersInSession[playerId]["onDuty"] and PlayersInSession[playerId]["dutyStart"] == 1 and
                "Odbij się by liczyć czas na służbie!" or not PlayersInSession[playerId]["onDuty"] and false
        }
        data.ssn                 = {
            label = "SSN",
            value = tonumber(pData.id)
        }
        cb(data)
    else
        cb(data)
    end
end)

AddEventHandler("esx:playerDropped", function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    offlineSave(xPlayer.source)
    stopPoliceDutySession(xPlayer.source, true)
    RemovePlayerFromTable(playerId)
end)

function RemovePlayerFromTable(source)
    CreateThread(function()
        Wait(4500)
        PlayersInSession[source] = {}
    end)
end

RegisterNetEvent('hp_stats:startDuty', function(status)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer.job.name == 'mechanic' or not xPlayer.job.name == 'police' or not xPlayer.job.name == 'ambulance' or not xPlayer.job.name == 'offmechanic' or not xPlayer.job.name == 'offpolice' or not xPlayer.job.name == 'offambulance' then return end
    if status then
        if PlayersInSession[source] then
            PlayersInSession[source]["dutyStart"] = os.time()
        end
        if PlayersInSession[source] then
            PlayersInSession[source]["onDuty"] = true
        end
        xPlayer.triggerEvent('okokNotify:Alert', 'DUTY', 'Odbiłeś się do pracy', 5000, 'info')
    elseif not status then
        if PlayersInSession[source] then
            PlayersInSession[source]["dutyStart"] = 1
        end
        if PlayersInSession[source] then
            PlayersInSession[source]["onDuty"] = false
        end
        xPlayer.triggerEvent('okokNotify:Alert', 'DUTY', 'Odbiłeś się z pracy', 5000, 'info')
    end
end)

ESX.RegisterServerCallback('hp_stats:returnMetadataDuty', function(src, cb)
    if not PlayersInSession[src] then
        cb(false)
    elseif not PlayersInSession[src]["onDuty"] then
        cb(false)
    elseif PlayersInSession[src]["onDuty"] then
        cb(true)
    end
end)

RegisterNetEvent('hp_stats:stopPoliceDutySession', function(status)
    stopPoliceDutySession(source, status)
end)

RegisterNetEvent('hp_stats:startSessionTime', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    PlayersInSession[source] = {
        isActive = true,
        sessionStart = os.time(),
        identifier = xPlayer.identifier,
        onDuty = false,
        job = xPlayer.job.name,
        dutyStart = 1,
    }
end)


RegisterNetEvent('heaven-misc:makeScreenshotData', function()
    print("["..GetCurrentResourceName()..'] - Pomyślnie wykonano screenshota graczowi od ID: '..source ..' | '..GetPlayerName(source))
end)

function GetSessionTime(source, check)
    local osTime = os.time()
    if PlayersInSession[source]["isActive"] then
        if not check then
            local actualTime = tonumber(osTime - PlayersInSession[source]["sessionStart"])
            local timeFormatted = SecondsToClock(actualTime, true)
            return timeFormatted
        else
            local actualTime = tonumber(osTime - PlayersInSession[source]["sessionStart"])
            return actualTime
        end
    else
        return "Błąd"
    end
end

function stopPoliceDutySession(xSrc, playerDropped)
    if PlayersInSession[xSrc]["dutyStart"] and PlayersInSession[xSrc]["onDuty"] then
        local osTime = os.time()
        local dutyTimes = tonumber(osTime - PlayersInSession[xSrc]["dutyStart"])
        local result = MySQL.query.await('SELECT `dutyTime` FROM `users_duty` WHERE `identifier` = ? AND `job` = ?',
            { PlayersInSession[xSrc]['identifier'], PlayersInSession[xSrc]['job'] })
        if result and result[1] then
            local totalTime = result[1].dutyTime + dutyTimes
            MySQL.update('UPDATE `users_duty` SET dutyTime = ? WHERE identifier = ?',
                { totalTime, PlayersInSession[xSrc]['identifier'] })
        else
            local insert = MySQL.insert.await('INSERT INTO `users_duty` (identifier, dutyTime, job) VALUES(?,?,?)', {
                PlayersInSession[xSrc]['identifier'], dutyTimes, PlayersInSession[xSrc]['job']
            })
        end
        if not playerDropped then
            local xPlayer = ESX.GetPlayerFromId(source)
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, '[CZAS NA SŁUŻBIE]',
                'Przepracowałeś: ' .. SecondsToClock(dutyTimes) .. ' minut na służbie!', 6000, 'info')
        end
    end
end

function offlineSave(xSrc)
    local totalTime
    if PlayersInSession[xSrc] then
        local sessionStart = PlayersInSession[xSrc]["sessionStart"]
        local identifier = PlayersInSession[xSrc]["identifier"]
        local isActive = PlayersInSession[xSrc]["isActive"]
        if isActive then
            local actualTime = tonumber(os.time() - sessionStart)
            local result = MySQL.query.await('SELECT `totalPlayTime` FROM users WHERE `identifier` = ?', { identifier })
            if result then
                totalTime = result[1].totalPlayTime + actualTime
            else
                totalTime = actualTime + 1
            end
            MySQL.update('UPDATE `users` SET `totalPlayTime` = ? WHERE `identifier` = ?', { totalTime, identifier })
        end
    end
end

function SecondsToClock(seconds, check)
    if seconds ~= nil then
        local seconds = tonumber(seconds)

        if seconds <= 0 then
            if not check then
                return "Dni: 0 - 00:00:00";
            else
                return "00:00:00";
            end
        elseif not check then
            days = string.format("%01.f", math.floor(seconds / 86400));
            return days .. " dni"
        elseif check then
            hours = string.format("%02.f", math.floor(seconds / 3600));
            mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
            secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
            return 'Czas: ' .. hours .. ":" .. mins .. ":" .. secs
        end
    end
end


if debugMode then
    ESX.RegisterCommand('hp_start_session', 'admin', function(xPlayer, args, showError)
        TriggerEvent('hp_stats:startSessionTime', xPlayer.source)
        xPlayer.triggerEvent('okokNotify:Alert', 'INFO', 'Sukces, rozpoczynam liczenie', 5000, 'success')
    end, false)
end

--exporty

function getDutyTime(source) 
    if type(source) == 'number' then
        print(source)
        local allDutyTime = MySQL.query.await('SELECT `dutyTime` FROM `users_duty` WHERE `identifier` = ?',{PlayersInSession[source]['identifier']})
        if PlayersInSession[source]["dutyStart"] and PlayersInSession[source]["onDuty"] then
            if next(allDutyTime) then
                local actualDutyTime = PlayersInSession[source]["dutyStart"]
                return SecondsToClock(actualDutyTime + allDutyTime[1].dutyTime, true)
            else
                local actualDutyTime = PlayersInSession[source]["dutyStart"]
                return SecondsToClock(actualDutyTime,true)
            end
        elseif allDutyTime then
            return SecondsToClock(allDutyTime[1].dutyTime, true)
        else
            return "00:00:00";
        end
    end
    if type(source) == 'string' then
        print('identifier')
        local allDutyTime = MySQL.query.await('SELECT `dutyTime` FROM `users_duty` WHERE `identifier` = ?',{tostring(source)})
        if next(allDutyTime) then
            print(ESX.DumpTable(allDutyTime))
            return SecondsToClock(allDutyTime[1].dutyTime, true)
        else
            return "00:00:00";
        end 
    end
end

