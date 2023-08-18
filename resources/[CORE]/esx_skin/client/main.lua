local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false
local cam, CAMS            = nil, nil
local isCameraActive, isCamsActive = false, false
local zoomOffset     = 0.0
local camOffset      = 0.0
local angle          = 0.0
local heading        = 90.0
local SkinSubmitCb   = nil
local SkinCancelCb   = nil
local elements       = {}
local newOffset      = 0.0
local firstTime      = false

Citizen.CreateThread(function()
	RequestAnimDict("random@mugging3")
	while (not HasAnimDictLoaded("random@mugging3")) do 
		Citizen.Wait(0)
	end
end)

if Config.DisableIdleCam then
  DisableIdleCamera(true)
end

function OpenMenu(submitCb, cancelCb, restrict)
  SkinSubmitCb = submitCb
  SkinCancelCb = cancelCb
  local playerPed = PlayerPedId()

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)
  TriggerEvent('hideHud')
  TriggerEvent('skinchanger:getData', function(components, maxVals)
    elements          = {}
    local _components = {}

    -- Restrict menu
    if restrict == nil then
      for i = 1, #components, 1 do
        _components[i] = components[i]
      end
    else
      for i = 1, #components, 1 do
        local found = false

        for j = 1, #restrict, 1 do
          if components[i].name == restrict[j] then
            found = true
          end
        end

        if found then
          table.insert(_components, components[i])
        end
      end
    end


    -- Insert elements
    for i = 1, #_components, 1 do
      local value       = _components[i].value
      local componentId = _components[i].componentId

      if componentId == 0 then
        value = GetPedPropIndex(playerPed, _components[i].componentId)
      end

      local data = {
        label       = _components[i].label,
        category    = _components[i].category,
        name        = _components[i].name,
        value       = value,
        min         = _components[i].min,
        textureof   = _components[i].textureof,
        zoomOffset  = _components[i].zoomOffset,
        camOffset   = _components[i].camOffset,
        type        = 'slider'
      }

      for k, v in pairs(maxVals) do
        if k == _components[i].name then
          data.max = v
        end
      end

      table.insert(elements, data)
    end

    CreateSkinCam()
    --MoveRotationCamera()
    zoomOffset = _components[1].zoomOffset
    camOffset = _components[1].camOffset

    SendNUIMessage({
      action = 'openMenu',
      elements = elements
    })
    
    SetNuiFocus(true, true)
  end)
end

function CreateSkinCam()
  local pCoords = GetEntityCoords(PlayerPedId())
  if not DoesCamExist(cam) then
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  end
  SetCamActive(cam, true)
  RenderScriptCams(true, true, 500, true, true)
  isCameraActive = true
  isCamsActive = true
  SetCamCoord(cam, pCoords.x+1, pCoords.y-1, pCoords.z)
  CameraActiveThread()
  SetCamRot(cam, 0.0, 0.0, 270.0, true)
  SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
  isCameraActive = false
  isCamsActive = false
  if firstTime then
    firstTime = false
    TriggerEvent('pixa_intro:justSpawned', true)
  end
  SetCamActive(CAMS, false)
  SetCamActive(cam, false)
  DestroyCam(CAMS)
  RenderScriptCams(false, true, 500, true, true)
  cam = nil
  if IsEntityPlayingAnim(PlayerPedId(), "random@mugging3", "handsup_standing_base", 3) then
    ClearPedSecondaryTask(PlayerPedId())
  end
end

RegisterNUICallback("submit", function(data)
  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)
  DeleteSkinCam()
  SetNuiFocus(false, false)
  TriggerEvent('showHud')
  if SkinSubmitCb then
    SkinSubmitCb()
  end
end)


RegisterNUICallback("cancel", function(data)
  TriggerEvent('skinchanger:loadSkin', LastSkin)
  DeleteSkinCam()
  SetNuiFocus(false, false)
  TriggerEvent('showHud')
  if SkinCancelCb then
    SkinCancelCb()
  end
end)

RegisterNUICallback("zoom", function(data)
  local zoom = data.value
  newOffset = zoom + 0.0
end)

RegisterNUICallback("height", function(data)
  local height = data.value
  camOffset = height + 0.0
end)

RegisterNUICallback("rotation", function(data)
  angle = data.value + 0.0
end)


local changeElementsTo0 = {
  ["tshirt_1"] = "tshirt_2",
  ["torso_1"] = "torso_2",
  ["decals_1"] = "decals_2",
  ["arms"] = "arms_2",
  ["pants_1"] = "pants_2",
  ["shoes_1"] = "shoes_2",
  ["mask_1"] = "mask_2",
  ["bproof_1"] = "bproof_2",
  ["chain_1"] = "chain_2",
  ["helmet_1"] = "helmet_2",
  ["glasses_1"] = "glasses_2",
  ["watches_1"] = "watches_2",
  ["bracelets_1"] = "bracelets_2",
  ["bags_1"] = "bags_2",
  ["ears_1"] = "ears_2",
  ["hair_1"] = "hair_2",
}

