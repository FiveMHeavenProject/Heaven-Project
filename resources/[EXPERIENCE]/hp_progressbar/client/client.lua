ESX = exports['es_extended']:getSharedObject()

local options = nil
local default = {
    text = "Trwa wykonywanie czynności",
    length = 5000,   
}

RegisterNUICallback('close', function(data)
    if not options then return end
    if not options.onCancel then return end
    ClearPedTasks(PlayerPedId())
    if options.Freeze then FreezeEntityPosition(PlayerPedId(), false) end
    options.canceled = true
    options.time = 0
    SetNuiFocus(false, false)
    options.onCancel()
    options = nil

end)


RegisterNetEvent('hp_progressbar:startProgressbar', function(time,text,pOptions)
    startProgressbar(time,text,pOptions)
end)

function startProgressbar(time,text,pOptions)
    if options then
        return false
    end
    
    options = pOptions or {}
    if options.animation then
        if options.animation.type == "scenario" then
            TaskStartScenarioInPlace(ESX.PlayerData.ped, options.animation.Scenario, 0, true)
        end
    end
    if options.Freeze then FreezeEntityPosition(PlayerPedId(), options.Freeze) end
    
    SendNUIMessage({
        type = 'startProgress',
        length = time or default.length,
        message = text or default.text,
        textcolor = false,
        bgcolor = false,
    })
    SetNuiFocus(true, false)
    options.time = time or default.length
    while options ~= nil do
        if options.time > 0 then 
            options.time = options.time - 1000
        else
            ClearPedTasks(ESX.PlayerData.ped)
            if options.Freeze then FreezeEntityPosition(PlayerPedId(), false) end
            if options.onFinish then options.onFinish() SetNuiFocus(false, false)
            end
            options = nil
        end
        Wait(1000)
    end
end

exports('startProgressbar', startProgressbar)
