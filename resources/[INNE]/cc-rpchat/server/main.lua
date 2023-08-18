ESX = nil
QBCore = nil
local MaxLength = 250
local erorrmsg = "Wpisałes zbyt dużą ilość znaków"

Citizen.CreateThread(function()
    SetConvar('chat_showJoins', '0')
    SetConvar('chat_showQuits', '0')
    if config.esx then
        ESX = exports["es_extended"]:getSharedObject()
        StopResource('esx_rpchat')
    elseif config.qbcore then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)


-- OOC
RegisterCommand('ooc', function(source, args, rawCommand)
    local playerName
    local msg = rawCommand:sub(5)
    if config.esx then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerName = GetPlayerName(source) .. " l " .. source
        if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    elseif config.qbcore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        playerName = xPlayer.PlayerData.charinfo.firstname .. "," .. xPlayer.PlayerData.charinfo.lastname
    else
        playerName = GetPlayerName(source)
    end
    if config.DiscordWebhook then
    end
    TriggerClientEvent('cc-rpchat:addProximityMessage', -1, '#ffffff88', 'fa-solid fa-earth-americas',
        'OOC l ' .. playerName, msg,
        source, GetEntityCoords(GetPlayerPed(source)))
end, false)

AddEventHandler('chatMessage', function(source, name, message)
    CancelEvent()
    if message:sub(1, 1) == '/' then
        return
    end
end)

-- Me
RegisterCommand('me', function(source, args, rawCommand)
    local playerName
    local msg = rawCommand:sub(4)
    if config.esx then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerName = source
        if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    elseif config.qbcore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        playerName = xPlayer.PlayerData.charinfo.firstname .. "," .. xPlayer.PlayerData.charinfo.lastname
    else
        playerName = GetPlayerName(source)
    end
    if config.DiscordWebhook then
       
    end
    TriggerClientEvent('cc-rpchat:addProximityMessage', -1, '#40f7f481', 'fa-solid fa-user', 'ME l ' .. playerName, msg,
        source, GetEntityCoords(GetPlayerPed(source)), true)
    --TriggerClientEvent('cc-rpchat:addMessage', -1, '#f39c12', 'fa-solid fa-person', 'Me | '..playerName, msg)
end, false)

-- Do
RegisterCommand('do', function(source, args, rawCommand)
    local playerName
    local msg = table.concat(args, ' ')
    local xPlayer = ESX.GetPlayerFromId(source)
    playerName = source
    if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    if config.DiscordWebhook then
        
    end

    TriggerClientEvent('cc-rpchat:addProximityMessage', -1, '#fc97b77e', 'fa-solid fa-comment', 'DO l ' ..playerName, msg, source, GetEntityCoords(GetPlayerPed(source)), true)
end, false)



-- News
RegisterCommand('news', function(source, args, rawCommand)
    local playerName
    local msg = rawCommand:sub(5)
    if config.esx then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerName = xPlayer.name
        if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    elseif config.qbcore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        playerName = xPlayer.PlayerData.charinfo.firstname .. "," .. xPlayer.PlayerData.charinfo.lastname
    else
        playerName = GetPlayerName(source)
    end
    if config.DiscordWebhook then
       
    end
    TriggerClientEvent('cc-rpchat:addMessage', -1, '#c02b1b85', 'fa-solid fa-newspaper', 'NEWS l ' .. playerName, msg)
end, false)

-- Ad
RegisterCommand('ad', function(source, args, rawCommand)
    local playerName
    local msg = rawCommand:sub(4)
    if config.esx then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerName = xPlayer.name
        if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    elseif config.qbcore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        playerName = xPlayer.PlayerData.charinfo.firstname .. "," .. xPlayer.PlayerData.charinfo.lastname
    else
        playerName = GetPlayerName(source)
    end
    if config.DiscordWebhook then
        
    end
    TriggerClientEvent('cc-rpchat:addMessage', -1, '#faca0b83', 'fa-solid fa-newspaper', 'AD l ' .. playerName, msg)
end, false)

-- Tweet
RegisterCommand('twt', function(source, args, rawCommand)
    local playerName
    local msg = rawCommand:sub(5)
    if config.esx then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerName = xPlayer.name
        if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    elseif config.qbcore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        playerName = xPlayer.PlayerData.charinfo.firstname .. "," .. xPlayer.PlayerData.charinfo.lastname
    else
        playerName = GetPlayerName(source)
    end
    if config.DiscordWebhook then
        
    end
end, false)

-- Anon
RegisterCommand('dw', function(source, args, rawCommand)
    local playerName
    local msg = rawCommand:sub(5)
    local xPlayer = ESX.GetPlayerFromId(source)
    playerName = xPlayer.getName()
    if string.len(msg) >= MaxLength then return xPlayer.showNotification(erorrmsg) end
    randomnumber = random(100000, 999999)
    TriggerClientEvent('cc-rpchat:addMessage', -1, '#223d5871', 'fa-solid fa-mask',
                'DARKWEB l ' .. randomnumber,
                msg)
end, false)
