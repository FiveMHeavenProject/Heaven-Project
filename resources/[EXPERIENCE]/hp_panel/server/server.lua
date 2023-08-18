ESX = exports['es_extended']:getSharedObject()

ESX.RegisterCommand({'heaven_stats', 'statystyki_postaci'}, 'user', function(xPlayer, args, showError)
        xPlayer.triggerEvent('hp_panel:openPanel')
end, false, {help = "Pod tą komendą będziesz w stanie ujrzeć wszystkie statystyki aktualnej postaci."})

ESX.RegisterCommand({'top_prace', 'top_job'}, 'user', function(xPlayer, args, showError)
        xPlayer.triggerEvent('hp_panel:openJobPanel', xPlayer.job.name)
end, false, {help = "Pod tą komendą będziesz w stanie ujrzeć TOP 10 pracowników w Twojej pracy"})
