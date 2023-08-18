Config                            = {}

Config.DrawDistance               = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType                 = {Cloakrooms = 20, Armories = 21, BossActions = 22, Vehicles = 36, Helicopters = 34}
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 50, g = 50, b = 204}

Config.EnablePlayerManagement     = true -- Enable if you want society managing.
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true -- Enable if you're using esx_identity.
Config.EnableESXOptionalneeds     = false -- Enable if you're using esx_optionalneeds
Config.EnableLicenses             = false -- Enable if you're using esx_license.

Config.EnableHandcuffTimer        = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer              = 10 * 60000 -- 10 minutes.

Config.EnableJobBlip              = false -- Enable blips for cops on duty, requires esx_society.
Config.EnableCustomPeds           = false -- Enable custom peds in cloak room? See Config.CustomPeds below to customize peds.

Config.MaxInService               = -1 -- How many people can be in service at once? Set as -1 to have no limit

Config.Locale = GetConvar('esx:locale', 'en')

Config.OxInventory                = ESX.GetConfig().OxInventory

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 29
		},

		Cloakrooms = {
			{
				location = vector3(452.59,-993.27,30.69),
				size = vector3(2,2,2),
			},
		},

		Armories = {
			{
				location = vector3(458.5,-979.08,30.69),
				size = vector3(1,1,1),
				data = {
						{
							label = "Zbrojownia frakcyjna",
							name = "fractionarmory",
							groups = "police",
							canInteract = function()
								return true
							end,
							onSelect = function()
								OpenArmoryShop("fraction")
							end
						},
						{
							label = "Zbrojownia SWAT",
							name = "swatarmory",
							groups = "police",
							onSelect = function()
								if CheckLicense("swat") then
									OpenArmoryShop("swat")
								else
									ESX.ShowNotification("Nie posiadasz licencji")
								end
							end
						},
						{
							label = "Zbrojownia Command",
							name = "commandarmory",
							groups = "police",
							canInteract = function()
								if ESX.PlayerData.job.grade >= 4 then
									return true
								end
							end,
							onSelect = function()
								OpenArmoryShop("command")
							end
						},
						{
							label = "Utylizowanie broni",
							name = "utilize",
							groups = "police",
							canInteract = function()
								return true
							end,
							onSelect = function()
								OpenDump()
							end
						},
					}
			}
		},

		Stashes = {
			{
				evidence = true,
				target = { 
					name = 'mrpd_evidence',
					loc = vector3(459.55,-983.08,30.69),
					length = 2.2,
					width = 2.2,
					height = 2.1,
					heading = 0,
				}
			},
			{
				evidence = false,
				target = { 
					name = 'mrpd_fraction',
					loc = vec3(456.49,-983.15,30.69),
					length = 2.2,
					width = 2.2,
					height = 2.1,
					heading = 0,
				}
			},
		},

		Vehicles = {
			{
				coords = vector3(454.6, -1017.4, 28.4),
				size = vector3(2,2,2),
				SpawnPoints = {
					{coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0},
					{coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0},
					{coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0},
					{coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0}
				}
			},
		},

		Garages = {
			{
				coords = vector3(437.45,-1019.68,28.77),
				size = vector3(8,8,2),
			},
		},

		Impounds = {
			{
				coords = vector3(472.03,-1078.2,29.35),
				size = vector3(2,2,3),
			},
		},

		BossActions = {
			{
				coords = vector3(447.95,-973.39,30.69),
				size = vector3(1,1,1),
				grade = 4,
			}
		}

	}

}

Config.AuthorizedLicenses = { -- PAMIETAJ, Ze nazwa licencji musi znajdowac sie w bazie danych aby dzialala!
	["command"] = "Licencja Command",
	["swat"] = "Licencja SWAT",
}

Config.AuthorizedWeapons = {
	["fraction"] = {
		{name = 'WEAPON_APPISTOL', price = 10000},
		{name = 'WEAPON_NIGHTSTICK', price = 0},
		{name = 'WEAPON_STUNGUN', price = 1500},
		{name = 'WEAPON_FLASHLIGHT', price = 80, license = 'weapon'}
	},
	["swat"] = {
		{name = 'WEAPON_APPISTOL', components = {0, 0, 1000, 4000, nil}, price = 10000, license = "swat"},
		{name = 'WEAPON_ADVANCEDRIFLE', components = {0, 6000, 1000, 4000, 8000, nil}, price = 50000, license = "swat"},
		{name = 'WEAPON_PUMPSHOTGUN', components = {2000, 6000, nil}, price = 70000, license = "swat"},
		{name = 'WEAPON_NIGHTSTICK', price = 0, license = "swat"},
		{name = 'WEAPON_STUNGUN', price = 500, license = "swat"},
		{name = 'WEAPON_FLASHLIGHT', price = 0, license = "swat"}
	},
	["command"] = {
		{name = 'WEAPON_APPISTOL', components = {0, 0, 1000, 4000, nil}, price = 10000},
		{name = 'WEAPON_ADVANCEDRIFLE', components = {0, 6000, 1000, 4000, 8000, nil}, price = 50000},
		{name = 'WEAPON_PUMPSHOTGUN', components = {2000, 6000, nil}, price = 70000},
		{name = 'WEAPON_NIGHTSTICK', price = 0},
		{name = 'WEAPON_STUNGUN', price = 500},
		{name = 'WEAPON_FLASHLIGHT', price = 0}
	}
}

