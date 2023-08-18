ESX = exports['es_extended']:getSharedObject()

local goldPrice = 50
local ironPrice = 30

local pedData= {
    [1] = {
        model = 's_m_m_dockwork_01',
        coords = vector3(-595.22, 2089.39, 130.46),
        heading = 25.35,
        icon = 'fa-solid fa-oil-well',
        label = "Rozpocznij pracę",
        event = 'startworking',
        prompt = "1 # Szyb kopalniany",
        sprite = 472,
        blipColour = 28,
    },
    [2] = {
        model = 'g_m_m_armlieut_01',
        coords = vector3(1699.92, 3866.67, 33.95),
        heading = 310.59,
        icon = 'fa-solid fa-coins',
        label = "Uszlachetnij kamienie",
        event = 'extractStones',
        prompt = "2 # Uszlachetnianie kamieni",
        sprite = 472,
        blipColour = 28,
    },
    [3] = {
        model = 's_m_m_ammucountry',
        coords = vector3(1714.3, -1492.94, 113.0),
        heading = 79.16,
        icon = 'fa-solid fa-cookie',
        label = "Sprzedaj złoto",
        event = 'sellGold',
        typ = 'miner_gold',
        price = goldPrice,
        prompt = "3 # Sprzedaj złoto",
        sprite = 472,
        blipColour = 28,
    },
    [4] = {
        model = 's_m_m_ammucountry',
        coords = vector3(-1640.85, -1069.42, 12.15),
        heading = 229.94,
        icon = 'fa-solid fa-spoon',
        label = "Sprzedaj żelazo",
        event = 'sellGold',
        typ = 'miner_iron',
        price = ironPrice,
        prompt = "4 # Sprzedaj żelazo",
        sprite = 472,
        blipColour = 28,
    }
}
local crystalData = {
    [1] = {model = 'emerald', coords = vector3(-590.86, 2063.16, 130.20), chance = 60,crystalType = 'miner_gold'},
    [2] = {model = 'emerald', coords = vector3(-582.8, 2041.07, 128.30), chance = 55,crystalType = 'miner_gold'},
    [3] = {model = 'emerald', coords = vector3(-575.94, 2026.75, 127.30), chance = 60,crystalType = 'miner_iron'},
    [4] = {model = 'emerald', coords = vector3(-547.79, 1992.79, 126.20), chance = 40,crystalType = 'miner_iron'},
    [5] = {model = 'emerald', coords = vector3(-485.79, 1984.41, 123.40), chance = 55,crystalType = 'miner_gold'},
    [6] = {model = 'emerald', coords = vector3(-448.01, 2014.05, 122.70), chance = 50,crystalType = 'miner_gold'},
    [7] = {model = 'emerald', coords = vector3(-422.93, 2064.37, 120.80), chance = 45,crystalType = 'miner_iron'},
    [8] = {model = 'emerald', coords = vector3(-470.34, 2084.56, 120.50), chance = 40,crystalType = 'miner_gold'},
    [9] = {model = 'emerald', coords = vector3(-534.24, 1933.51, 124.25), chance = 50,crystalType = 'miner_iron'},
    [10] = {model = 'emerald', coords = vector3(-565.05, 1885.17, 123.40), chance = 50,crystalType = 'miner_gold'},
    [11] = {model = 'emerald', coords = vector3(-589.38, 2068.48, 131.80), chance = 60,crystalType = 'miner_gold'},
    [12] = {model = 'emerald', coords = vector3(-578.19, 2033.86, 129.20), chance = 30, crystalType = 'miner_iron'},
    [13] = {model = 'emerald', coords = vector3(-542.13, 1982.04, 128.29), chance = 40, crystalType = 'miner_iron'},
    [14] = {model = 'emerald', coords = vector3(-515.4, 1980.21, 127.0), chance = 50, crystalType = 'miner_iron'},
    [15] = {model = 'emerald', coords = vector3(-455.74, 2041.88, 122.79), chance = 60, crystalType = 'miner_iron'},
    [16] = {model = 'emerald', coords = vector3(-459.99, 2055.31, 122.13), chance = 5, crystalType = 'miner_diamond'}
}

