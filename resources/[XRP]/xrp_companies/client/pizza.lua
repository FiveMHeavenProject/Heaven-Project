ESX = exports['es_extended']:getSharedObject()
food = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, v in pairs(Config.companies.food) do 
            food[v.name] = {
                name = v.name,
                job = v.job,
                blipCoords = v.blipCoords,
                dutyCoords = v.dutyCoords,
                cloakroomCoords = v.cloakroomCoords,
                fridgeCoords = v.fridgeCoords,
                craftingCoords = v.craftingCoords,
                craftableItems = v.craftableItems,
            }

            pizzaBlip = AddBlipForCoord(food[v.name].blipCoords)
            SetBlipSprite(pizzaBlip, 108)
            SetBlipDisplay(pizzaBlip, 4)
            SetBlipScale(pizzaBlip, 1.0)
            SetBlipColour(pizzaBlip, 4)
            SetBlipAsShortRange(pizzaBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('~~r~~[Biznes] ~~w~~'..food[v.name].name)
            EndTextCommandSetBlipName(pizzaBlip)

            Citizen.CreateThread(function()
                exports["xrp_multijob"]:SetDutyPointer("duty"..food[v.name].name, "Służba w: "..food[v.name].name, food[v.name].job, food[v.name].dutyCoords, vector3(2,2,2))
                exports['xrp_markers']:RegisterMarker(6, food[v.name].cloakroomCoords, 15, 1.5, true, 'Przebieralnia | ~INPUT_CONTEXT~', function()
                    if IsControlJustPressed(0, 38) then
                        if ESX.PlayerData.job.name == food[v.name].job then
                            ESX.ShowNotification("Przebrałeś się!!!")
                        end
                    end
                end)
                exports['xrp_markers']:RegisterMarker(6, food[v.name].fridgeCoords, 15, 1.5, true, 'Lodówka | ~INPUT_CONTEXT~', function()
                    if IsControlJustPressed(0, 38) then
                        if ESX.PlayerData.job.name == food[v.name].job then
                            ESX.ShowNotification("Zajrzałeś do lodówki!!!")
                        end
                    end
                end)
                exports['xrp_markers']:RegisterMarker(6, food[v.name].craftingCoords, 15, 1.5, true, 'Miejsce tworzenia | ~INPUT_CONTEXT~', function()
                    if IsControlJustPressed(0, 38) then
                        if ESX.PlayerData.job.name == food[v.name].job then
                            ESX.ShowNotification("Otworzyłeś crafting!!!")
                        end
                    end
                end)
            end)

            -- exports.ox_target:addBoxZone({
            --     coords = food[v.name].cloakroomCoords,
            --     size = vec3(2, 2, 2),
            --     rotation = 45,
            --     debug = true,
            --     options = {
            --         {
            --             name = 'Przebieralnia' ..food[v.name].name,
            --             icon = 'fa-solid fa-cube',
            --             label = 'Przebieralnia ('..food[v.name].name..')',     
            --             canInteract = function(entity, distance, coords, name, bone)
            --                 if ESX.PlayerData.job.name == food[v.name].job then
            --                     print(food[v.name].job)
            --                     return true                                
            --                 end
            --             end,
            --             onSelect = function(data)
            --                 ESX.ShowNotification("Przebrałeś się!!!")
            --             end
            --         }
            --     }
            -- })
            -- exports.ox_target:addBoxZone({
            --     coords = food[v.name].fridgeCoords,
            --     size = vec3(2, 2, 2),
            --     rotation = 45,
            --     debug = true,
            --     options = {
            --         {
            --             name = 'lodówka' ..food[v.name].name,
            --             icon = 'fa-solid fa-cube',
            --             label = 'Lodówka ('..food[v.name].name..')',     
            --             canInteract = function(entity, distance, coords, name, bone)
            --                 if ESX.PlayerData.job.name == food[v.name].job then
            --                     return true                                
            --                 end
            --             end,
            --             onSelect = function(data)
            --                 ESX.ShowNotification("Zajrzałeś do lodówki")
            --             end
            --         }
            --     }
            -- })
            -- exports.ox_target:addBoxZone({
            --     coords = food[v.name].craftingCoords,
            --     size = vec3(2, 2, 2),
            --     rotation = 45,
            --     debug = true,
            --     options = {
            --         {
            --             name = 'crafting' ..food[v.name].name,
            --             icon = 'fa-solid fa-cube',
            --             label = 'Crafting ('..food[v.name].name..')',     
            --             canInteract = function(entity, distance, coords, name, bone)
            --                 if ESX.PlayerData.job.name == food[v.name].job then
            --                     return true                                
            --                 end
            --             end,
            --             onSelect = function(data)
            --                 ESX.ShowNotification("Otworzyłeś swój poręczny crafting table")
            --             end
            --         }
            --     }
            -- })



        end
    end
    -- print(json.encode(food))
end)