ESX = exports["es_extended"]:getSharedObject()

--[[local groupNames = {
    [2685387236] = 'Broń biała',
    [416676503] = "Broń palna",
    [-95776620] = 'Broń palna',
    [860033945] = 'Broń palna',
    [970310034] = 'Broń palna',
    [1159398588] = 'Broń palna',
    [3082541095] = 'Broń palna',
    [2725924767] = 'Broń palna',
    [1548507267] = 'Broń rzucana'
}

AddEventHandler('gameEventTriggered', function(name,args)
    if name=='CEventNetworkEntityDamage' then
        local attacking = true
        local retval, weaponHash = GetCurrentPedWeapon(PlayerPedId())
        local weaponType = groupNames[GetWeapontypeGroup(weaponHash)]
        if weaponType then
            print(weaponType)
        end
    end

end)--]]




