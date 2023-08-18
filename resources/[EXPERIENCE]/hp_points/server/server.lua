ESX = exports["es_extended"]:getSharedObject()

-- Config
local pointChance = 30
local addJobPoint = math.random(3, 5)

local legalCheck = {100, 300, 500}
local legalExtraMoney = {20, 30, 40}
local crimeExtraMoney = {20, 30, 40}

ESX.RegisterServerCallback('hp-points:matchPoints', function(playerId, cb, isLegal, checkCheater)
    if not checkCheater then 
        exports.hp_logs:cheatAlert(source, 'Sprawdzanie puntków bez checka w funkcji')
        return 
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local hp_points = xPlayer.getMeta('hp_points') or 0
    local retval = 0

    if not isLegal then
        if hp_points >= crimePoints[1] and hp_points < crimePoints[2] then
            retval = crimeExtraMoney[1]
        elseif hp_points >= crimePoints[2] and hp_points < crimePoints[3] then
            retval = crimeExtraMoney[2]
        elseif hp_points >= crimePoints[3] then
            retval = crimeExtraMoney[3]
        end
    elseif isLegal then
        if hp_points >= legalCheck[1] and hp_points < legalCheck[2] then
            retval = legalExtraMoney[1]
        elseif hp_points >= legalCheck[2] and hp_points < legalCheck[3] then
            retval = legalExtraMoney[2]
        elseif hp_points >= legalCheck[3] then
            retval = legalExtraMoney[3]
        end
    end

    cb(retval)
end)


RegisterNetEvent('hp-points:addPoint', function(action)
    math.randomseed(os.time())

    if not action then 
        exports.hp_logs:cheatAlert(source, 'Cheater', 'Striggerowano dodawanie punktów bez podania powodu!') 
        return 
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local hp_points = xPlayer.getMeta('hp_points') or 0
    local hp_points_log = xPlayer.getMeta('hp_points') or 0
    local random = math.random(1, 100)

    if random >= pointChance then
        hp_points = hp_points + addJobPoint
        xPlayer.setMeta('hp_points', hp_points)
        xPlayer.triggerEvent('esx:showNotification', 'Udało Ci się zdobyć: ~g~'..addJobPoint..' HP Points!')
        TriggerEvent('hp-logs:sendLog', source, '[ZDOBYŁ HP POINTS]', '\n\n**Gracz: **'..GetPlayerName(xPlayer.source)..'\n**Zdobył: **'..addJobPoint..' punktów\n**Stan punktów przed dodaniem: **'..hp_points_log..'\n\n**Gdzie zdobył punkty: **'..tostring(action), 'hp_points_dodal_skrypt')
    end
end)

