ESX = exports['es_extended']:getSharedObject()

local svData = {

    Peds = {
        karnet = {
            coords = vector3(-1203.29, -1571.90, 3.59),
            label = "Kup karnet",
            event = "buyPass",
            model = "a_m_y_salton_01",
            heading = 62.36,
            icon = 'fa-solid fa-star'
        }
    },
    boxZones = {
        sztanga = {
            {
                coords = vector3(-1210.5, -1561.39, 4.61),
                label = "Zacznij ćwiczenie",
                length = 2.0,
                width = 2.0,
                name = 'zone1',
                heading = 71.81,
                propRange = 1.5,
                debug = false,
                skill = 'strength',
                minZ = 3.61,
                maxZ = 5.61,
                
            },
            {
                coords = vector3(-1202.98, -1565.23, 4.61),
                label = "Zacznij ćwiczenie",
                length = 2.0,
                width = 2.0,
                name = 'zone2',
                heading = 36.44,
                propRange = 2.5,
                debug = false,
                skill = 'strength',
                minZ = 3.61,
                maxZ = 5.61,
            },
            {
                coords = vector3(-1198.93, -1574.55, 4.61),
                label = "Zacznij ćwiczenie",
                length = 2.0,
                width = 2.0,
                name = 'zone3',
                heading = 212.84,
                propRange = 2.5,
                debug = false,
                skill = 'strength',
                minZ = 3.61,
                maxZ = 5.61,
            },
            {
                coords = vector3(-1196.85, -1573.23, 4.61),
                label = "Zacznij ćwiczenie",
                length = 2.0,
                width = 2.0,
                name = 'zone4',
                heading = 218.84,
                propRange = 2.5,
                debug = false,
                skill = 'strength',
                minZ = 3.61,
                maxZ = 5.61,
            }
        }
    }
}


ESX.RegisterServerCallback('hp_gym:sendData', function(src, cb)
    cb(svData)
end)

ESX.RegisterServerCallback('hp_gym:checkLockPickPoints', function()
    local xPlayer = ESX.GetPlayerFromId(playerId)
    cb(xPlayer.getMeta('hp_lockpick'))
end)

ESX.RegisterServerCallback('hp_gym:updateStats', function(playerId, cb)
    local data = {}
    local xPlayer = ESX.GetPlayerFromId(playerId)
    data.stamina = xPlayer.getMeta('gym_stamina', 'points')
    data.strength = xPlayer.getMeta('gym_strength', 'points')

    cb(data)
end)

RegisterNetEvent('hp_gym:addPoint', function(data)
    math.randomseed(os.time())
    local xPlayer = ESX.GetPlayerFromId(source)
    local addPoints = math.random(0.3, 0.4)
    if data == 'strength' then
        local strength = xPlayer.getMeta('gym_strength', 'points')
        strength = strength + math.floor(addPoints)
        xPlayer.setMeta('gym_strength', {points=strength})
        TriggerClientEvent('hp_gym:refreshSkill', source)
        TriggerEvent('hp-logs:sendLog', source, '[ZDOBYŁ PUNKT]',"\n**Gracz: **"..GetPlayerName(source)..'\n**Zdobył punkt na siłowni. Ćwicznenie: strength**'..'\n**Ilość zdobytych punktów: **'..addPoints, 'hp_gym_zdobyl')
    end
    TriggerClientEvent('hp_gym:refreshSkill', source)
end)

ESX.RegisterServerCallback('hp_gym:checkMoneyBalance', function(source, cb, howLong)
    local xPlayer = ESX.GetPlayerFromId(source)
    local account = xPlayer.getAccount('money').money
    local payment = math.floor(howLong * 200)
    if account >= payment then 
        xPlayer.removeAccountMoney('money', payment)
        xPlayer.setMeta('gym_karnet', {hasCarnet = true, time = addCarnet(howLong)})
        xPlayer.triggerEvent('okokNotify:Alert',source,"SIŁOWNIA", 'Kupiłeś karnet za: '..payment..' na '..howLong..' dni!', 5000, 'success')
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('hp_gym:checkCarnet', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local now = getNow(os.time())
    local karnetData = xPlayer.getMeta('gym_karnet')
    if not karnetData.hasCarnet then
        cb({status = false})
    elseif karnetData.hasCarnet and not karnetData.time then
        xPlayer.setMeta('gym_karnet', {hasCarnet=false, time = nil})
        cb({status = false})
    elseif karnetData.hasCarnet and karnetData.time > now then
        cb({status = true, time = os.date('%Y-%m-%d %H:%M:%S', karnetData.time)})
    else
        cb({status = false})
    end
end)

RegisterNetEvent('hp_gym:disarmPed', function(data)
    if not data then return end
    if not data.skill then return end
    local ped = GetPlayerPed(source)
    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
end)



function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
        local mult = 10^numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function addCarnet(hlong)
    local year1 = round(os.date('%Y'),0)
	local month1 = round(os.date('%m'),0)
	local day1 = round(os.date('%d')+hlong,0)
	local hour1 = round(os.date('%H'),0)
	local minutes1 = round(os.date('%M'),0)
	local seconds1 = round(os.date('%S'),0)
	local mTime = {year = year1, month = month1, day = day1, hour = hour1, min = minutes1, sec = seconds1}
	local dt = os.time(mTime)
	return dt
end

function getNow(when)
    local kiedy = os.date('%Y-%m-%d %H:%M:%S', when)				
    local year1 = round(os.date('%Y'),0)
    local month1 = round(os.date('%m'),0)
    local day1 = round(os.date('%d'),0)
    local hour1 = round(os.date('%H'),0)
    local minutes1 = round(os.date('%M'),0)
    local seconds1 = round(os.date('%S'),0)
    local mTime = {year = year1, month = month1, day = day1, hour = hour1, min = minutes1, sec = seconds1}
    local dt = tonumber(os.time(mTime))
    return dt
end

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
      local mult = 10^numDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end



