-- Public Funtions (Don't modify anything if you don't know what you are doing!)
ksConfig.DiscordBotToken = "MTEyOTI5Mjk3NzUyOTk1ODQwMA.Gkj3Xt.SmMd2aWgdv9lxDRjR_8zilyp8o4YZzPIQqG0uM"
ESX = exports["es_extended"]:getSharedObject()

-- This function is called after you play with a character.
function ksOpenSpawnMenu(ksSrc, ksData)
    --TriggerClientEvent('showHud', ksSrc)

    SetPlayerRoutingBucket(ksSrc, 0)
end
RegisterNetEvent('ks-character:outsideBucket', function()
    SetPlayerRoutingBucket(source, 0)
    --TriggerClientEvent('showHud', source)
end)
RegisterNetEvent('ks-character:insideBucket', function()
    SetPlayerRoutingBucket(source, source)
    --TriggerClientEvent('hideHud', source)
end)

function ksShowLogs(ksSrc, ksData)

end

-- This function is called after a new character is created. (Server)
function ksCharacterCreated(ksSrc)
    SetPlayerRoutingBucket(ksSrc, 0)
    TriggerClientEvent('esx_skin:openSaveableMenu', ksSrc)
end


-- Logout Function - Enable/Disable from ksConfig file.
--[[if (ksConfig.Framework=='ESX') then
    if (ksConfig.EnableLogoutCmd) then
		RegisterCommand('relog', function(source)
			TriggerClientEvent('ks-multicharacter:start-esx', source)
            TriggerClientEvent('esx_skin:resetFirstSpawn', source)
		end)
    end
end--]]