RegisterNUICallback("change", function(data)
  TriggerEvent('skinchanger:change', data.name, data.value)
  TriggerEvent('skinchanger:getData', function(components, maxVals)
    for i = 1, #elements, 1 do
      if elements[i].name == data.name then
        local newmin = elements[i].min
        local newmax = maxVals[elements[i].name]
        SendNUIMessage({
          action = "updateVals",
          label = elements[i].label,
          name = elements[i].name,
          max = newmax,
          min = newmin,
          value = -1
        })
      elseif changeElementsTo0[data.name] then
        if elements[i].name == changeElementsTo0[data.name] then
          TriggerEvent('skinchanger:change', elements[i].name, 0)
          elements[i].value = 0
          local newmin = elements[i].min
          local newmax = maxVals[elements[i].name]
          SendNUIMessage({
            action = "updateVals",
            label = elements[i].label,
            name = elements[i].name,
            max = newmax,
            min = newmin,
            value = elements[i].value
          })
        end
      end
    end
  end)
end)

local debug = false

RegisterCommand("skindebug", function()
  debug = true
end)

CameraActiveThread = function()
  Citizen.CreateThread(function()
    while isCameraActive do
      DisableControlAction(2, 30, true)
      DisableControlAction(2, 31, true)
      DisableControlAction(2, 32, true)
      DisableControlAction(2, 33, true)
      DisableControlAction(2, 34, true)
      DisableControlAction(2, 35, true)

      DisableControlAction(0, 25, true)     -- Input Aim
      DisableControlAction(0, 24, true)     -- Input Attack

      local playerPed   = GetPlayerPed(-1)
      local coords      = GetEntityCoords(playerPed)

      local angle       = heading * math.pi / 180.0
      local theta       = {
        x = math.cos(angle),
        y = math.sin(angle)
      }
      local pos         = {
        x = coords.x + ((zoomOffset + newOffset) * theta.x),
        y = coords.y + ((zoomOffset + newOffset) * theta.y),
      }

      local angleToLook = heading - 140.0
      if angleToLook > 360 then
        angleToLook = angleToLook - 360
      elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
      end
      angleToLook = angleToLook * math.pi / 180.0
      local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook)
      }

      local posToLook = {
        x = coords.x + (zoomOffset * thetaToLook.x),
        y = coords.y + (zoomOffset * thetaToLook.y),
      }

      SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
      PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

      if debug then
        print(angle, (zoomOffset + newOffset))
      end

      Citizen.Wait(1)
    end
  end)
end

local left = false;
local right = false;
RegisterNUICallback("left", function(data)
  left = data.value
end)
RegisterNUICallback("right", function(data)
  right = data.value
end)
local zoomplus = false
local zoommin = false
RegisterNUICallback("zoommin", function(data)
  zoommin = data.value
end)
RegisterNUICallback("zoomplus", function(data)
  zoomplus = data.value
end)
local heightplus = false
local heightmin = false;
RegisterNUICallback("heightmin", function(data)
  heightmin = data.value
end)
RegisterNUICallback("heightplus", function(data)
  heightplus = data.value
end)

RegisterNUICallback("heightchange", function(data)
  newOffset = newOffset + data.value
  if newOffset < 0.00 then
    newOffset = 0.00
  elseif newOffset > 1.3 then
    newOffset = 1.3
  end
end)

RegisterNUICallback("handsup", function(data)
  local playerped = PlayerPedId()
  if IsEntityPlayingAnim(playerped, "random@mugging3", "handsup_standing_base", 3) then
    ClearPedSecondaryTask(playerped)
  else
    TaskPlayAnim(playerped, "random@mugging3", "handsup_standing_base", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
  end
end)



local notified = false
local notifyID = 'SKINCHANGER_CAMERA_NOTIFY'
Citizen.CreateThread(function()
  while true do
    local time = 1000
    if isCameraActive then
      time = 1
      if firstTime then
        local players   = ESX.Game.GetPlayers()
        local playerPed = PlayerPedId()
        for i = 1, #players, 1 do
          local target = GetPlayerPed(players[i])
          if target ~= playerPed then
            SetEntityLocallyInvisible(target)
          end
        end
      end
      if angle ~= nil then
        if left then
          angle = angle - 1
        elseif right then
          angle = angle + 1
        end
        if zoomplus then
          if newOffset > 0.00 then
            newOffset = newOffset - 0.01
          end
        elseif zoommin then
          if newOffset < 1.3 then
            newOffset = newOffset + 0.01
          end
        end
        if heightplus then
          if camOffset < 0.75 then
            camOffset = camOffset + 0.01
          end
        elseif heightmin then
          if camOffset > -0.75 then
            camOffset = camOffset - 0.01
          end
        end

        if angle > 360 then
          angle = angle - 360
        elseif angle < 0 then
          angle = angle + 360
        end
        heading = angle + 0.0
      end
    end
    Citizen.Wait(time)
  end
end)

function inCreator()
  return isCameraActive
end

exports('inCreator', inCreator)

function OpenSaveableMenu(submitCb, cancelCb, restrict)
  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)
  OpenMenu(function()
    DeleteSkinCam()

    TriggerEvent('skinchanger:getSkin', function(skin)
      TriggerServerEvent('esx_skin:save', skin)
      SetPedMaxHealth(PlayerPedId(), 200)
      SetEntityMaxHealth(PlayerPedId(), 200)
      if submitCb ~= nil then
        submitCb()
      end
    end)
  end, cancelCb, restrict)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
