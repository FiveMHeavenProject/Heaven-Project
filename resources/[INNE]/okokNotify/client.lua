function Alert(title,message,time,type)
	if not type then
		type = "info"
	end
	if not time then
		time = 2000
	end
	if not title then
		title = 'HeavenProject'
	end
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent('okokNotify:Alert')
AddEventHandler('okokNotify:Alert', function(title,message, time,type)
	Alert(title,message,time,type)
end)
