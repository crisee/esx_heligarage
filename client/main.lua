local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["F11"] = 58,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil

local ACTION_REMOVE_POLICEHELI = 'rem'
local ACTION_GET_POLICEHELI = 'get'
local ACTION_REMOVE_AMBULANCEHELI = 'rem_second'
local ACTION_GET_AMBULANCEHELI = 'get_second'

local policeChopper = nil
local ambulanceChopper = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


AddEventHandler('esx_heligarage:hasEnteredMarker', function(zone)

  if PlayerData.job.name ~= nil then
   if PlayerData.job.name == 'police' then

	if zone == 'PoliceGet' then
		CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to get a ~o~helicopter'
		CurrentAction = ACTION_GET_POLICEHELI
	end

	if zone == 'PoliceRem' then
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to remove ~o~helicopter'
		CurrentAction = ACTION_REMOVE_POLICEHELI
	end
  end
 end

 	if PlayerData.job.name ~= nil then
   if PlayerData.job.name == 'ambulance' then

	if zone == 'AmbulanceGet' then
		CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to get a ~o~helicopter'
		CurrentAction = ACTION_GET_AMBULANCEHELI
	end

	if zone == 'AmbulanceRem' then
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to remove ~o~helicopter'
		CurrentAction = ACTION_REMOVE_AMBULANCEHELI
	end
  end
 end

end)

AddEventHandler('esx_heligarage:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_heligarage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_heligarage:hasExitedMarker', LastZone)
		end
	end
end)


--Actions
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if IsControlPressed(0, Keys['E']) then

		if CurrentAction == ACTION_GET_POLICEHELI then
			ESX.ShowNotification('~o~Helicopter~w~ is on their way..')
			Citizen.Wait(6000)

             ESX.Game.SpawnVehicle('polmav', {
                x = 449.377,
                y = -981.242,
                z = 43.691
                }, 89.58, function(vehicle)
                policeChopper = vehicle
                 SetVehicleModKit(vehicle, 0)
                   SetVehicleLivery(vehicle, 0)
              end)

			CurrentAction = nil
		end

		if CurrentAction == ACTION_REMOVE_POLICEHELI then
			ESX.ShowNotification('Removing the ~o~Helicopter')
			Citizen.Wait(4500)

			if policeChopper ~= nil then
				DeleteEntity(policeChopper)
			end

			CurrentAction = nil
		end


		if CurrentAction == ACTION_GET_AMBULANCEHELI then
			ESX.ShowNotification('~o~Helicopter~w~ is on their way..')
			Citizen.Wait(6000)

             ESX.Game.SpawnVehicle('supervolito', {
                x = 313.198,
                y = -1465.156,
                z = 45.609
                }, 140.60, function(vehicle)
                ambulanceChopper = vehicle
                 SetVehicleModKit(vehicle, 0)
                   SetVehicleLivery(vehicle, 0)
              end)

			CurrentAction = nil
		end

		if CurrentAction == ACTION_REMOVE_AMBULANCEHELI then
			ESX.ShowNotification('Removing the ~o~Helicopter')
			Citizen.Wait(4500)

			if ambulanceChopper ~= nil then
				DeleteEntity(ambulanceChopper)
			end

			CurrentAction = nil
		end

	end


	end
end)

--Display alerts
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		end
	end
end)
