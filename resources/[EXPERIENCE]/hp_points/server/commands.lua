ESX.RegisterCommand('hp_dodaj', 'admin', function(xPlayer, args, showError)
    if not tonumber(tonumber(args.punkty)) or not tostring(args.powod) then return end
    if not args.xTarget then xPlayer.triggerEvent('esx:showNotification', 'Brak gracza na serwerze', true, true) return end
    local xTarget = args.xTarget
    local xPoints = xTarget.getMeta('hp_points') or 0
    xPoints = xPoints + tonumber(args.punkty)
    xTarget.setMeta('hp_points', xPoints)
    xTarget.triggerEvent('esx:showNotification', '~y~Dodano Ci: '..tonumber(args.punkty).. ' HP Points przez Administratora: '..GetPlayerName(xPlayer.source), true, true)
    xPlayer.triggerEvent('esx:showNotiifcation', '~y~Pomyślnie dodano: '..tonumber(args.punkty)..' graczowi: '..GetPlayerName(xTarget.source)..' powód: '..args.powod, true, true)

   TriggerEvent('hp-logs:sendLog', xPlayer.source, '[DODAŁ HP POINTSY]','\n\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Dodał punkty**\n\n**Ilość: **'..tonumber(args.punkty)..'\n**Graczowi: **'..GetPlayerName(tonumber(args.xTarget.source))..'\n**Powód: '..tostring(args.powod)..'**', 'hp_points_dodal')
  end, false, {help = "Komenda służy do dodawania HP Pointsów", arguments = {
        {
            name = 'xTarget', help = "ID", type = 'player'
        },
        {
            name = 'punkty', help = "Wprowadź ilość do dodania", type = 'number'
        },
        {
            name = 'powod', help = "Wprowadź powód dodania", type = 'string'
        },
    }
})
ESX.RegisterCommand('hp_zabierz', 'admin', function(xPlayer, args, showError)
    if not tonumber(args.punkty) or not tostring(args.powod) then return end
    if not args.xTarget then xPlayer.triggerEvent('esx:showNotification', 'Brak gracza na serwerze', true, true) return end
    local xTarget = args.xTarget
    local xPoints = xTarget.getMeta('hp_points') or 0
    if xPoints == 0 then xPlayer.triggerEvent('esx:showNotification', '~y~Gracz nie posiada hp_pointsów!', true, true) return end
    xPoints = xPoints - tonumber(args.punkty)
    xTarget.setMeta('hp_points', xPoints)
    if xTarget.getMeta('hp_points') < 0 then xTarget.setMeta('hp_points', 0) end
    xPlayer.triggerEvent('esx:showNotification', '~y~Pomyślnie zabrano: '..tonumber(args.punkty)..' punktów.', true, true)
    xTarget.triggerEvent('esx:showNotification', '~y~Zabrano Ci: '..tonumber(args.punkty)..' przez: '..GetPlayerName(xPlayer.source)..' powód: '..args.powod, true, true)

    TriggerEvent('hp-logs:sendLog', xPlayer.source, '[ZABRAŁ HP POINSTY]','\n\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Zabrał punkty**\n\n**Ilość: '..tonumber(args.punkty)..'\n\n**Powód: '..tostring(args.powod)..'**', 'hp_points_zabral')
  end, false, {help = "Komenda służy do zabierania HP Pointsów", arguments = {
        {
            name = 'xTarget', help = "ID", type = 'player'
        },
        {
            name = 'punkty', help = "Wprowadź ilość do zabrania", type = 'number'
        },
        {
            name = 'powod', help = "Wprowadź powód zabrania punktów", type = 'string'
        },
        
    }
})

ESX.RegisterCommand('hp_wyzeruj', 'admin', function(xPlayer, args, showError)
    if not args.xTarget then xPlayer.triggerEvent('esx:showNotification', 'Brak gracza na serwerze') return end
    args.xTarget.setMeta('hp_points', 0)
    xPlayer.triggerEvent('esx:showNotification', 'Pomyślnie wyzerowano punkty', true)
    args.xTarget.triggerEvent('esx:showNotification', 'Twoje punkty zostały wyzerowane przez administratora: '..GetPlayerName(xPlayer.source), true)
    
    TriggerEvent('hp-logs:sendLog', xPlayer.source, '[WYZEROWAŁ PUNKTY]','\n\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Wyzerował punkty graczowi: **'..GetPlayerName(args.xTarget.source), 'hp_points_wyzerowal')

  end, false, {help = "Komenda służy do zerowania HP Pointsów", arguments = {
        {
            name = 'xTarget', help = "ID", type = 'player'
        },
        {
            name = 'powod', help = "Wprowadź powód do dodania", type = 'string'
        }
    }
})
ESX.RegisterCommand('hp_sprawdz', 'admin', function(xPlayer, args, showError)
    if not tostring(args.powod) then return end
    if not args.xTarget then xPlayer.triggerEvent('esx:showNotification', 'Brak gracza na serwerze', true, true) return end
    if not xPlayer.getMeta('hp_points') then xPlayer.setMeta('hp_points', 0) end
    xPlayer.triggerEvent('esx:showNotification', '~r~Ilość hp_pointsów gracza: '..GetPlayerName(args.xTarget.source)..': ~y~'..args.xTarget.getMeta('hp_points'), true, true)

    TriggerEvent('hp-logs:sendLog', xPlayer.source, '[SPRAWDZIŁ PUNKTY]','\n\n**Admin: **'..GetPlayerName(xPlayer.source)..'\n**Sprawdził punkty gracza: **'..GetPlayerName(args.xTarget.source), 'hp_points_sprawdzil')

  end, false, {help = "Wprowadź ID gracza", arguments = {
        {
            name = 'xTarget', help = "ID", type = 'player'
        },
        {
            name = 'powod', help = "Wprowadź powód sprawdzania punktów", type = 'string'
        }
    }
})