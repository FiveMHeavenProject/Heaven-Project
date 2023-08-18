local cmndsType = {
    ["sila"] = 'gym_strength',
    ['kondycja'] = 'gym_stamina'
}

ESX.RegisterCommand('silownia_ustaw', 'admin', function(xPlayer, args, showError)
    --print(ESX.DumpTable(args))
    --if not xTarget or not args.punkty or not args.powod or args.punkty == 0 then return end
    if args.typ == 'sila' or args.typ == 'kondycja' then 
        local xTarget = args.xTarget

        local typs = cmndsType[args.typ]
        xTarget.setMeta(typs, {points=args.punkty})
        TriggerClientEvent('hp_gym:refreshSkill', xTarget.source)
        TriggerClientEvent('okokNotify:Alert', xPlayer.source, '[INFO]', 'Dodano: '..args.punkty..' graczowi '..GetPlayerName(xTarget.source), 5000, 'success')
        TriggerClientEvent('okokNotify:Alert', xTarget.source, '[INFO]', 'Otrzymano: '..args.punkty..' od administratora '..GetPlayerName(xPlayer.source), 5000, 'success')

        TriggerEvent('hp-logs:sendLog', xPlayer.source, '[DODAŁ PUNKTY]','\n**Admin: **'..GetPlayerName(xTarget.source)..'\n**Dodał punkty: **'..typs..'\n**Graczowi: **'..GetPlayerName(xTarget.source)..'\n**Ilość:** '..args.punkty..'\n**Powód: **'..args.powod, 'hp_gym_komenda')
      
    end
end, false, {help = "Komenda służy do dodawania HP Pointsów", arguments = {
        {
            name = 'xTarget', help = "ID", type = 'player'
        },
        {
            name = 'typ', help = "Typ punktów - Wpisz sila lub kondycja", type = 'string'
        },
        {
            name = 'punkty', help = "Wprowadź ilość", type = 'number'
        },
        {
            name = 'powod', help = "Wprowadź powód dodania", type = 'string'
        },
    }
})

--[[ESX.RegisterCommand('hp_setmeta', 'admin', function(xPlayer, args, showError)
    if not args.xTarget or not args.typ or not args.wartosc or not args.powod or not args.index then return end
    local tPlayer = args.xTarget
    tPlayer.setMeta(tostring(args.typ), {args.index=args.wartosc})
    TriggerClientEvent('okokNotify:Alert', xPlayer.source, '[ADMIN]', 'USTAWIONO: '..args.typ..' | Wartość: '..args.wartosc..' graczowi: '..GetPlayerName(tPlayer.source))
end, false, {help = "Komenda służy do nadawania xPlayer.setMeta", +arguments = {
        {
            name = 'xTarget', help = "ID", type = 'player'
        },
        {
            name = 'typ', help = "Jakie dane ustawiasz?", type = 'string'
        },
        {
            name = 'index', help = "Kategoria jaką ma przyjąć wartość", type = 'any'
        },
        {
            name = 'wartosc', help = "Jakie wartość chcesz ustawic?", type = 'any'
        },
        {
            name = 'powod', help = "Powód nadania metadanych", type = 'string'
        },
    }
})--]]