Config = {}

Config.AuthorizedFractions = { -- TODO
    ["police"] = {
        AllowedFrequencies = {
            1,
            2,
        },
    },
    ["ambulance"] = {
        AllowedFrequencies = {
            1,
        },
    },
}

--[[Config.RegisteredFrequencies = {
    [1] = {
        label = "LSPD Main",
        MaxSize = nil,
        --TODO
    },
    [2] = {
        label = "Taktyczny #1",
        MaxSize = 5,
        --TODO
    },
    --TODO
}]]

Config.RestrictedChannels = {
    { -- Channel 1
        police = true,
        ambulance = true,
        data = {
            mainjob = "police",
            display = true,
            label = "LSPD Main",
        }
    },
    { -- Channel 2
        police = true,
        ambulance = true,
        data = {
            mainjob = "police",
            display = true,
            label = "Taktyczny #1",
        }
    },
    { -- Channel 3
        ambulance = true,
        police = true,
        data = {
            mainjob = "ambulance",
            display = true,
            label = "Taktyczny #2",
        }
    },
    { -- Channel 4
        police = true,
        ambulance = true,
        data = {
            mainjob = "fbi",
            display = true,
            label = "Taktyczny #3",
        }
    },
    { -- Channel 5
        police = true,
        ambulance = true
    },
    { -- Channel 6
        police = true,
        ambulance = true
    },
    { -- Channel 7
        police = true,
        ambulance = true
    },
    { -- Channel 8
        police = true,
        ambulance = true
    },
    { -- Channel 9
        police = true,
        ambulance = true
    },
    { -- Channel 10
        police = true,
        ambulance = true
    }
}

Config.RestrictedJobs = {
    {
        value = "police",
        label = "POLICJA",
        allowedJobs = {
            ["police"] = true,
            ["ambulance"] = true,
        }
    },
    {
        value = "ambulance",
        label = "POGOTOWIE",
        allowedJobs = {
            ["police"] = true,
            ["ambulance"] = true,
        }
    },
    {
        value = "fbi",
        label = "FBI",
        allowedJobs = {
            ["ambulance"] = true,
        }
    },
}

Config.MaxFrequency = 500