ESX.RegisterServerCallback('hp_mining:getPedData', function(_, cb)
    cb(pedData)
end)
ESX.RegisterServerCallback('hp_mining:getGamesCoords', function(src, cb)
   cb(crystalData)
end)
ESX.RegisterServerCallback('hp_mining:extractStones', function(playerId, cb, item)
    local kamienSlot = exports.ox_inventory:GetSlotIdWithItem(playerId, item)
    local kamienie = exports.ox_inventory:GetSlot(playerId, kamienSlot)
    if kamienie then
        if kamienie.count >= 1 then
            cb({
                true,
                kamienie.count,
                kamienie.label
                
            })
        else
            cb({
                false,
            })
        end
    else
        cb({
            false,
        })
    end
end)

RegisterNetEvent('hp_mining:sellGold', function(status, count,item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = ironPrice * count
    if not xPlayer.job.name == 'miner' then exports.hp_logs:cheatAlert(source, 'Próba sprzedaży surowców bez joba górnika') return end 
    if not status then exports.hp_logs:cheatAlert(source, 'Próba sprzedaży bez itemów') return end 
    local kamienSlot = exports.ox_inventory:GetSlotIdWithItem(source, item)
    local kamienie = exports.ox_inventory:GetSlot(source, kamienSlot)
    if item == 'miner_gold' then reward = goldPrice * count end

    if not kamienie then exports.hp_logs:cheatAlert(source, 'Próba oszukania przy sprzedaży. Brak itemu przy porównaniu przed otwarciem dialogu') return end 
    if not kamienie.count == count then exports.hp_logs:cheatAlert(source, 'Próba oszukania przy sprzedaży. Nierówna wartość porównania przed otwarciem dialogu') return end 

    xPlayer.removeInventoryItem(item, count)
    xPlayer.addAccountMoney('bank',reward)
    xPlayer.triggerEvent('okokNotify:Alert', 'GÓRNIK', 'Otrzymałeś przelew w wysokości: '..reward..'$ za sprzedaż zasobów.', 5000, 'info')
    if count >= 10 then
        TriggerEvent('hp-points:addPoint', source, 'Sprzedaż surowców - górnik')
    end
    TriggerEvent('hp-logs:sendLog', source, '[GÓRNIK] Sprzedał surowiec','\n**Gracz: **'..GetPlayerName(source)..'\nSprzedał: '..kamienie.label..'x '..count..' za: '..reward..'$', 'hp_miner_sprzedal')
end)
RegisterNetEvent('hp_mining:extractedStone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local kamienSlot = exports.ox_inventory:GetSlotIdWithItem(source, 'stone')
    local kamienie = exports.ox_inventory:GetSlot(source, kamienSlot)
    exports.ox_inventory:AddItem(source, kamienie.metadata.crystal, 1)
    TriggerEvent('hp-logs:sendLog', source, '[HP-MINER] Udoskonalił','\n**Gracz: **'..GetPlayerName(source)..'\n**Przetworzył: ** stone na '..kamienie.metadata.crystal, 'hp_miner_udoskonalil')
    xPlayer.removeInventoryItem('stone', 1)
    TriggerClientEvent('okokNotify:Alert', source, '[UDOSKONALENIE]', 'Udoskonaliłeś urobek na całkiem dobry zysk!', 5000, 'success')
end)

RegisterNetEvent('hp_mining:checkReward', function(data)
    math.randomseed(os.time())
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer.job.name == 'miner' then exports.hp_logs:cheatAlert(source, 'Próba odebranian nagrody bez joba górnika') return end 
    if not data then exports.hp_logs:cheatAlert(source, 'Próba odebranian nagrody bez informacji w evencie') return end 
    local chance = data.chance
    local crystalType = data.crystalType

    local random = math.random(1,100)
    local metadata = {crystal = crystalType}
    exports.ox_inventory:AddItem(source, 'stone', 1,metadata)
    TriggerEvent('hp-logs:sendLog', source, '[WYKOPAŁ KRUSZEC]','\n**Gracz: **'..GetPlayerName(source)..'\n**Wykopał na kordach: **'..data.coords..'\n**Kruszec: **'..crystalType..'\n**Index w pliku: **'..data.index,'hp_miner_wykopal')
    spawnAfterCooldown(source,data.index)
end)

function spawnAfterCooldown(source,index)
    math.randomseed(os.time())
    Wait(math.random(10*60000, 20*60000))
    local data = {
        coords = crystalData[index].coords,
        chance = crystalData[index].chance,
        model = 'emerald',
        crystalType = crystalData[index].crystalType,
        index = index,
    }
    TriggerClientEvent('hp_mining:spawnCrystals',source, data)
end
