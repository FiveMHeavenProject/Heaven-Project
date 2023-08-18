ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("hp_badges:AddUserBadge", function(id, data)
    local xPlayer = ESX.GetPlayerFromId(id)
    xPlayer.showNotification("Otrzymałeś odznake!")

    if data.default then
        xPlayer.set('badge', data.number)
    end

    TriggerClientEvent("hp_badges:AddBadge", id, data)
end)

RegisterNetEvent("hp_badges:RemoveUserBadge", function(identifier, badgeid)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    
    if xPlayer then
        xPlayer.triggerEvent("hp_badges:RemoveBadge", badgeid)
    else
        local badges = json.decode(MySQL.scalar.await('SELECT badges FROM `users` WHERE identifier = ?', {identifier}))
        table.remove(badges, badgeid)
        MySQL.update.await('UPDATE users SET badges = ? WHERE identifier = ?', {badges, identifier})
    end
    
end)

RegisterNetEvent("hp_badges:EditUserBadge", function(identifier, badgeid, data)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    
    if xPlayer then
        xPlayer.triggerEvent("hp_badges:EditBadge", badgeid, data)
    else
        local badges = json.decode(MySQL.scalar.await('SELECT badges FROM `users` WHERE identifier = ?', {identifier}))
        badges[badgeid] = data
        MySQL.update.await('UPDATE users SET badges = ? WHERE identifier = ?', {badges, identifier})
    end
    
end)

RegisterNetEvent("hp_badges:UpdateUserBadges", function(data, default)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.update.await('UPDATE users SET badges = ? WHERE identifier = ?', {data, xPlayer.identifier})

    if default then
        xPlayer.set('badge', nil)
    end
end)

lib.callback.register("hp_badges:recieveBadges", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local badges = MySQL.scalar.await('SELECT badges FROM `users` WHERE identifier = ?', {xPlayer.identifier})

    return badges
end)

RegisterNetEvent("hp_badges:setDefaultBadge", function(badge)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.set('badge', badge)
end)

RegisterNetEvent("hp_badges:unDefaultBadge", function(badge)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.set('badge', badge)
end)

RegisterNetEvent("hp_badges:DisplayBadgeInChat", function(badge)
    local xPlayer = ESX.GetPlayerFromId(source)
    local display = ''
    if badge.anon == true then
        if Config.DisplayNames[badge.type] then
            display = 'Pokazuje '..Config.DisplayNames[badge.type]..' '..badge.name..' ['..badge.number..']';
        end
    else
        if Config.DisplayNames[badge.type] then
            display = 'Pokazuje '..Config.DisplayNames[badge.type]..' '..badge.name..' ['..badge.number..'] - '..xPlayer.getName()..' '..badge.grade
        end
    end

    if Config.TypeNames[badge.type] then
        TriggerClientEvent("cc-rpchat:addProximityMessage", -1, '#40f7f481', 'fa-solid fa-comment', Config.TypeNames[badge.type]..' l '..source, display, source, GetEntityCoords(GetPlayerPed(source)), false, false)
        TriggerClientEvent("cc-rpchat:addProximityMessage", -1, '#40f7f481', 'fa-solid fa-comment', Config.TypeNames[badge.type]..' l '..source, "Pokazuje "..Config.DisplayNames[badge.type], source, GetEntityCoords(GetPlayerPed(source)), true, true)
    end
end)

ESX.RegisterServerCallback("hp_badges:isAdmin", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    
    if group == "admin" then
        cb(true)
    else
        cb(false)
    end
end)
  