RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent('heaven_misc:setMeta')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.TriggerServerCallback('hp_stats:returnMetadataDuty', function(onDuty)
    	local newJob = job
        if newJob.name == 'offpolice' or newJob.name == 'offmechanic' or newJob.name == 'offambulance' then
            if onDuty then
                TriggerServerEvent('hp_stats:stopPoliceDutySession', false)
            end
        end
    end)

end)

local ox_duty_zones = {
    MissionRow = {
        coords = vector3(440.88, -981.12, 30.36),
        heading = 359.33,
        label = "Odbij się do pracy",
        name = 'dutyZoneMr',
        propRange = 1.5,
        debug = true,
        restrict = {'police', 'offpolice'}
    },

}

for k,v in pairs(ox_duty_zones) do
    local dutyZones = exports.ox_target:addBoxZone({
        coords = v.coords,
        size = vec3(2, 2, 2),
        rotation = v.rotation,
        debug = v.debug,
        options = {
            {
                name = v.name,
                icon = 'fa-regular fa-id-badge',
                label = v.label,
                groups = v.restrict,
                canInteract = function(entity, distance, coords, name)
                    return not onDuty and distance < 5
                end,
                onSelect = function()
                    TriggerServerEvent('hp_stats:startDuty', true)
                    onDuty = true
                end
            },
            {
                name = 'offDutyZoneMr',
                icon = 'fa-regular fa-id-badge',
                label = "Odbij się z pracy",
                groups = v.restrict,
                canInteract = function(entity, distance, coords, name)
                    return onDuty and distance < 5

                end,
                onSelect = function()
                    TriggerServerEvent('hp_stats:stopPoliceDutySession', false)
                    onDuty = false
                end
            }
        }
    })
end
RegisterNetEvent('heaven-misc:makeScreenshot', function(webhook)
    exports['screenshot-basic']:requestScreenshotUpload(webhook, "files[]", function(data)
        local image = json.decode(data)
        image = {}
        TriggerServerEvent('heaven-misc:makeScreenshotData')
    end)
end)