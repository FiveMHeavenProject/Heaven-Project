local IsDead = false
local IsAnimated = false
AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false	
end)

AddEventHandler('esx_status:loaded', function(status)
	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return Config.Visible
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return Config.Visible
	end, function(status)
		status.remove(75)
	end)
end)

AddEventHandler('esx_status:onTick', function(data)
	local prevHealth = GetEntityHealth(PlayerPedId())
	local health     = prevHealth
	local level = 0
	for k, v in pairs(data) do
		if v.name == 'hunger' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		elseif v.name == 'thirst' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		end
	end
	if health ~= prevHealth then SetEntityHealth(PlayerPedId(), health) end
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onUse')
AddEventHandler('esx_basicneeds:onUse', function(type, prop_name)
	if not IsAnimated then
		local anim = {dict = 'mp_player_inteat@burger', name = 'mp_player_int_eat_burger_fp', settings = {8.0, -8, -1, 49, 0, 0, 0, 0}}
		IsAnimated = true
		if type == 'food' then
			prop_name = prop_name or 'prop_cs_burger_01'
			anim = {dict = 'mp_player_inteat@burger', name = 'mp_player_int_eat_burger_fp', settings = {8.0, -8, -1, 49, 0, 0, 0, 0}}
		elseif type == 'drink' then
			prop_name = prop_name or 'prop_ld_flow_bottle'
			anim = {dict = 'mp_player_intdrink', name = 'loop_bottle', settings = {1.0, -1.0, 2000, 0, 1, true, true, true}}
		end

		CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(PlayerPedId(), 18905)
			AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict(anim.dict, function()
				TaskPlayAnim(PlayerPedId(), anim.dict, anim.name, anim.settings[1], anim.settings[2], anim.settings[3], anim.settings[4], anim.settings[5], anim.settings[6], anim.settings[7], anim.settings[8])
				RemoveAnimDict(anim.dict)

				Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(PlayerPedId())
				DeleteObject(prop)
			end)
		end)
	end
end)

-- Backwards compatibility
RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
    local Invoke = GetInvokingResource()

    print(('[^3WARNING^7] ^5%s^7 used ^5esx_basicneeds:onEat^7, this method is deprecated and should not be used! Refer to ^5https://documentation.esx-framework.org/addons/esx_basicneeds/events/oneat^7 for more info!'):format(Invoke))

    if not prop_name then
        prop_name = 'prop_cs_burger_01'
    end
    TriggerEvent('esx_basicneeds:onUse', 'food', prop_name)
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
    local Invoke = GetInvokingResource()

    print(('[^3WARNING^7] ^5%s^7 used ^5esx_basicneeds:onDrink^7, this method is deprecated and should not be used! Refer to ^5https://documentation.esx-framework.org/addons/esx_basicneeds/events/ondrink^7 for more info!'):format(Invoke))


    if not prop_name then
        prop_name = 'prop_ld_flow_bottle'
    end
    TriggerEvent('esx_basicneeds:onUse', 'drink', prop_name)
end)