--Config.AuthorizedVehicles
Config.Vehicles = {
	--[[car = {
		recruit = {},

		officer = {
			{model = 'police3', price = 20000}
		},

		sergeant = {
			{model = 'policet', price = 18500},
			{model = 'policeb', price = 30500}
		},

		lieutenant = {
			{model = 'riot', price = 70000},
			{model = 'fbi2', price = 60000}
		},

		boss = {}
	},

	helicopter = {
		recruit = {},

		officer = {},

		sergeant = {},

		lieutenant = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		boss = {
			{model = 'polmav', props = {modLivery = 0}, price = 100000}
		}
	}--]]
	VehicleLimit = 5,

	Categories = {
		["PD"] = {
			license = nil,
			grade = nil,
		},
		["SWAT"] = {
			license = "swat",
			grade = nil,
		},
	},

	AuthorizedVehicles = {
		[`police`] = {
			label = "Pojazd policyjny",
			grade = 1,
			price = 1000,
			DefaultCategory = "PD",
		},
		[`police3`] = {
			label = "Pojazd policyjny 2",
			grade = 2,
			price = 2000,
			DefaultCategory = "PD",
		},
		[`zentorno`] = {
			label = "zentorno",
			grade = nil,
			price = 3000,
			DefaultCategory = "SWAT",
		},
		[`sanchez`] = {
			label = "sanchez",
			grade = 2,
			price = 4000,
			DefaultCategory = "SWAT",
		},
	},

	--[[
	CarLimit = 5,
	AuthorizedVehicles = {
		["PD"] = {
			license = nil,
			Vehicles = {
				[`police`] = {
					label = "police",
					grade = 1,
					price = 1000,
				},
				["police3"] = {
					label = "police3",
					grade = 2,
					price = 2000,
				}
			}
		},
		["SWAT"] = {
			license = "swat",
			Vehicles = {
				[`zentorno`] = {
					label = "zentorno",
					grade = nil,
					price = 3000,
				},
				[`sanchez`] = {
					label = "sanchez",
					grade = 2,
					price = 4000,
				}
			}
		},
	}
	]]

}

Config.CustomPeds = {
	shared = {
		{label = TranslateCap('s_m_y_sheriff_01'), maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'},
		{label = TranslateCap('s_m_y_cop_01'), maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},

	recruit = {},

	officer = {},

	sergeant = {},

	lieutenant = {},

	boss = {
		{label = TranslateCap('s_m_y_swat_01'), maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'}
	}
}


Config.FractionSubcategories = {

-- ["NAZWA_KATEGORII"] = {
--	 	["NAZWA_STROJU"] = {
--	 		license = "NAZWA LICENCJI LUB nil",
--	 		grade = 0,
--	 		armour = 0,
--	 
--	 		male = { -- DLA CHLOPA
--	 			tshirt_1 = 59,  tshirt_2 = 1,
--	 			torso_1 = 55,   torso_2 = 0,
--	 			decals_1 = 0,   decals_2 = 0,
--	 			arms = 41,
--	 			pants_1 = 25,   pants_2 = 0,
--	 			shoes_1 = 25,   shoes_2 = 0,
--	 			helmet_1 = 46,  helmet_2 = 0,
--	 			chain_1 = 0,    chain_2 = 0,
--	 			ears_1 = 2,     ears_2 = 0
--	 		},
--	 		female = { -- DLA BABY
--	 			tshirt_1 = 36,  tshirt_2 = 1,
--	 			torso_1 = 48,   torso_2 = 0,
--	 			decals_1 = 0,   decals_2 = 0,
--	 			arms = 44,
--	 			pants_1 = 34,   pants_2 = 0,
--	 			shoes_1 = 27,   shoes_2 = 0,
--	 			helmet_1 = 45,  helmet_2 = 0,
--	 			chain_1 = 0,    chain_2 = 0,
--	 			ears_1 = 2,     ears_2 = 0
--	 		}
--	 	}
-- },

	["SWAT"] = {
		["klapek"] = {
			license = nil,
			grade = 1,
			male = {
				tshirt_1 = 59,  tshirt_2 = 1,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = 46,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 36,  tshirt_2 = 1,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = 45,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		}
	},
	["PD"] = {
		["klapek"] = {
			license = nil,
			grade = 1,
			male = {
				tshirt_1 = 59,  tshirt_2 = 1,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = 46,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 36,  tshirt_2 = 1,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = 45,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
		["klapek2"] = {
			license = nil,
			grade = 3,
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
		["kamza1"] = {
			grade = 0,
			armour = 50,
			male = {
				tshirt_1 = 59,  tshirt_2 = 1
			},
			female = {
				tshirt_1 = 36,  tshirt_2 = 1
			}
		}
	},
	["TEST"] = {
		["klapek"] = {
			license = nil,
			grade = 1,
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
		["klapek2"] = {
			license = nil,
			grade = 3,
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
	},
}

Config.UniformCategories = {
	{
		label = "Ubranie cywilne",
		value = "civil",
	},
	{
		label = "Ubrania frakcyjne",
		value = "fraction",
		subcategories = Config.FractionSubcategories,
	},
	{
		label = "Stroje prywatne",
		value = "private",
	},
}