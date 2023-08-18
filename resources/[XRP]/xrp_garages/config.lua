
Config = {}
Config.Garages = {
	SanAndreasAvenue = {
		points = {
			vec(202.67985534668, -800.2730102539, 31),
			vec(218.37657165528, -755.85321044922, 31),
			vec(263.28967285156, -771.13391113282, 31),
			vec(257.86599731446, -786.64385986328, 31),
			vec(252.78300476074, -784.81774902344, 31),
			vec(241.74099731446, -815.31927490234, 31)
		},
		thickness = 3.5,
		blipcoords = vector3(226.5319, -783.5140, 30.7309),
		Sprite = 357,
		Scale = 0.8,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},
	SanAndreasAvenue2 = {
		points = {
			vec(220.00930786132, -823.49298095704, 30),
			vec(225.09979248046, -828.80145263672, 30),
			vec(221.18856811524, -833.9682006836, 30),
			vec(212.62539672852, -831.36029052734, 30)
		},
		thickness = 3.5,
		blipcoords = vector3(220.2674, -828.6102, 30.5030),
		Sprite = 357,
		Scale = 0.8,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},
	SanAndreasAvenue3 = {
		points = {
			vec(-357.176758, -126.801361, 38),
			vec(-362.082306, -125.226250, 38),
			vec(-363.443939, -129.297592, 38),
			vec(-358.651184, -131.128464, 38)
		},
		thickness = 3.5,
		blipcoords = vector3(-363.443939, -129.297592, 38.695637),
		Sprite = 357,
		Scale = 0.8,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},
}

Config.Impounds = {
	RoyLowenstein = {
		points = {
            vec(205.69737243652, -847.66662597656, 31),
            vec(194.7709197998, -850.779968261722, 31),
            vec(192.14352416992, -843.51885986328, 31)
		},
		thickness = 3.5,
		blipcoords = vector3(185.3353, -826.2784, 31.2159),
		Sprite = 524,
		Scale = 0.8,
		Colour = 1,
		ImpoundedName = "LosSantos",
        Cost = 3000,
	},
    RoyLowenstein2 = {
		points = {
            vec(191.83419799804, -818.49676513672, 31),
            vec(185.46287536622, -833.85711669922, 31),
            vec(177.57641601562, -827.66809082032, 31)
		},
		thickness = 3.5,
		blipcoords = vector3(197.4094, -847.8733, 30.8067),
		Sprite = 524,
		Scale = 0.8,
		Colour = 1,
		ImpoundedName = "LosSantos",
        Cost = 3000,
	},
    RoyLowenstein3 = {
		points = {
            vec(-354.845795, -120.520416, 38),
			vec(-359.555420, -118.938988, 38),
            vec(-356.800995, -110.400497, 38),
			vec(-351.828644, -111.692970, 38)
		},
		thickness = 3.5,
		blipcoords = vector3(-351.828644, -111.692970, 38.696918),
		Sprite = 524,
		Scale = 0.8,
		Colour = 1,
		ImpoundedName = "LosSantos",
        Cost = 3000,
	},
}

Config.ImpoundPrice = 500

exports("getGarages", function()
	return Config.Garages
end)
exports("getImpounds", function()
	return Config.Impounds
end)