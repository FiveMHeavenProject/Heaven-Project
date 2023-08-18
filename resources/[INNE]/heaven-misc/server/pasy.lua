RegisterNetEvent('heaven-misc:pasy', function(action, players)
    if action == 'beltoff' or action == 'belton' then
        TriggerClientEvent('InteractSound_CL:PlayOnOne', source,  action, 0.40) 
        if players[1] then
            for i=1, #players do
                if players[i] then
                    TriggerClientEvent('InteractSound_CL:PlayOnOne', players[i],  action, 0.40) 
                end
            end
        end
    else
        exports.hp_logs:cheatAlert(source, 'Próba wywołania innego dźwięku niż tego od pasu. Docelowy dźwięk jaki gracz chciał użyć: '..action)
    end
end)
