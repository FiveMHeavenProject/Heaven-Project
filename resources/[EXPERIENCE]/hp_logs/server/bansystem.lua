
local PlayerBans = {}
function refreshBans()
	MySQL.query('SELECT * FROM `users_script_ban`', function(response)
		if response then
			for i = 1, #response do
				local data = response[i]
				PlayerBans[i] = {
					id = data.id or "Brak",
					name = data.name,
					licenses = data.licenses or "Brak",
					discord = data.discord or "Brak",
					steam = data.steam or "Brak",
					live = data.live or "Brak",
					xbl = data.xbl or "Brak",
					banned = data.banned or "Brak",
					isActive = data.isActive or "Brak",
					reason = data.reason or "Brak",
					script_abuse = data.script_abuse or "Brak",
					admin = data.admin or "Brak"
				}
			end
		end
	end)
end

CreateThread(function()
	while true do
		refreshBans()
		Wait(5 * 60000)
	end
	
end)

function CheckIfAbuseScript(source, deferrals)
	
	deferrals.defer()
	Wait(0)
	deferrals.update("Sprawdzanie banów...")
	Wait(0)
	local steamHex      = "Nie znaleziono"
	local discord 		= "Nie znaleziono"
	local liveid        = "Nie znaleziono"
	local xbl 			= "Nie znaleziono"
	local licenses 		= "Nie znaleziono"
    local identifiers = getIdentifiers(source)
	if identifiers.steam then
		steamHex = identifiers.steam
	end
	if identifiers.license then
		licenses = identifiers.license
	end
	if identifiers.discord then
		discord = identifiers.discord
	end
	if not discord then deferrals.done("Brak podpiętego discorda pod FiveM!") end

	if identifiers.live then
		liveid = identifiers.live
	end
	if identifiers.xbl then
		xbl = identifiers.xbl
	end
	for i=1, #PlayerBans do
		if PlayerBans[i].licenses == licenses or PlayerBans[i].discord == discord or PlayerBans[i].steam == steamHex or PlayerBans[i].live == liveid or PlayerBans[i].xbl == xbl then
       		 if PlayerBans[i].isActive == 1 then  
                Wait(0)
                deferrals.done("[HEAVEN-PROJECT] Zostałeś zbanowany. BanID: "..PlayerBans[i].id.." Zbanowany dnia: "..PlayerBans[i].banned..'. Odwołać się możesz jedynie przez ticket.')
                break
            end
        end
	end

	Wait(0)
	deferrals.done()
end	


ESX.RegisterCommand('unban_sql', 'admin', function(xPlayer, args, showError)
	if not args then return end

	for i=1, #PlayerBans do
		if PlayerBans[i].id == tonumber(args.id) and PlayerBans[i].isActive == 1 then
			MySQL.update('UPDATE `users_script_ban` SET isActive = ? WHERE id = ?', {
				0,tonumber(args.id)
            }, function(affectedRows)                
                if not xPlayer then print("["..GetCurrentResourceName().."] Użycie komendy unban_sql. Odbanowano pomyślnie: "..PlayerBans[i].name) end
                if xPlayer then xPlayer.triggerEvent('okokNotify:Alert', 'SQL UNBAN', 'Odbanowano gracza: '..PlayerBans[i].name, 5000, 'success') end
				PlayerBans[i].isActive = 0
                --refreshBans()
            end)
			break
            
		end
	end

end, true, {help = "Odbanuj gracza", arguments = {
		{
			name = 'id', help = "ID Bana", type = 'number'
		},
	}
})

ESX.RegisterCommand('ban_refresh', {'support', 'mod', 'admin'}, function(xPlayer, args, showError)
	refreshBans()
end, true)

ESX.RegisterCommand('sql', {'admin'},function(xPlayer, args, showError)
	print('^1[*]^5 /ban_sql [licencja_gracza bez przedrostka] [powod_bana] (Banuje gracza permanentnie na serwerze.)')
	print('^1[*]^5 /unban_sql [ban_id] (Odbanowuje wybranego gracza z ban_id)')
	print('^1[*]^5 Skrypt napisany przez resesetti')

end,true)


