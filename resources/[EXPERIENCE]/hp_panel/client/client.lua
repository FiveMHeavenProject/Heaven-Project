local onCooldown = false

RegisterNetEvent('hp_panel:openPanel', function()
    if onCooldown then
        exports.okokNotify:Alert("HEAVEN", 'POCZEKAJ CHWILĘ PRZED NASTĘPNYM UŻYCIEM!', 5000, 'error')
        return
    end
    onCooldown = true
    ESX.TriggerServerCallback('heaven_stats:getPlayerCardInfo', function(data)
        SendNUIMessage({
            type = 'open-char-panel',
            pInfo = data,
        })
        SetNuiFocus(true, true)
    end)
    TriggerScreenblurFadeIn(1)
end)


RegisterNetEvent('hp_panel:openJobPanel', function(job)
    if onCooldown then
        exports.okokNotify:Alert("HEAVEN", 'POCZEKAJ CHWILĘ PRZED NASTĘPNYM UŻYCIEM!', 5000, 'error')
        return
    end
    onCooldown = true

    ESX.TriggerServerCallback('heaven_stats:getTopWorkers', function(data)
       -- if not data then return exports.okokNotify:Alert("TOPKA", "Wystąpił błąd podczas ładowania karty! Zgloś w tickecie na discord!", 8000, 'error') return end
        SendNUIMessage({
            type = 'open-job-panel',
            leaderboard = data,
        })
        SetNuiFocus(true, true)
    end, job)

    TriggerScreenblurFadeIn(1)

end)

RegisterNUICallback('close', function(data)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(1)
end)


CreateThread(function()
    while true do
        Wait(0)
        if onCooldown then
            Wait(10000)
            onCooldown = false
        else
            Wait(3000)
        end
    end
end)