end)


RegisterNetEvent('esx_skin:setSkin')
AddEventHandler('esx_skin:setSkin', function()
  PlayerLoaded = true
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
    if skin == nil then

    else
      TriggerEvent('skinchanger:loadSkin', skin)
    end
  end)
end)



AddEventHandler('esx_skin:getLastSkin', function(cb)
  cb(LastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
  LastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
  OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
  OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
  Wait(200)
  OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
  OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu2')
AddEventHandler('esx_skin:openSaveableRestrictedMenu2', function(submitCb, cancelCb, restrict)
  local restrict = {
    'sex',
    'face',
    'head',
    'head_2',
    'skin',
    'age_1',
    'age_2',
    'eye_color',
    'blemishes_1',
    'blemishes_2',
    'ageing_1',
    'ageing_2',
    'blush_1',
    'blush_2',
    'blush_3',
    'nose_width',
    'nose_peak_height',
    'nose_peak_length',
    'nose_bone_high',
    'nose_peak_lowering',
    'nose_bone_twist',
    'eyebrown_high',
    'eyebrown_forward',
    'cheeks_1',
    'cheeks_2',
    'cheeks_3',
    'eyes_opening',
    'lips_thickness',
    'jaw_1',
    'jaw_2',
    'chin_bone_lowering',
    'chin_bone_length',
    'chin_bone_width',
    'chin_hole',
    'complexion_1',
    'complexion_2',
    'sun_1',
    'sun_2',
    'moles_1',
    'moles_2',
    'beard_1',
    'beard_2',
    'beard_3',
    'beard_4',
    'hair_1',
    'hair_2',
    'hair_color_1',
    'hair_color_2',
    'eyebrows_2',
    'eyebrows_1',
    'eyebrows_3',
    'eyebrows_4',
    'makeup_1',
    'makeup_2',
    'makeup_3',
    'makeup_4',
    'lipstick_1',
    'lipstick_2',
    'lipstick_3',
    'lipstick_4',
    'chest_1',
    'chest_2',
    'chest_3',
    'bodyb_1',
    'bodyb_2',
    'tshirt_1',
    'tshirt_2',
    'torso_1',
    'torso_2',
    'arms',
    'arms_2',
    'chain_1',
    'chain_2',
    'decals_1',
    'decals_2',
    'pants_1',
    'pants_2',
    'shoes_1',
    'shoes_2',
    'bags_1',
    'bags_2',
    'bproof_1',
    'bproof_2'
  }
  firstTime = true
  OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
  TriggerEvent('skinchanger:getSkin', function(skin)
    TriggerServerEvent('esx_skin:responseSaveSkin', skin)
  end)
end)

RegisterNetEvent('esx_skin:changeModel')
AddEventHandler('esx_skin:changeModel', function(model)
  local ped = model
  local hash = GetHashKey('k9pies')
  RequestModel(hash)
  while not HasModelLoaded(hash)
  do
    RequestModel(hash)
    Citizen.Wait(0)
  end
  SetPlayerModel(PlayerId(), hash)
  SetPedDefaultComponentVariation(PlayerPedId())
end)

RegisterNetEvent('esx_skin:changeModel2')
AddEventHandler('esx_skin:changeModel2', function(model)
  local ped = model
  local hash = GetHashKey(ped)
  RequestModel(hash)
  while not HasModelLoaded(hash)
  do
    RequestModel(hash)
    Citizen.Wait(0)
  end
  SetPlayerModel(PlayerId(), hash)
  Citizen.Wait(100)
  SetPedDefaultComponentVariation(PlayerPedId())
  GiveWeaponToPed(PlayerPedId(), GetHashKey('WEAPON_KNIFE'), 0, false, false)
  GiveWeaponToPed(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), 0, false, false)
end)


RegisterNetEvent('esx_skin:changeNPC')
AddEventHandler('esx_skin:changeNPC', function(model)
  while not HasModelLoaded(model) do
    RequestModel(model)
    Citizen.Wait(0)
  end
  Citizen.Wait(100)
  SetPlayerModel(PlayerId(), model)
  Citizen.Wait(100)
  TriggerEvent('skinchanger:getSkin', function(skin)
    TriggerServerEvent('esx_skin:save', skin)
  end)
end)