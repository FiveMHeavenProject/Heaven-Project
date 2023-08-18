ESX = exports["es_extended"]:getSharedObject()

local ssWebhook = 'https://discord.com/api/webhooks/1124169009324097636/qfRhv2n1OKAIbqYOOFmnWohEmLAT-RkosqdjLMXTjsKsfsE-IJa8VTiYeaaXTRZTD6ES'
local playerHex = nil
local webhooks = {

	--exploit  słuzy do wysyłania wiadomości z everyone i nazwą skryptu który ktoś striggerował

	['exploit'] = 'https://discord.com/api/webhooks/1119569586719825940/ylmXwEI_KtYZMqtUND3Lx7_70ne3pJ-b4BLz-5bwB6iGJpPIPM4YIEoPmpENHq7C-yxF',

	--OX-Inventory --
	['command_add_item'] = 'https://discord.com/api/webhooks/1122111809189580922/nRtnFp2l6y7lBP57akg2pVLczr0y-Bs6_PN0zknm2bXxlUhV2Qq93jeRhyJjKb3rIN4q',
	['command_remove_item'] = 'https://discord.com/api/webhooks/1122125836699582464/RBd0AfTLjq67ibyC-t42xSUcWR9lBT7trsWbd30UgOFQGfI7LRn1uiD7hw5btqk2mOX2',
	['command_confiscate_eq'] = 'https://discord.com/api/webhooks/1122126577745010728/jOsvT8uhQ9t7XGpiJDQIVN-LK5PYvD6MtsSkdQ1xXlXTjf3YdtWzqh3fuNcpPNDL3tJH',
	['command_clear_eq'] = 'https://discord.com/api/webhooks/1122127611045347419/JAavhuB48f_J3amtNmHFoLtaqtQR6jfbj06yPzWP-TRKtBTQ6AxaSWyzf3BoPdgNFbzs',
	['command_view_inv'] = 'https://discord.com/api/webhooks/1122128387385860137/6Xb72DhxxfHyHVoabmUvyObTrmwB62matpJoYhbuYhtw5QW0L9QyernOZtfSpeGVkv5P',
	--Komendy ESX
	['esx_car'] = 'https://discord.com/api/webhooks/1119592731132563507/IVNODkfnCKNnFvkvCKVxB4Ea62Xq9PchP5kX34HZjOYZna53_NHU7FjxU7An0fyx7VOS',
	['esx_kick'] = 'https://discord.com/api/webhooks/1136775332461031505/BuKj_lK2ebW7l9A51OSrOyTfHr07eJaJp3OTIvMCXBc_CEib14PfBzmxL3nZm4IecEFB',
	['esx_setjob'] = 'https://discord.com/api/webhooks/1119587763843510273/HfekvmKxi2hfQcp6C121EmmTBVzZfMFNGgkvLEocUgO42jEpIGX0FD_l1Qjrvg67VJjA',
    ['esx_setaccountmoney'] = 'https://discord.com/api/webhooks/1119595211966926978/BAwmIq6NCmOL3ODr-8QFgcCI0EiVzjUb-ccPqyGQwp8j3YjEafEWGkbMLVaQJpfEff3m',
	['esx_giveaccountmoney'] = 'https://discord.com/api/webhooks/1119596715478106122/swR_RUZVCjixGitX_h1D3hSKQ9N4byB_gMAS7O0sYySH-5ECNnWB4zUukISGWWf_HVxp',
	['esx_clearall'] = 'https://discord.com/api/webhooks/1119603852677758976/5B-1iEH7YNkVKKwnoLGRPpS3Fzl8Dn6uAu8Zfhi0OfWC9xeRmCmb8Scx7g0N3858akv1',	
	['esx_setgroup'] = 'https://discord.com/api/webhooks/1119606232257417286/PmeVY2F7lx6XhqV89KHa8P8oCrFekj2ZrxjQNym8iV5CiipRH0W5jJiajI81uDLN4gY7',
	['esx_createchar'] = 'https://discord.com/api/webhooks/1119630053320429709/Irnlda3DrLVKXbxFV_dDEzEaebXZkzH6DFL7xs089eHfwRCFFvMLnqrdVwvu3VudEMkW',
	['esx_tpm'] = 'https://discord.com/api/webhooks/1121510543979724820/ESFLnptQqCmK6RAnjm7nFwBfo_n3Gk26bZPWF-TfyR-z0YcjXK0Rhc6VWrhT4LDTxh4J',
	['esx_tp'] = 'https://discord.com/api/webhooks/1121546134301716552/AsuYSeTCxKHzaOnNJJoD9DlezZxdSSc0rlXJWw55ksDGNXShOZKgYe3zkS4_c70-dhZA',
	['esx_goto'] = 'https://discord.com/api/webhooks/1125031770656612425/iglnTw0y6Pt3vya7nkBrREx1oTOQ_ZVgOnKidwMQ_w2LkfTPt1xDYlMeyttURRAxIAae',
	['esx_bring'] = 'https://discord.com/api/webhooks/1125032911234682901/a2YZwHBswwrT6E4R_V7HelIKNkyJ7PlhYLG0zy7D_-jUAQw7l7mBG-a8lMmYtJNQWY69',
	['esx_heal'] = 'https://discord.com/api/webhooks/1125135857205121084/ikMIHGr0GipW1NqxEVXMJO7jja0nMKL_gDr6oICQ4G7QrQtkHw3TnRNRhhzin0bp1g5A',
	['esx_stats'] = 'https://discord.com/api/webhooks/1130027671640866876/N0nT0BaLT7NVdBAmEAAE1f-Qq4RXRM7a5Rn0la-BQJlnaHUh8ukVdSwmRa5hq2Cv9Ns_',
	--Główne
    ['connect-ip'] = 'https://discord.com/api/webhooks/1119541830019723316/fj5b6vSWVwR9eiXVeLGOqw-1KXhMhLPj8JKiV_1PY2RlhioOftu2r_xf_BD7zW5MbPhN',
    ['connect'] = 'https://discord.com/api/webhooks/1119541909837336617/uE19z2W3X0nK035xJs63K2IHY6TmUYskXY1rbiYUXTz8lfkasZ7R9GEjpnPjxuAhLA-N',
    ['disconnect'] = 'https://discord.com/api/webhooks/1119541965952921650/Ucpy3gC3xoX1LrwSWV0mbMnUOQy108059gcvy4WbvIJ39JIydXjlsnlUU6BQpnDubYm3',
	['zabicia'] = 'https://discord.com/api/webhooks/1119636833207337010/8ZzgzLry7hRzlmtKROiABIJ0vZcrDNJwmnOzWeQBWv_PxkMvYJXzmn2uxb9sbpzdeJBC',
	
    --TxAdmin
    ['txAdminBan'] = 'https://discord.com/api/webhooks/1119558394144116777/TYF8Cfotu1R43QyjOnFKQWsQRT7DkyBvU9umF6ZSMYohqEksBKOwKkbjFzco41RBZOXP',
    ['txAdminKick'] = 'https://discord.com/api/webhooks/1119558466936250378/PWy0CayA-fHB2uDpakrG4SoCulU8qqWIQepyXD1U6xpEOrKExMXwliY4_1cBdV1rzHz7',
	 
	--hp_poinsty
	['hp_points_dodal'] = 'https://discord.com/api/webhooks/1119562284012945461/RW3WX7d8nr5rtq1VIiy2eu1fCgtdj_Nfi1kPSluzLakehdr0KdEGtUGE-SttmROgm-Df',
	['hp_points_zabral'] = 'https://discord.com/api/webhooks/1119566137001250866/cV_pk3L7DjMXExUpL_OBwqBJPhG6hMScSWm9CPzocDzSou8YdIImWWYe09-RJxF8UsHj',
	['hp_points_wyzerowal'] = 'https://discord.com/api/webhooks/1119568964524200046/5foERLzfxMGWLrUL6VOTSIqRTHrE725kjQVJERjL96oHkO8Fbjm4SthK1WdPQLSGWC5n',
	['hp_points_sprawdzil'] = 'https://discord.com/api/webhooks/1119570028396826644/N3QcWA8C3xSUymoYyJG_YUgpsqIuTEy2Ral7Xb8g_zqa1eXrgYXVHXxgg4wxCHrbHUOK',
	['hp_points_dodal_skrypt'] = 'https://discord.com/api/webhooks/1119570456362627083/3SaBNGG6bOX1FXVJ7A8Smgsy0C9ERbZUfWBZRLRwo-sZ7uAGID7pX6oTg6VWd9e-lp9D',

	--esx_society
	['society_wyplata_gotowki'] = 'https://discord.com/api/webhooks/1119646118620442665/B-j13nGQJk23n6SKnxfis3BmRvD4L6FRh5DelEyy3zWixDDiUkUtBGWvwTTrPe4kR0po',

	--Silownia
	['hp_gym_komenda'] = 'https://discord.com/api/webhooks/1120394005058949203/ah_6X-mrkb_MHdXX8bbLBqt5sx_wFY28-Y0qtLo5k8HhjJ8c4Vd_R-WIjjgvD-qdcsIL',
	['hp_gym_zdobyl'] = 'https://discord.com/api/webhooks/1120940310940368998/7NiZWS0QeZqYLmT2XeBVw5QMO4OOlviO22R5xZY4K0f_ps7iI221NvN2_dIC34GDWrQ6',
	
	--ESX PROPERTY
	['property_zakupił_dom'] = 'https://discord.com/api/webhooks/1121148816058486844/pZhIzREtzlfe8ueRky8fMr5NY_fk3N8OlgsEANXgtVjAX8aKseByCLjzo_TcX93ZoKOd',
	['property_sprzedal_graczu'] = 'https://discord.com/api/webhooks/1121149123886862437/8i9y4K18BaiBFkkqmWHjTkKpcqNOgNongB_mnen6bx8OuaLWPV9exk4ULF0RNEqGYawv',
	['property_kupil_mebel'] = 'https://discord.com/api/webhooks/1121462274763276298/Hel0PLsNptxo-jV4Ay-aexNAKlHyMLjKoicvF7zknO_sgNbZlvdNXEXDPhvWx4eWKDWi',

	--Prace

	['hp_miner_wykopal'] = 'https://discord.com/api/webhooks/1124153157640003615/b6qlxqg1ZzeuJt0uUlOntYneqLfLO-Es3k86xl2P8kTqTjV6AeCjRGLrk88ji6pxX3zC',
	['hp_miner_udoskonalil'] = 'https://discord.com/api/webhooks/1124336563514523820/-np3WXZ9emmj2gPXzoOT6gP1i0ZFL_gswsBBpAN5x-1sgNmX7j8RF2qUTF4UFZ3Dv7OV',
	['hp_miner_sprzedal'] = 'https://discord.com/api/webhooks/1125028062589898833/E9cTi-DY8ctinfJwJlaGwBB-acbaVXmytmBn9600oq2tQwQJvUdl0M5adqaG5FGEqGZm',
	['hp_winiarz_zebral'] = 'https://discord.com/api/webhooks/1127203695185100842/1bn2s81CQFhVNihVcsEh1YSgOJYf6TmOUnbzRKDdwpVBhvk26GGNUy7KPzcP0E24I7MD',
	['hp_winiarz_przerobil'] = 'https://discord.com/api/webhooks/1127204495760298004/byTcD3NJ53gZqxA-DITiV2fbu_KE1s0orIAmb9i7hFYM7s7BZeZqJRjEfbfr7J23MfJN',



	--Ox-Inventory

} 	


