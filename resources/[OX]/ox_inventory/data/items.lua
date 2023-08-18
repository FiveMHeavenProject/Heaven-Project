return {
	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Brudna gotówka',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['cola'] = {
		label = 'Coca-Cola',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'Wypiłeś colę'
		}
	},

	['parachute'] = {
		label = 'Spadochron',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Śmieci',
	},

	['paperbag'] = {
		label = 'Torba papierowa',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},
	['gold_watch'] = {
		label = "Złoty zegarek",
		weight  = 140,
	},
	['chair'] = {
		label = "Drewniane krzesło",
		weight = 400,
		stack = false,
		close = false
	},
	['monitor'] = {
		label = "Gamingowy Monitor",
		weight = 1000,
		stack = false, 
		close = false,
	},
	['showerdoor'] = {
		label = 'Drzwi prysznicowe',
		weight = 400,
		stack = false,
		close = false
	},
	['bongo'] = {
		label = "Bongo",
		weight =  250,
		stack = false,
		close = false
	},
	['lockpick'] = {
		label = 'Wytrych',
		weight = 160,
	},
	['bung_bundle'] = {
		label = "Karton pełen fantów",
		weight = 1000,
		stack = false,
		close = false
	},

	['phone'] = {
		label = 'Telefon',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Gotówka',
	},

	['water'] = {
		label = 'Woda',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Kamizelka Kuloodporna',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Ciuchy',
		consume = 0,
	},
	['papieros'] = {
		label = "Papieros",
		weight = 2,
	},
	['mastercard'] = {
		label = 'Karta bankomatowa',
		stack = false,
		weight = 10,
	},

	['scrapmetal'] = {
		label = 'Kawałek metalu',
		weight = 80,
	},

	["alive_chicken"] = {
		label = "Żywy kurczak",
		weight = 1,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Palnik",
		weight = 2,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Chleb",
		weight = 1,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Joint",
		weight = 3,
		stack = true,
		close = true,
	},
	["hp_gym_pass"] = {
		label = "Karnet na siłownię",
		weight = 3,
		stack = true,
		close = true,
		description = ''
	},

	["carokit"] = {
		label = "Zestaw do karoserii",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Narzędzia",
		weight = 2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Ciuchy",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Miedź",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Ucięte drzewo",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diament",
		weight = 1,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gaz",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Tkanina",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Ryba",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Duży zestaw naprawczy",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Mały Zestaw Naprawczy",
		weight = 2,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Butla z gazem",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Złoto",
		weight = 1,
		stack = true,
		close = true,
	},
	["property_raid_pass"] = {
		label = "Cicha przepustka",
		weight = 1,
		stack = true,
		close = true,
		description = ""
	},
	["iron"] = {
		label = "Żelazo",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marihuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Apteczka",
		weight = 2,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Zapakowany kurczak",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Spakowane drzewo",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Olej",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Przepracowany olej",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Zabity kurczak",
		weight = 1,
		stack = true,
		close = true,
	},
	["washed_stone"] = {
		label = "Umyty kamień",
		weight = 1,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Drewno",
		weight = 1,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wełna",
		weight = 1,
		stack = true,
		close = true,
	},
	['package_dokumenty'] = {
		label = "Przesyłka z dokumentami",
		weight = 10,
		stack = true,
		close = false
	},
	['package_kartony'] = {
		label = "Przesyłka z kartonami",
		weight = 10,
		stack = true,
		close = false,
	},
	['package_opony'] = {
		label = 'Opony samochodowe',
		weight = 10,
		stack = true,
		close = false
	},
	['package_listy'] = {
		label = 'Listy kurierskie',
		weight = 10,
		stack = true,
		close = false
	},
	--Rybak
	['fishing_rod'] = {
		label = 'Wędka',
		weight = 4,
		stack = true,
		close = false
	},
	['fish1'] = {
		label = 'Marlin',
		weight = 4,
		stack = true,
		close = false
	},
	['fish2'] = {
		label = 'Tuńczyk',
		weight = 4,
		stack = true,
		close = false
	},
	['fish3'] = {
		label = 'Wahoo',
		weight = 4,
		stack = true,
		close = false
	},
	['fish4'] = {
		label = 'Żaglica',
		weight = 4,
		stack = true,
		close = false
	},
	['miner_pickaxe'] = {
		label = "Kilof górniczy",
		weight = 1000,
		stack = false,
		close = true,
		description = 'Dosyć solidny kilof. Widzisz na nim świecące się opiłki'
	},
	['miner_brokenpick'] = {
		label = "Połamany kilof",
		weight = 800,
		stack = false,
		close = true,
		description = 'Może uda Ci się go naprawić?'
	},
	['miner_emerald'] = {
		label = "Szmaragd",
		weight = 450,
		stack = true,
		close = false,
		description = 'Niezwykle rzadki i cenny kamień. Uważaj na niego! Jest sporo warty..'
	},
	['miner_gold'] = {
		label = "Złoto",
		weight = 250,
		stack = true,
		close = false,
		description = 'Rzadko spotykany w tych rejonach kruszec, może być nawet trochę warty..'
	},
	['miner_diamond'] = {
		label = "Diament",
		weight = 500,
		stack = true,
		close = false,
		description = 'Kamień o niezwykle wielkiej wadze, wiele warty..'
	},
	['miner_iron'] = {
		label = "Żelazo",
		weight = 250,
		stack = true,
		close = false,
		description = 'Ruda skała wygląda jak ruda żelaza'
	},
	["stone"] = {
		label = "Kamień",
		weight = 350,
		stack = false,
		close = false,
		description = 'Wykopałem ten niezwykły kamień, ale zamienił się w zwykłą skałę. Znajdź kogoś kto by Ci z tym pomógł.'
	},
	['winiarz_winogrono'] = {
		label = 'Świeże winogrono',
		weight = 100,
		stack = true,
		close = false,
	},
	['winiarz_butelkawina'] = {
		label = 'Butelka wina',
		weight = 50,
		stack = true,
		close = false
	},
	['winiarz_winejuice'] = {
        label = "Sok winogronowy",
        weight = 100,
        close = false,
        stack = true,
        description = 'Sok winogronowy gotowy do rozlania w butelki',
        client = {
			status = { thirst = 200000 },
        }
    },
    ['winiarz_wino'] = {
        label = "Wino ze świeżych winogron",
        weight = 150,
        close = false,
        stack = true,
        description = 'Wino wytrawne. 14% objętości alkoholu',
    },
	['telewizor'] = {
		label = 'Telewizor',
		weight = 1000,
		close = false, 
		stack = false,
	},
	['lampa'] = {
		label = "Lampa",
		weight = 1000,
		close = false,
		stack = false,
	},
	['radio_house'] = {
		label = "Radio",
		weight = 900,
		close = false,
		stack = false,
	},
	['laptop'] = {
		label = 'Laptop',
		weight = 4200,
		close = false,
		stack = false
	},
	['gps'] = {
		label = "GPS",
		weight = 500,
		close = true,
		stack = true,
		client = {
			export = "hp_gps.UseGPS",
		},
	},
	['cannabis_seed'] = {
		label  = "Nasiona Marihuany",
		weight = 50,
		close = true,
		stack = true,
		description = "Nasiona marihuany, wystarczy znaleźć tylko miejsce gdzie je zasiać.."
	},
	['coke_seed'] = {
		label  = "Nasiona Koki",
		weight = 50,
		close = true,
		stack = true,
		description = 'Nasiona koki, lubią słońce i brak spalin'
	},
	['water_can'] = {
		label = "Konewka",
		weight = 300,	
		close = true,
		stack = false,
		description = 'Konewka na wodę.',
		metadata = {
			water_level = 0
		},
	},
	['cannabis_seed'] = {
        label  = "Nasiona Marihuany",
        weight = 50,
        close = true,
        stack = true,
        description = "Nasiona marihuany, wystarczy znaleźć tylko miejsce gdzie je zasiać.."
    },
    ['coke_seed'] = {
        label  = "Nasiona Koki",
        weight = 50,
        close = true,
        stack = true,
        description = 'Nasiona koki, lubią słońce i brak spalin'
    },
    ['water_can'] = {
        label = "Konewka",
        weight = 300,	
        close = true,
        stack = false,
        description = 'Konewka na wodę.'
    },
    ['fertilizer_lightsoil'] = {
        label = "Light Soil Mix",
        weight = 500,
        close = false,
        stack = true,
        description = "Nawóz zapewniający szybki rozwój Twoim roślinom",
    },
    ['fertilizer_azot'] = {
        label = "Azot Mix",
        weight = 500,
        close = false,
        stack = true,
		description = "Nawóz bogaty w azotany i inne cenne składniki mineralne dla Twojego ogrodu",
    },
    ['fertilizer_pro'] = {
        label = "Pro Mix",
        weight = 500,
        close = false,
        stack = true,
        description = 'Jedne z ciekawszych rozwiązań na rynku, gwarantuje satysfakcję z zakupu'
	}
}