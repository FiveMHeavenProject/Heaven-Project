ESX = exports["es_extended"]:getSharedObject()

for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return config[xPlayer.job.name]
    end)
end

ESX.RegisterUsableItem("radio", function(source)
    TriggerClientEvent('hp_radio:use', source)
end)

lib.callback.register("hp_fraction_radio:GetPlayersInChannel", function(source, channel)
    local PlayersOnRadio = exports["pma-voice"]:getPlayersInRadioChannel(channel)
    local data = {}
    for k, v in pairs(PlayersOnRadio) do
        if v == false then
            local xPlayer = ESX.GetPlayerFromId(k)
            data[k] = {
                name = xPlayer.getName(),
                badge = xPlayer.get('badge'),
                id = k,
            }
        end
    end
    return data
end)

lib.callback.register("hp_fraction_radio:GetPlayerData", function(source, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    return {
        name = xPlayer.getName(),
        badge = xPlayer.get('badge')
    }
end)