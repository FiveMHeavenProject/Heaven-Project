-- Public Funtions (Don't modify anything if you don't know what you are doing!)
ESX = exports["es_extended"]:getSharedObject()
function ksOnMultiCharacterStart()
    exports.spawnmanager:setAutoSpawn(false)
    ksFirstShowESX = true
    ksStartMultiCharacter_ESX()
    -- You can hide your hud from here.
end

function ksOnMultiCharacterEnd()
    TriggerEvent('showHud')
    -- You can show your hud from here.
end

RegisterNetEvent('ks-multicharacter:start-qbcore', function()
    ksStartMultiCharacter_QBcore()
end)

RegisterNetEvent('ks-multicharacter:start-esx', function()
    ksStartMultiCharacter_ESX()
end)

-- This function load the skin of your character when you select it in the multicharacter menu.
function ksLoadCharacterSkin(ksBackData)
        DeleteEntity(ksSelectedCharP)
		SendNUIMessage({type = "ksHideCreate"});
		local ksData = ksBackData.ksDataC
		if ksData ~= nil then
			local ksPedType = "mp_f_freemode_01"
			local ksSkin = ksConfig.EsxDefaultSkins["f"]
			ksSkin.sex = 1
			if ksData.sex == nil then 
				ksPedType = "mp_m_freemode_01"
				if ksPedType == "mp_m_freemode_01" then 
					ksSkin = ksConfig.EsxDefaultSkins["m"]
					ksSkin.sex = 0
				end
			else
				if ksData.sex == "m" then 
					ksPedType = "mp_m_freemode_01"
					ksSkin = ksConfig.EsxDefaultSkins["m"]
					ksSkin.sex = 0
				end  
			end
			ksModel = GetHashKey(ksPedType)
			if ksModel ~= nil then
				CreateThread(function()
					exports.spawnmanager:spawnPlayer({x = ksConfig.ksHiddenCoords.x,y = ksConfig.ksHiddenCoords.y,z = ksConfig.ksHiddenCoords.z,heading = ksConfig.ksHiddenCoords.w,model = ped,skipFade = true
					}, function()
						if ksData.skin then 
							ksLoadModel(ksModel)
							SetPlayerModel(PlayerId(), ksModel)
							SetModelAsNoLongerNeeded(ksModel)
							TriggerEvent('skinchanger:loadSkin', ksData.skin)
						else
							TriggerEvent('skinchanger:loadSkin', ksSkin)
						end
					end)
					Wait(500)		
					ksApplyToPed(PlayerPedId())
					ksPlayerIsDancing = true
				end)
			end
		end
    -- end
end

-- This function is called after a new character is created. (Client)
function ksCharacterCreated() 
    
end

-- This function is for displaying clothing menu. (QBcore only)
function ksCharacterCreatorMenu()

end


-- This event is called when player loaded. (ESX only)
if (ksConfig.Framework=='ESX') then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(ksPlayerData, ksIsCharacterNew, ksSkin)
            local ksSpawn = ksPlayerData.coords
            TriggerServerEvent('ks-character:insideBucket')
            if ksIsCharacterNew or not ksSkin or #ksSkin == 1 then
                local ksDone = false
                local ksPD = ksPlayerData.sex or "m"
                ksSkin = ksConfig.EsxDefaultSkins[ksPD]
                ksSkin.sex = ksPD == "m" and 0 or 1 
                if ksSkin.sex == 0 then ksModel = ksConfig.ksDefaultModels[1] else ksModel = ksConfig.ksDefaultModels[2] end
                ksLoadModel(ksModel)
                SetPlayerModel(PlayerId(), ksModel)
                SetModelAsNoLongerNeeded(ksModel)
                TriggerEvent('skinchanger:loadSkin', ksSkin, function()
                    ksDone = true
                    
                end)
                repeat Wait(200) until ksDone
            end
            DoScreenFadeOut(100)
            SetEntityCoordsNoOffset(PlayerPedId(), ksSpawn.x, ksSpawn.y, ksSpawn.z, false, false, false, true)
            SetEntityHeading(PlayerPedId(), ksSpawn.heading)
            if not ksIsCharacterNew then TriggerEvent('skinchanger:loadSkin', ksSkin) end
            Wait(400)
            DoScreenFadeIn(400)
            repeat Wait(200) until not IsScreenFadedOut()
            TriggerServerEvent('esx:onPlayerSpawn')
            TriggerEvent('esx:onPlayerSpawn')
            TriggerEvent('playerSpawned')
            TriggerEvent('esx:restoreLoadout')
            TriggerServerEvent('hp_stats:startSessionTime')
            if not ksIsCharacterNew then
                TriggerServerEvent('ks-character:outsideBucket')
            end
            ksDisableValues()
    end)
end

