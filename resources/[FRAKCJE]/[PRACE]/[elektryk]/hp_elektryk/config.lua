Config = Config or {}

Config.Payment = 500
Config.VehCaution = 500
Config.JobLocations = {coords = vector3(528.56, -1602.86, 28.29), heading = 52.3}
Config.VehicleModel = "cog55"
Config.VehicleCoords = vector3(525.27, -1600.91, 29.2)
Config.VehicleHeading = 50.34
Config.Unfiroms = {
    male = {
        ['pants'] = {item = 24, texture = 0}, -- Pants
        ['arms'] = {item = 19, texture = 0}, -- Arms
        ['t-shirt'] = {item = 58, texture = 0}, -- T Shirt
        ['vest'] = {item = 0, texture = 0}, -- Body Vest
        ['torso2'] = {item = 55, texture = 0}, -- Jacket
        ['shoes'] = {item = 51, texture = 0}, -- Shoes
        ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
        ['bag'] = {item = 0, texture = 0}, -- Bag
        ['hat'] = {item = -1, texture = -1}, -- Hat
        ['glass'] = {item = 0, texture = 0}, -- Glasses
        ['mask'] = {item = 0, texture = 0} -- Mask
    },
   female = {    
        ['pants'] = {item = 24, texture = 0}, -- Pants
        ['arms'] = {item = 19, texture = 0}, -- Arms
        ['t-shirt'] = {item = 58, texture = 0}, -- T Shirt
        ['vest'] = {item = 0, texture = 0}, -- Body Vest
        ['torso2'] = {item = 55, texture = 0}, -- Jacket
        ['shoes'] = {item = 51, texture = 0}, -- Shoes
        ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
        ['bag'] = {item = 0, texture = 0}, -- Bag
        ['hat'] = {item = -1, texture = -1}, -- Hat
        ['glass'] = {item = 0, texture = 0}, -- Glasses
        ['mask'] = {item = 0, texture = 0} -- Mask     
    },
}

Config.Projects = {
    [1] = {
        ProjectLocations = {
            ["main"] = {
                label = "# [NAP] VIW-0 Wieża Telefonii Komórkowej",
                coords = vector3(765.94, 1273.79, 360.3),
                Id = 1,
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(739.39, 1275.95, 360.3),
                    label = "Sprawdź napięcie na fazach",
                    icon = "fa-solid fa-hand-dots",
                    requiredItemAmount = 1,
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(790.6, 1269.98, 360.3),
                    label = "Wymień przekaźniki",
                    icon = 'fa-solid fa-paperclip',
                    action = 'replaceSwitches',
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(760.85, 1280.45, 360.3),
                    label = "Zaktualizuj sterownik rozdzielni",
                    icon = 'fa-solid fa-screwdriver',
                    action = 'pcupdate',
                    completed = false,
                    IsBusy = false,
                },
                [4] = {
                    coords = vector3(765.94, 1274.24, 360.3),
                    label = "Przełącz bezpieczniki do bezpiecznej pozycji",
                    icon = 'fa-solid fa-bomb',
                    action = 'fuses',
                    completed = false,
                    IsBusy = false,
                },
	        },
        },
    },
    [2] = {
        ProjectLocations = {
            ["main"] = {
                label = "# [NAP] RSC-P Mała komórka na obszarach wiejskich",
                coords = vector3(-1001.97, 4853.76, 274.61),
                Id = 2,
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(-1001.17, 4847.91, 275.01),
                    label = "Sprawdź napięcie na fazach",
                    icon = "fa-solid fa-hand-dots",
                    action = 'checkVoltage',
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(-999.49, 4852.57, 274.61),
                    label = "Wymień przekaźniki",
                    icon = 'fa-solid fa-paperclip',
                    action = 'replaceSwitches',
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(-1001.84, 4853.69, 274.61),
                    label = "Zaktualizuj sterownik rozdzielni",
                    icon = 'fa-solid fa-screwdriver',
                    action = 'pcupdate',
                    completed = false,
                    IsBusy = false,
                },
                [4] = {
                    coords = vector3(-1003.03, 4856.6, 274.61),
                    label = "Przełącz bezpieczniki do bezpiecznej pozycji",
                    icon = 'fa-solid fa-bomb',
                    action = 'fuses',
                    completed = false,
                    IsBusy = false,
                },
	        },
        },
    },
    [3] = {
        ProjectLocations = {
            ["main"] = {
                label = "[NAP] SAND-I Stacja Nadawcza",
                coords = vector3(1872.09, 3711.83, 33.08),
                Id = 3,
            },
            ["tasks"] = {
                [1] = {
                    coords = vector3(1871.56, 3713.23, 33.06),
                    label = "Sprawdź napięcie na fazach",
                    icon = "fa-solid fa-hand-dots",
                    action = 'checkVoltage',
                    completed = false,
                    IsBusy = false,
                },
                [2] = {
                    coords = vector3(1865.45, 3716.49, 33.07),
                    label = "Wymień przekaźniki",
                    icon = 'fa-solid fa-paperclip',
                    action = 'replaceSwitches',
                    completed = false,
                    IsBusy = false,
                },
                [3] = {
                    coords = vector3(1874.8, 3713.15, 33.1),
                    label = "Zaktualizuj sterownik rozdzielni",
                    icon = 'fa-solid fa-screwdriver',
                    action = 'pcupdate',
                    completed = false,
                    IsBusy = false,
                },
                [4] = {
                    coords = vector3(1871.9, 3718.83, 33.09),
                    label = "Przełącz bezpieczniki do bezpiecznej pozycji",
                    icon = 'fa-solid fa-bomb',
                    action = 'fuses',
                    completed = false,
                    IsBusy = false,
                },
	        },
        },
    },
}
