ESX = exports["es_extended"]:getSharedObject()
local xSound = exports.xsound
local ox_inventory = exports.ox_inventory


-- Basicowy radial
lib.addRadialItem({ 
    {
            label = 'Twoja Postać',
            id = 'PlayerInfo',
            icon = 'fa-user',
            onSelect = function()
                TriggerEvent('hp_panel:openPanel')
            end
        }, 
        {
            label = 'Radio',
            id = 'Radio',
            icon = 'radio',
            onSelect = function()
                if ox_inventory:Search('count', 'radio') > 0 then
                    print("EXPORT DO OTWARCIA TELEFONU")
                else
                    ESX.ShowNotification("Nie posiadasz radia!", "error", 1000)
                end
            end
        },
        {
            label = 'Telefon',
            id = 'Phone',
            icon = 'phone',
            onSelect = function()
                if ox_inventory:Search('count', 'phone') > 0 then
                    print("EXPORT DO OTWARCIA TELEFONU")
                else
                    ESX.ShowNotification("Nie posiadasz telefonu!", "error", 1000)
                end
            end
        },
        {
            label = 'Pokaż dowód',
            id = 'PlayerIDcard',
            icon = 'id-card',
            onSelect = function()
                print("EXPORT DO POKAZANIA DOWODU")
            end
        }
    })


local lastjob = nil

AddJobRadial = function(job)
    if lastjob then lib.removeRadialItem('jobs') end
    lastjob = false
    if Config.jobs[job.name] == nil then return end
    lastjob = true

    lib.registerRadial({
        id = job.name,
        items = Config.jobs[job.name].items
    })

    lib.addRadialItem({
        id = 'jobs',
        label = 'Praca',
        icon = 'briefcase',
        menu = job.name;
    })
end

RegisterNetEvent('esx:setJob', function(job)
    AddJobRadial(job)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer)
    AddJobRadial(xPlayer.job)
end)

--[[ ODBINDOWANIE DEFAULTOWEGO OX LIBA
CreateThread(function()
    local oldkeybind = lib.addKeybind({
        name = 'ox_lib-radial',
        description = 'WYLACZONE',
    })
    oldkeybind:disable(true)
end)
]]
RegisterCommand("HideRadial", function()
    if lib.isRadialOpen() then
        Wait(160)
        SetPauseMenuActive(false)
        lib.hideRadial()
    end
end)

CreateThread(function()
    RegisterKeyMapping("HideRadial", "Przycisk do chowania radial menu", "keyboard", "ESCAPE")
end)