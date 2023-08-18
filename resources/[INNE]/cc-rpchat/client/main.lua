local ccChat = exports['cc-chat']
local nbrDisplaying = 1

function DrawText3D(x,y,z, text, r, g, b)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z + 1.0)
  local px,py,pz=table.unpack(GetGameplayCamCoords())

  SetTextColour(255,255,255, 250)

  text2 = " "..text.." "

    SetTextScale(0.40, 0.40)
    local factor = (string.len(text2)) / 270
    DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, r, g, b, 155)

  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextOutline()
  AddTextComponentString(text2)
  DrawText(_x,_y)
end

local function Draw3dTextOnPlayer(id, msg, r,g,b) 
  local TargetPed = GetPlayerPed(id)
  local PlayerPed = PlayerPedId()
  local x = nbrDisplaying

  local displaying = true
	CreateThread(function()
		Wait(6000)
		displaying = false
	end)
  CreateThread(function()
		nbrDisplaying = nbrDisplaying + 1
		-- print(nbrDisplaying)
		while displaying do
			Wait(0)
      local coordsMe = GetEntityCoords(TargetPed, false)
			local coords = GetEntityCoords(PlayerPed, false)
			local dist = #(coordsMe - coords)
			if dist < 20 then
				DrawText3D(coordsMe.x, coordsMe.y, coordsMe.z + (x*0.14), msg, r, g, b)
			end
    end
		nbrDisplaying = nbrDisplaying - 1
  end)

end

function hex2rgb(hex)
  hex = hex:gsub("#","")
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end


RegisterNetEvent('cc-rpchat:addMessage')
AddEventHandler('cc-rpchat:addMessage', function(color, icon, subtitle, msg, showTime)
    if showTime ~= false then
        timestamp = ccChat:getTimestamp()
    else
        timestamp = ''
    end
    TriggerEvent('chat:addMessage', { templateId = 'ccChat', multiline = false, args = { color, icon, subtitle, timestamp, msg } })
end)

RegisterNetEvent('cc-rpchat:addProximityMessage')
AddEventHandler('cc-rpchat:addProximityMessage', function(color, icon, subtitle, msg, id, pCords, display, chatdisplay)
  timestamp = ccChat:getTimestamp()
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    if not chatdisplay then
      TriggerEvent('chat:addMessage', { templateId = 'ccChat', multiline = false, args = { color, icon, subtitle, timestamp, msg } })
    end
    if display then
      Draw3dTextOnPlayer(GetPlayerFromServerId(id), msg, hex2rgb(color))
    end
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), pCords, true) < 19.999 then
    if not chatdisplay then
      TriggerEvent('chat:addMessage', { templateId = 'ccChat', multiline = false, args = { color, icon, subtitle, timestamp, msg } })
    end
    if display then
      Draw3dTextOnPlayer(GetPlayerFromServerId(id), msg, hex2rgb(color))
    end
  end
end)