ESX.RegisterCommand('ban_sql', 'admin', function(xPlayer, args, showError)
	if not args.licencja or not args.powod then return end
	if not string.find(args.licencja, 'cha') then
		local bannedDate = os.date('%Y-%m-%d %H:%M:%S')
		local searchBan = MySQL.query.await("SELECT `isActive` FROM `users_script_ban` WHERE `licenses` = ?", {args.licencja})
		local banId
		local affectedRows = 0
		if searchBan[1] then 
			if searchBan[1].isActive == 1 then
				if xPlayer then
					xPlayer.triggerEvent('okokNotify:Alert', 'SQL BAN', 'Ta osoba jest już zbanowana', 10000, 'success')
					return
				else
					print("["..GetCurrentResourceName().."] Ta osoba jest już zbanowana")
					return
				end
			end
		end
		local banFinded = false
		if searchBan[1] and searchBan[1].isActive == 0 then
			affectedRows = MySQL.update.await('UPDATE `users_script_ban` SET `isActive` = ?, `reason` = ? WHERE licenses = ?', {1,args.powod,args.licencja})
			for k,v in pairs(PlayerBans) do
				if PlayerBans[k].licenses == args.licencja then
					PlayerBans[k] = {name = "Brak", licenses = args.licencja, steam = "Brak", discord = "Brak", live = "Brak", xbl = "Brak", banned = bannedDate, isActive = 1, reason = args.powod, script_abuse = "Brak informacji",admin = xPlayer and GetPlayerName(xPlayer.source) or 'Konsola'}
					break
				end
			end
		else
			banId = MySQL.insert.await('INSERT INTO `users_script_ban` (name, licenses,steam,discord,live,xbl,banned,isActive,reason,script_abuse, admin) VALUES (?,?,?,?,?,?,?,?,?,?,?)', 
			{"Brak", args.licencja,"Brak", "Brak", "Brak", "Brak", bannedDate, 1, args.powod, "Brak informacji",xPlayer and GetPlayerName(xPlayer.source) or 'Konsola'})
			for k,v in pairs(PlayerBans) do
				if PlayerBans[k].licenses == args.licencja then
					PlayerBans[k] = {name = "Brak", licenses = args.licencja, steam = "Brak", discord = "Brak", live = "Brak", xbl = "Brak", banned = bannedDate, isActive = 1, reason = args.powod, script_abuse = "Brak informacji",admin = xPlayer and GetPlayerName(xPlayer.source) or 'Konsola'}
					break
				end
			end
		end
		for k,v in pairs(PlayerBans) do
			if v.licenses == args.licencja then
				PlayerBans[k] = {id = banId,name = "Brak", licenses = args.licencja, steam = "Brak", discord = "Brak", live = "Brak", xbl = "Brak", banned = bannedDate, isActive = 1, reason = args.powod, script_abuse = "Brak informacji",admin = xPlayer and GetPlayerName(xPlayer.source) or 'Konsola'}
				banFinded = true
				break
			end
		end
		if not banFinded then
			PlayerBans[#PlayerBans+1] = {id = banId,name = "Brak", licenses = args.licencja, steam = "Brak", discord = "Brak", live = "Brak", xbl = "Brak", banned = bannedDate, isActive = 1, reason = args.powod, script_abuse = "Brak informacji",admin = xPlayer and GetPlayerName(xPlayer.source) or 'Konsola'}
		end
		if banId or affectedRows > 0 then
			local tPlayer = ESX.GetPlayerFromIdentifier(args.licencja)
			if tPlayer then
				DropPlayer(tPlayer.source, 'Zostałeś zbanowany na tym serwerze. Jeśli uważasz że jest to niesłuszny ban zgłoś się w tickecie podając swoje ID.')
			end
			if xPlayer then
				xPlayer.triggerEvent('okokNotify:Alert', 'SQL BAN', 'Gracz został zablokowany pomyślnie!', 10000, 'success')
				return
			else
				print("["..GetCurrentResourceName().."] Gracz został zablokowany pomyślnie!")
				return
			end
		end
		if not xPlayer then print("["..GetCurrentResourceName().."] Wystąpił nieoczekiwany błąd. Zgłoś to na kanale administracyjnym.") return end
		xPlayer.triggerEvent('okokNotify:Alert', 'SQL BAN', 'Wystąpił nieoczekiwany błąd. Zgłoś to na kanale administracyjnym!', 10000, 'success')
		return
	else
		if xPlayer then
			xPlayer.triggerEvent('okokNotify:Alert', 'SQL BAN', 'Wpisano niepoprawną licencję docelowego gracza. Najłatwiej będzie Ci ją znaleźć w logach. Licencja nie może zawierać CHAR', 10000, 'success')
			return
		else
			print("["..GetCurrentResourceName().."] Wpisano niepoprawną licencję docelowego gracza. Najłatwiej będzie Ci ją znaleźć w logach. Licencja nie może zawierać CHAR")
			return
		end
	end
end, true, {help = "Zbanuj gracza permamentnie.", arguments = {
	{
		name = "licencja", help = "Licencja gracza bez char oraz license", type = 'string'
	},
	{
		name = 'powod', help = "Powód blokady (Nie wyświetli się graczowi)", type = 'string'
	}
}})

function cheatAlert(source, action)
	local discord 		= "Nie znaleziono"
	local liveid        = "Nie znaleziono"
	local steamHex 		= "Nie znaleziono"
	local xbl 			= "Nie znaleziono"
	local licenses 		= "Nie znaleziono"
    local identifiers = getIdentifiers(source)
	local bannedDate = os.date('%Y-%m-%d %H:%M:%S')

	if identifiers.steam then
		steamHex = identifiers.steam
	end
	if identifiers.license then
		licenses = identifiers.license
	end
	if identifiers.discord then
		discord = identifiers.discord
	end
	if identifiers.live then
		liveid = identifiers.live
	end
	if identifiers.xbl then
		xbl = identifiers.xbl
	end
	TriggerClientEvent('heaven-misc:makeScreenshot',source, 'https://discord.com/api/webhooks/1124249022182469753/PrRUS3scn5qNYVU3pXRYZ1gH7cvIslhj2rKVXptBolJtXntJYR2ZW-izXNRj4WtGT-JL')
	Wait(300)
	TriggerEvent('hp-logs:sendLog', source, '[EXPLOIT BAN]', '\n\n**Gracz: **'..GetPlayerName(source)..'\n**Wyzwolona akcja: **'..action, 'exploit')

	local banId = MySQL.insert.await('INSERT INTO `users_script_ban` (name, licenses,steam,discord,live,xbl,banned,isActive,reason,script_abuse, admin) VALUES (?,?,?,?,?,?,?,?,?,?,?)', {GetPlayerName(source), licenses,steamHex, discord, liveid, xbl, bannedDate, 1, action, GetInvokingResource(), 'Zbanowany automatycznie'})
	
	PlayerBans[#PlayerBans+1] = {id = banId,name = GetPlayerName(source), licenses = licenses, steam = steamHex, discord = discord, live = liveid, xbl = xbl, banned = bannedDate, isActive = 1, reason = action, script_abuse = GetInvokingResource(), admin = 'Zbanowany automatycznie'}
	DropPlayer(source, 'Zostałeś zbanowany | Jeśli uważasz że to przypadek zgłoś sprawę w tickecie na naszym discordzie!') 
	
end