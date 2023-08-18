Config = {}

Config.jobs = {
    ["police"] = {
        items = {
            {
                label = 'Zakuj',
                id = 'Handcuff',
                icon = 'handcuffs',
                onSelect = function()
                    print("EXPORT ...")
                end
            },
            {
                label = 'Otworz tablet',
                id = 'Tablet',
                icon = 'fa-tablet',
                onSelect = function()
                    print("EXPORT ...")
                end
            },
            {
                label = 'Ukaż odznakę',
                id = 'Badge',
                icon = 'id-badge',
                onSelect = function()
                    exports.hp_badges:BadgeMenu()
                end
            },
            {
                label = 'Postaw Obiekt',
                id = 'placeobjects',
                icon = 'fa-box',
                menu = 'placeobject',
            },
            {
                label = 'Radio',
                id = 'fractionradioo',
                icon = 'fa-radio',
                menu = 'fractionradio',
            },
        }
    },
    ["ambulance"] = {
        items = {
            {
                label = 'Radio',
                id = 'fractionradioo',
                icon = 'fa-radio',
                menu = 'fractionradio',
            },
        }
    },
    ["mechanic"] ={
        items = {
            {
                label = "Otwórz menu mechanika",
                id = "mechanic:menu",
                icon = "fa-tablet",
                onSelect = function()
                    exports.esx_mechanicjob:OpenMobileMechanicActionsMenu()
                end
            },
            {
                label = "Rozpocznij pracę dorywczą",
                id = "mechanic:menu:towingJob",
                icon = "fa-tablet",
                onSelect = function()
                    exports.esx_mechanicjob:startTowingJob()
                end
            },
            {
                label = "Zarejestruj lawetę",
                id = "mechanic:menu:registerTow",
                icon = "fa-tablet",
                onSelect = function()
                    exports.esx_mechanicjob:getTowId()
                end
            },

        }
    },
    ["house_flipper"] = {
        items = {
            {
                label = "Stwórz dom",
                icon = 'fa-solid fa-door-open',
                id = 'house:flipper:createhouse',
                onSelect = function()
                    exports.resesetti_houses:OpenCreatorMenu()
                end
            },
            {
                label = "Zarządzaj domem",
                icon = 'fa-solid fa-bars-progress',
                id = 'house:flipper:manageHouse',
                onSelect = function()
                    exports.resesetti_houses:OpenManageHouseMenu()
                end
            }
        }
    }
}