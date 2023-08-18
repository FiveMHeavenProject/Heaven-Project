-- Variables
local successCallback, failCallback, resultReceived = nil, nil, false

-- Nui Callbacks
RegisterNUICallback('minigameResult', function(data)
    SetNuiFocus(false, false)
    resultReceived = true

    if data.success then
        
        successCallback()
        
    else
        failCallback()
    end
end)

-- Functions
local function StartMinigame(type, display, minigame)
    SendNUIMessage({
        type = type,
        display = display,
        minigame = minigame,
    })
end

exports('startMinigame', function(minigame, success, fail)
    successCallback = success
    failCallback = fail
    local type = 'ui'
    local display = true
    StartMinigame(type, display, minigame)
    SetNuiFocus(true, true)
end)