local svData = {
	avatar = 'https://i.imgur.com/wGdgOz8.png',
	footer_image = 'https://i.imgur.com/SOYOobY.png'
}
local playerSteam = nil
local result = {}

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	print("["..GetCurrentResourceName().."] | Gracz: ^1"..GetPlayerName(source)..' ^7próbuje połączyć się z serwerem')
	sendConnectLogIP(source, true, webhooks["connect-ip"])
	sendConnectLogIP(source, false, webhooks["connect"])
	CheckIfAbuseScript(source, deferrals)
end)

function sendConnectLogIP(source, ip, webhook)
	local nazwa 		= GetPlayerName(source)
	local steamHex      = "Nie znaleziono"
	local playerip      = "Nie znaleziono"
	local playerdiscord = "Nie znaleziono"
	local liveid        = "Nie znaleziono"
	local xbl 			= "Nie znaleziono"
	local licenses 		= "Nie znaleziono"
	local coords        = "Nie znaleziono"
	local killer        = "Nie znaleziono"
	local ipGeoLocation = "Brak uprawnień"
    local identifiers = getIdentifiers(source)
	local iptext
	
	if identifiers.steam then
		steamHex = identifiers.steam
	end
	if identifiers.ip then
		playerip = identifiers.ip
	end

	if identifiers.discord then
		playerdiscord = identifiers.discord
	end
	if identifiers.license then
		licenses = identifiers.license
	end
	if identifiers.live then
		liveid = identifiers.live
	end

	if identifiers.xbl then
		xbl = identifiers.xbl
	end
	if ip then
		ipGeoLocation = "http://ip-api.com/json/"..playerip
		iptext = "||["..playerip.."]("..ipGeoLocation..")||"
    else
		iptext = "||[Brak uprawnień]||" 
	end
	if not ip then
		ipGeoLocation = "Brak uprawnień"
		iptext = "||"..ipGeoLocation.."||"
	end 
	
	local hexToDec = tonumber(steamHex, 16)
    local reqURL = 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' .. GetConvar('steam_webApiKey')..'&steamids='..hexToDec
	PerformHttpRequest(reqURL, function(error, result, header)
        local data = json.decode(result)
        local profileURL ='[**steam:'..steamHex..'**]('..data['response']['players'][1]['profileurl']..')' 
		local embeds = {
			{
				["author"] = {
					["name"] = "Connect IP",
					["icon_url"] = svData.footer_image,
				},
				["description"] = "__Nawiązano połączenie__\n\n",
				["type"] = "rich",
				["color"] = 1146986,
				["fields"] = {
					{
						["name"] = "🥰 ID Gracza:",
						["value"] = source,
						["inline"] = true
					},
					{
						["name"] = "😗 Nick gracza:",
						["value"] = nazwa,
						["inline"] = true
					},
					{
						["name"] = "😻 IP Gracza",
						["value"] = iptext,
						["inline"] = false
					},
					{
						["name"] = "😎 DiscordID:",
						["value"] = '<@'..playerdiscord..'>'..' | '..playerdiscord,
						["inline"] = true
					},
					{
						["name"] = "🤠 Steam",
						["value"] = profileURL,
						["inline"] = true
					},
					{
						["name"] = "😶 Licencja:",
						["value"] = licenses,
						["inline"] = false
					},
					{
						["name"] = "🤔 LiveID:",
						["value"] = liveid,
						["inline"] = true
					},
					{
						["name"] = "😯 XBoxLive:",
						["value"] = xbl,
						["inline"] = true
					}
				},
				["footer"]=  {
					["text"] = os.date('%Y-%m-%d %H:%M:%S').." | Logi Heaven Project",
					["icon_url"] = svData.footer_image,
				},
			},
		}
		PerformHttpRequest(webhook, function(err,text,headers) end, 'POST',  json.encode({ username = "Nawiązano połączenie", embeds = embeds, avatar_url = svData.avatar}), { ['Content-Type'] = 'application/json' })
		if ip then
			PerformHttpRequest(webhooks['esx_stats'], function(err,text,headers) end, 'POST',  json.encode({ username = "Heaven-Project", embeds = embeds, avatar_url = svData.avatar}), { ['Content-Type'] = 'application/json' })
		end
	end, 'GET', '', { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerDropped', function (reason)
    local eq = exports.ox_inventory:GetInventoryItems(source)
    local inventory = {}
	if eq == {} then
		inventory[#inventory+1] = "Brak"
	elseif not eq then
		inventory[#inventory+1] = "Brak"
	else
		for i=1, #eq do
			if eq[i] then
				inventory[#inventory+1] = eq[i].label .. ' x'..eq[i].count
			end
		end
	end
    TriggerEvent('hp-logs:sendLog', source, '[DISCONNECT] '..GetPlayerName(source), '**Gracz: **'..GetPlayerName(source)..'\n\n\n**Opuścił serwer**\n**Powód: **'..tostring(reason).."\nEkwipunek: \n"..json.encode(inventory), 'disconnect')
end)

RegisterNetEvent('hp-logs:sendLog',function(source,author, message,webhookLink)
	local nazwa = GetPlayerName(source)
	local steamHex      = "Nie znaleziono"
	local playerdiscord = "Nie znaleziono"
	local liveid        = "Nie znaleziono"
	local xbl 			= "Nie znaleziono"
	local licenses 		= "Nie znaleziono"
    local identifiers = getIdentifiers(source)
	local contentMessage = 'Informacje: '

	if identifiers.steam then
		steamHex = identifiers.steam
	end

	if identifiers.license then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer then
			licenses = xPlayer.identifier
		else
			licenses = identifiers.license
		end
	end

	if identifiers.discord then
		playerdiscord = identifiers.discord
	end

	if identifiers.live then
		liveid = identifiers.live
	end

	if identifiers.xbl then
		xbl = identifiers.xbl
	end
	if webhookLink == 'exploit' then
		contentMessage = '||@everyone|| **Skrypt który striggerowano: ' .. GetInvokingResource()..'**'
	end



    local hexToDec = tonumber(steamHex, 16)
    local reqURL = 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' .. GetConvar('steam_webApiKey')..'&steamids='..hexToDec
    PerformHttpRequest(reqURL, function(error, result, header)
        local data = json.decode(result)
        local profileURL ='[**steam:'..steamHex..'**]('..data['response']['players'][1]['profileurl']..')' 
               

        local embeds = {
            {
                ["author"] = {
                    ["name"] =author,
                    ["icon_url"] = svData.footer_image,
                },
                ["description"] = message,
                ["type"] = "rich",
                ["color"] = 1146986,
                ["fields"] = {
                    {
                        ["name"] = "🥰 ID Gracza:",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "😗 Nick gracza:",
                        ["value"] = nazwa,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "😎 DiscordID:",
                        ["value"] = '<@'..playerdiscord..'>'..' | '..playerdiscord,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🤠 Steam",
                        ["value"] = profileURL,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "😶 Licencja:",
                        ["value"] = licenses,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🤔 LiveID:",
                        ["value"] = liveid,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "😯 XBoxLive:",
                        ["value"] = xbl,
                        ["inline"] = true
                    },
                },
                ["footer"]=  {
                    ["text"] = os.date('%Y-%m-%d %H:%M:%S').." | Logi Heaven Project",
                    ["icon_url"] = svData.footer_image,
                },
            },
        }

	    PerformHttpRequest(webhooks[webhookLink], function(err,text,headers) end, 'POST',  json.encode({ username = author, embeds = embeds, avatar_url = svData.avatar, content = contentMessage}), { ['Content-Type'] = 'application/json' })
    end, 'GET', '', { ['Content-Type'] = 'application/json' })
end)




function getIdentifiers(player)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local raw = GetPlayerIdentifier(player, i)
        local tag, value = raw:match("^([^:]+):(.+)$")
        if tag and value then
            identifiers[tag] = value
        end
    end
    return identifiers
end


--TXAdmin

AddEventHandler('txAdmin:events:playerKicked', function(data)
	TriggerEvent('hp-logs:sendLog', data.target, '[ZOSTAŁ WYRZUCONY]', '**Gracz: **'..GetPlayerName(data.target)..'\n**Został wyrzucony przez: **'..data.author..'\n**Powód: **'..data.reason, 'txAdminKick')
end)

AddEventHandler('txAdmin:events:playerBanned', function(data)
	local admin = data.author
	local reason = data.reason
	local actionId = data.actionId
	local bannedName = data.targetName
	local kickMessage = data.kickMessage
	local player = data.targetNetId
		
	TriggerEvent('hp-logs:sendLog', player, '[ZBANOWANY]', '**Gracz: **'..bannedName..'\n**Powód: **'..reason..'\nZbanowany przez: '..admin..'\nID: '..actionId..'\n**Ban wygasa: **'..tostring(expiration)..'\n**Wiadomość po wyrzuceniu: **'..kickMessage, 'txAdminBan')
end)

ESX.RegisterCommand('ss', {'admin', 'mod', 'support'}, function(xPlayer, args, showError)
	if not args then return end
	local tPlayer = args.id
	TriggerClientEvent('heaven-misc:makeScreenshot',tPlayer.source, ssWebhook)
	
end, true, {help = "Zrób screena graczowi.", arguments = {
		{
			name = 'id', help = "ID gracza", type = 'player'
		},
	}
})
