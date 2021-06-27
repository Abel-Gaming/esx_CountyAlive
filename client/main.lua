ESX              = nil

--Camping
local tentSet = false
local tent = nil
local tentLocked = false
local fireStarted = false
local fire = nil
local fireLocked = false
local grillSet = false
local grill = nil
local grillLocked = false
local chairSet = false
local chair = nil
local chairLocked = false
local editMode = false

local tentDetails = {}
local fireDetails = {}
local grillDetails = {}
local chairDetails = {}

--Fishing
local isFishing = false

--Hiking
local isHiking = false

---------- END OF VARIABLES ----------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

-- Net Events Used Everywhere
RegisterNetEvent('esx_CountyAlive:ShowGlobalAlert')
AddEventHandler('esx_CountyAlive:ShowGlobalAlert', function(text)
	if Config.AlertsUseNotification then
		ESX.ShowNotification(text)
	end
	if Config.AlertsUseHelpMessage then
		ESX.ShowHelpNotification(text)
	end
end)

-- Hospital --
if Config.EnableHospitalBlip then
	Citizen.CreateThread(function()
		local HospitalBlip = AddBlipForCoord(Config.HospitalHealCoords.x, Config.HospitalHealCoords.y, Config.HospitalHealCoords.z)
		SetBlipSprite (HospitalBlip, Config.HospitalBlipSprite)
		SetBlipDisplay(HospitalBlip, 4)
		SetBlipScale(HospitalBlip, Config.HospitalBlipScale)
		SetBlipColour(HospitalBlip, Config.HospitalBlipColour)
		SetBlipAsShortRange(HospitalBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Hospital')
		EndTextCommandSetBlipName(HospitalBlip)
	end)
end

if Config.EnablePlayerHealing then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end
	
		while true do
			Citizen.Wait(1)
			while #(GetEntityCoords(PlayerPedId()) - Config.HospitalHealCoords) <= 1.0 do
				Citizen.Wait(0)
				if Config.DrawHealingGroundMarker then
					DrawMarker(Config.MarkerType, Config.HospitalHealCoords.x, Config.HospitalHealCoords.y, Config.HospitalHealCoords.z - 0.98, 
					0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.xScale, Config.yScale, Config.zScale, Config.MarkerRed, Config.MarkerGreen, Config.MarkerBlue, Config.MarkerAlpha, false, true, 2, Config.MarkerRotate, nil, nil, false)
				end
				ESX.Game.Utils.DrawText3D(Config.HospitalHealCoords, "Press ~g~[E]~s~ to heal", 0.6)
				if IsControlJustReleased(0, 51) then
					ESX.TriggerServerCallback('esx_CountyAlive:CheckPlayerBalance', function(enoughMoney)
						if enoughMoney then
							local playerPed = PlayerPedId()
							local maxHealth = GetEntityMaxHealth(playerPed)
							SetEntityHealth(playerPed, maxHealth)
							ESX.ShowNotification('~g~You have been healed!')
						else
							ESX.ShowNotification('~r~[ERROR]~w~ You do not have enough money!')
						end
					end, Config.HospitalHealPrice)
				end
			end
		end
	end)
end

-- Food Vendors --
if Config.EnableFoodVendors then
	for k,v in pairs(Config.FoodVendors) do
		if v.vendorBlip then
			Citizen.CreateThread(function()
				local blip = AddBlipForCoord(v.purchaseCoord.x, v.purchaseCoord.y, v.purchaseCoord.z)
				SetBlipSprite(blip, v.vendorBlipSprite)
				SetBlipColour(blip, v.vendorBlipColour)
				SetBlipDisplay(blip, 4)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.name)
				EndTextCommandSetBlipName(blip)
			end)
		end
	end
end

if Config.EnableFoodVendors then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end
	
		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.FoodVendors) do
				local markerlocation = vector3(v.purchaseCoord.x, v.purchaseCoord.y, v.purchaseCoord.z)
				while #(GetEntityCoords(PlayerPedId()) - markerlocation) <= 1.0 do
					Citizen.Wait(0)
					ESX.Game.Utils.DrawText3D(markerlocation, "Press ~y~[E]~s~ to purchase items", 0.6)
					if IsControlJustReleased(0, 51) then
						OpenFoodMenu(v.items)
						while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "general_menu") do
							Wait(50)
						end
					end
				end
			end
		end
	end)
end

function OpenFoodMenu(items)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Food Vendor",
		align = "center",
		elements = items
	}, function(data, menu)		
		local item, price, name = data.current.item, data.current.price, data.current.label
		TriggerServerEvent('esx_CountyAlive:PurchaseItem', item, price)
	end,
	function(data, menu)
		menu.close()
	end)
end

-- Camping --
if Config.EnableCamping and Config.UseCommands then
	RegisterCommand(Config.PitchTentCommand, function()
		if tentSet then
			DeleteEntity(tent)
			ESX.ShowNotification('~r~Tent removed!')
			tentSet = false
		else
			local playerCoords = GetEntityCoords(PlayerPedId())
			tent = CreateObject(Config.TentModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 2, true, false, false)
			ESX.ShowNotification('~g~Tent placed!')
			tentSet = true
		end
	end)
end

if Config.EnableCamping and Config.UseCommands then
	RegisterCommand(Config.StartCampfireCommand, function()
		if fireStarted then
			DeleteEntity(fire)
			ESX.ShowNotification('~r~Fire removed!')
			fireStarted = false
		else
			local playerCoords = GetEntityCoords(PlayerPedId())
			fire = CreateObject(Config.CampFireModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 1.5, true, false, false)
			ESX.ShowNotification('~g~Fire placed!')
			fireStarted = true
		end
	end)
end

if Config.EnableCamping and Config.UseCommands then
	RegisterCommand(Config.PlaceGrillCommand, function()
		if grillSet then
			DeleteEntity(grill)
			ESX.ShowNotification('~r~Grill removed!')
			grillSet = false
		else
			local playerCoords = GetEntityCoords(PlayerPedId())
			grill = CreateObject(Config.GrillModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 1.0, true, false, false)
			ESX.ShowNotification('~g~Grill placed!')
			grillSet = true
		end
	end)
end

if Config.EnableCamping then
	if not Config.UseCommands then
		RegisterCommand(Config.CampingMenuCommand, function()
			OpenCampingMenu()
		end)
	end
end

local campingmenuoptions = {
	{label = "Toggle Edit Mode", value = 'toggle_edit'},
	{label = "Toggle Tent", value = 'toggle_tent'},
	{label = "Toggle Campfire", value = 'toggle_fire'},
	{label = "Toggle Chair", value = 'toggle_chair'},
	{label = "Toggle Grill", value = 'toggle_grill'}
}

function OpenCampingMenu()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Camping",
		align = "left",
		elements = campingmenuoptions
	}, function(data, menu)		
		
		if data.current.value == 'toggle_tent' then
			SetTent()
		elseif data.current.value == 'toggle_fire' then
			SetFire()
		elseif data.current.value == 'toggle_grill' then
			SetGrill()
		elseif data.current.value == 'toggle_chair' then
			SetChair()
		elseif data.current.value == 'toggle_edit' then
			if editMode then
				ESX.ShowNotification('~r~Edit mode disabled')
				editMode = false
				menu.close()
			else
				ESX.ShowNotification('~g~Edit mode enabled')
				editMode = true
				menu.close()
			end
		end

	end,
	function(data, menu)
		menu.close()
	end)
end

function SetTent()
	if tentSet then
		DeleteEntity(tent)
		ESX.ShowNotification('~r~Tent removed!')
		tentLocked = false
		tentSet = false
	else
		local playerCoords = GetEntityCoords(PlayerPedId())
		tent = CreateObject(Config.TentModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 2, true, false, false)
		ESX.ShowNotification('~g~Tent placed!')
		tentSet = true
	end
end

function SetFire()
	if fireStarted then
		DeleteEntity(fire)
		ESX.ShowNotification('~r~Fire removed!')
		fireStarted = false
		fireLocked = false
	else
		local playerCoords = GetEntityCoords(PlayerPedId())
		fire = CreateObject(Config.CampFireModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 1.5, true, false, false)
		ESX.ShowNotification('~g~Fire placed!')
		fireStarted = true
	end
end

function SetGrill()
	if grillSet then
		DeleteEntity(grill)
		ESX.ShowNotification('~r~Grill removed!')
		grillSet = false
		grillLocked = false
	else
		local playerCoords = GetEntityCoords(PlayerPedId())
		grill = CreateObject(Config.GrillModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 1.0, true, false, false)
		FreezeEntityPosition(grill, true)
		ESX.ShowNotification('~g~Grill placed!')
		grillSet = true
	end
end

function SetChair()
	if chairSet then
		DeleteEntity(chair)
		ESX.ShowNotification('~r~Chair removed!')
		chairSet = false
		chairLocked = false
	else
		local playerCoords = GetEntityCoords(PlayerPedId())
		chair = CreateObject(Config.ChairModelHash, playerCoords.x + 1.25, playerCoords.y, playerCoords.z - 1.0, true, false, false)
		FreezeEntityPosition(chair, true)
		ESX.ShowNotification('~g~Chair placed!')
		chairSet = true
	end
end

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(500)
	end
	
	while true do
		Citizen.Wait(1)
		if tentSet then
			local playerPed = PlayerPedId()
			while #(GetEntityCoords(tent) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and not tentLocked do
				Citizen.Wait(0)
				local hoistCoords = GetEntityCoords(tent)
				ESX.ShowHelpNotification('~INPUT_VEH_FLY_PITCH_UD~ : Move Up & Down ~n~~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ : Move ~n~~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ : Rotate ~n~~INPUT_CELLPHONE_EXTRA_OPTION~ : Lock Object', true)
				if IsControlPressed(0, 111) then
					SetEntityCoords(tent, GetOffsetFromEntityInWorldCoords(tent, 0.0, 0.0, 0.01))
				end
				if IsControlPressed(0, 110) then
					SetEntityCoords(tent, GetOffsetFromEntityInWorldCoords(tent, 0.0, 0.0, -0.01))
				end
				if IsControlPressed(0, 172) then
					SetEntityCoords(tent, GetOffsetFromEntityInWorldCoords(tent, 0.0, 0.01, 0.0))
				end
				if IsControlPressed(0, 173) then
					SetEntityCoords(tent, GetOffsetFromEntityInWorldCoords(tent, 0.0, -0.01, 0.0))
				end
				if IsControlPressed(0, 174) then
					SetEntityCoords(tent, GetOffsetFromEntityInWorldCoords(tent, -0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 175) then
					SetEntityCoords(tent, GetOffsetFromEntityInWorldCoords(tent, 0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 117) then
					SetEntityHeading(tent, GetEntityHeading(tent) + 0.5)
				end
				if IsControlPressed(0, 118) then
					SetEntityHeading(tent, GetEntityHeading(tent) - 0.5)
				end
				if IsControlJustReleased(0, 179) then
					tentLocked = true
				end
			end

			while #(GetEntityCoords(tent) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and tentLocked do
				Citizen.Wait(0)
				local hoistCoords = GetEntityCoords(tent)
				ESX.ShowHelpNotification('~INPUT_CELLPHONE_EXTRA_OPTION~ : Unlock Object', true)
				if IsControlJustReleased(0, 179) then
					tentLocked = false
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(500)
	end
	
	while true do
		Citizen.Wait(1)
		if fireStarted then
			local playerPed = PlayerPedId()
			while #(GetEntityCoords(fire) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and not fireLocked do
				Citizen.Wait(0)
				local hoistCoords = GetEntityCoords(fire)
				ESX.ShowHelpNotification('~INPUT_VEH_FLY_PITCH_UD~ : Move Up & Down ~n~~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ : Move ~n~~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ : Rotate ~n~~INPUT_CELLPHONE_EXTRA_OPTION~ : Lock Object', true)
				if IsControlPressed(0, 111) then
					SetEntityCoords(fire, GetOffsetFromEntityInWorldCoords(fire, 0.0, 0.0, 0.01))
				end
				if IsControlPressed(0, 110) then
					SetEntityCoords(fire, GetOffsetFromEntityInWorldCoords(fire, 0.0, 0.0, -0.01))
				end
				if IsControlPressed(0, 172) then
					SetEntityCoords(fire, GetOffsetFromEntityInWorldCoords(fire, 0.0, 0.01, 0.0))
				end
				if IsControlPressed(0, 173) then
					SetEntityCoords(fire, GetOffsetFromEntityInWorldCoords(fire, 0.0, -0.01, 0.0))
				end
				if IsControlPressed(0, 174) then
					SetEntityCoords(fire, GetOffsetFromEntityInWorldCoords(fire, -0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 175) then
					SetEntityCoords(fire, GetOffsetFromEntityInWorldCoords(fire, 0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 117) then
					SetEntityHeading(fire, GetEntityHeading(fire) + 0.5)
				end
				if IsControlPressed(0, 118) then
					SetEntityHeading(fire, GetEntityHeading(fire) - 0.5)
				end
				if IsControlJustReleased(0, 179) then
					fireLocked = true
				end
			end

			while #(GetEntityCoords(fire) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and fireLocked do
				Citizen.Wait(0)
				ESX.ShowHelpNotification('~INPUT_CELLPHONE_EXTRA_OPTION~ : Unlock Object', true)
				if IsControlJustReleased(0, 179) then
					fireLocked = false
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(500)
	end
	
	while true do
		Citizen.Wait(1)
		if grillSet then
			local playerPed = PlayerPedId()
			while #(GetEntityCoords(grill) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and not grillLocked do
				Citizen.Wait(0)
				local hoistCoords = GetEntityCoords(grill)
				ESX.ShowHelpNotification('~INPUT_VEH_FLY_PITCH_UD~ : Move Up & Down ~n~~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ : Move ~n~~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ : Rotate ~n~~INPUT_CELLPHONE_EXTRA_OPTION~ : Lock Object', true)
				if IsControlPressed(0, 111) then
					SetEntityCoords(grill, GetOffsetFromEntityInWorldCoords(grill, 0.0, 0.0, 0.01))
				end
				if IsControlPressed(0, 110) then
					SetEntityCoords(grill, GetOffsetFromEntityInWorldCoords(grill, 0.0, 0.0, -0.01))
				end
				if IsControlPressed(0, 172) then
					SetEntityCoords(grill, GetOffsetFromEntityInWorldCoords(grill, 0.0, 0.01, 0.0))
				end
				if IsControlPressed(0, 173) then
					SetEntityCoords(grill, GetOffsetFromEntityInWorldCoords(grill, 0.0, -0.01, 0.0))
				end
				if IsControlPressed(0, 174) then
					SetEntityCoords(grill, GetOffsetFromEntityInWorldCoords(grill, -0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 175) then
					SetEntityCoords(grill, GetOffsetFromEntityInWorldCoords(grill, 0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 117) then
					SetEntityHeading(grill, GetEntityHeading(grill) + 0.5)
				end
				if IsControlPressed(0, 118) then
					SetEntityHeading(grill, GetEntityHeading(grill) - 0.5)
				end
				if IsControlJustReleased(0, 179) then
					grillLocked = true
				end
			end

			while #(GetEntityCoords(grill) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and grillLocked do
				Citizen.Wait(0)
				ESX.ShowHelpNotification('~INPUT_CELLPHONE_EXTRA_OPTION~ : Unlock Object', true)
				if IsControlJustReleased(0, 179) then
					grillLocked = false
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(500)
	end
	
	while true do
		Citizen.Wait(1)
		if chairSet then
			local playerPed = PlayerPedId()
			while #(GetEntityCoords(chair) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and not chairLocked do
				Citizen.Wait(0)
				local hoistCoords = GetEntityCoords(chair)
				ESX.ShowHelpNotification('~INPUT_VEH_FLY_PITCH_UD~ : Move Up & Down ~n~~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ : Move ~n~~INPUT_VEH_FLY_SELECT_TARGET_LEFT~ ~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ : Rotate ~n~~INPUT_CELLPHONE_EXTRA_OPTION~ : Lock Object', true)
				if IsControlPressed(0, 111) then
					SetEntityCoords(chair, GetOffsetFromEntityInWorldCoords(chair, 0.0, 0.0, 0.01))
				end
				if IsControlPressed(0, 110) then
					SetEntityCoords(chair, GetOffsetFromEntityInWorldCoords(chair, 0.0, 0.0, -0.01))
				end
				if IsControlPressed(0, 172) then
					SetEntityCoords(chair, GetOffsetFromEntityInWorldCoords(chair, 0.0, 0.01, 0.0))
				end
				if IsControlPressed(0, 173) then
					SetEntityCoords(chair, GetOffsetFromEntityInWorldCoords(chair, 0.0, -0.01, 0.0))
				end
				if IsControlPressed(0, 174) then
					SetEntityCoords(chair, GetOffsetFromEntityInWorldCoords(chair, -0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 175) then
					SetEntityCoords(chair, GetOffsetFromEntityInWorldCoords(chair, 0.01, 0.0, 0.0))
				end
				if IsControlPressed(0, 117) then
					SetEntityHeading(chair, GetEntityHeading(chair) + 0.5)
				end
				if IsControlPressed(0, 118) then
					SetEntityHeading(chair, GetEntityHeading(chair) - 0.5)
				end
				if IsControlJustReleased(0, 179) then
					chairLocked = true
				end
			end

			while #(GetEntityCoords(chair) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and chairLocked do
				Citizen.Wait(0)
				ESX.ShowHelpNotification('~INPUT_CELLPHONE_EXTRA_OPTION~ : Unlock Object', true)
				if IsControlJustReleased(0, 179) then
					chairLocked = false
				end
			end
		end
	end
end)

-- Fishing --
if Config.EnableFishing and Config.EnableFishingBlips then
	for k,v in pairs(Config.FishingLocations) do
		Citizen.CreateThread(function()
				local blip = AddBlipForCoord(v)
				SetBlipSprite(blip, Config.FishingBlipSprite)
				SetBlipColour(blip, Config.FishingBlipColour)
				SetBlipScale(blip, Config.FishingBlipScale)
				SetBlipDisplay(blip, 4)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Fishing")
				EndTextCommandSetBlipName(blip)
		end)
	end
end

if Config.EnableFishing then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end
	
		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.FishingLocations) do
				local markerlocation = v
				while #(GetEntityCoords(PlayerPedId()) - markerlocation) <= 1.0 do		
					if isFishing then
						Citizen.Wait(0)
						ESX.Game.Utils.DrawText3D(markerlocation, "Press ~y~[E]~s~ to stop fishing", 0.6)
						if IsControlJustReleased(0, 51) then
							ClearPedTasks(GetPlayerPed(-1))
							isFishing = false
						end
					else
						Citizen.Wait(0)
						ESX.Game.Utils.DrawText3D(markerlocation, "Press ~y~[E]~s~ to start fishing", 0.6)
						if IsControlJustReleased(0, 51) then
							TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
							isFishing = true
						end
					end
				end
			end
		end
	end)
end

if Config.EnableFishing and Config.EnableFishingCommand then
	RegisterCommand(Config.FishingCommand, function()
		if isFishing then
			ClearPedTasks(GetPlayerPed(-1))
			isFishing = false
		else
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
			isFishing = true
		end
	end)
end

if Config.EnableFishing and Config.EnableFishingInventory then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if isFishing then
				Citizen.Wait(Config.FishingCatchCooldown * 1000)
				TriggerServerEvent('esx_CountyAlive:AddInventoryItem', Config.FishItem)
			end
		end
	end)
end

-- Offroad Vehicle Rental --
if Config.EnableVehicleRental and Config.EnableVehicleRentalBlip then
	Citizen.CreateThread(function()
		local blip = AddBlipForCoord(Config.RentalPurchaseCoord)
		SetBlipSprite(blip, Config.EnableVehicleRentalBlipSprite)
		SetBlipColour(blip, Config.EnableVehicleRentalBlipColour)
		SetBlipScale(blip, Config.EnableVehicleRentalBlipScale)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Offroad Vehicle Rental")
		EndTextCommandSetBlipName(blip)
	end)
end

if Config.EnableVehicleRental then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end
	
		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.RentalVehicles) do
				local markerlocation = Config.RentalPurchaseCoord
				while #(GetEntityCoords(PlayerPedId()) - markerlocation) <= 1.0 do
					Citizen.Wait(0)
					ESX.Game.Utils.DrawText3D(markerlocation, "Press ~o~[E]~s~ to rent vehicle", 0.6)
					if IsControlJustReleased(0, 51) then
						OpenVehicleMenu(Config.RentalVehicles)
						while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "general_menu") do
							Wait(50)
						end
					end
				end
			end
		end
	end)
end

if Config.EnableVehicleRental then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			DrawMarker(1, Config.RentalVehicleReturnCoord.x, Config.RentalVehicleReturnCoord.y, Config.RentalVehicleReturnCoord.z - 0.98, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, Config.zScale, Config.MarkerRed, Config.MarkerGreen, Config.MarkerBlue, Config.MarkerAlpha, 
			false, true, 2, false, nil, nil, false)
		end
	end)
end

if Config.EnableVehicleRental then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end
	
		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(PlayerPedId())
			while #(GetEntityCoords(PlayerPedId()) - Config.RentalVehicleReturnCoord) <= 3.0 do
				Citizen.Wait(0)
				ESX.ShowHelpNotification('Press ~b~E~w~ to return the vehicle', true)
				if IsPedInAnyVehicle(PlayerPedId(), false) and IsControlJustReleased(0, 51) then
					local playerPed = PlayerPedId()
					local vehicle = GetVehiclePedIsIn(playerPed, false)
					ESX.Game.DeleteVehicle(vehicle)
					ESX.ShowNotification('Vehicle returned!')
				end
			end
		end
	end)
end

RegisterNetEvent('esx_CountyAlive:RentVehicleReturn')
AddEventHandler('esx_CountyAlive:RentVehicleReturn', function(vehicleName)
	ESX.Game.SpawnVehicle(vehicleName, Config.RentalVehicleSpawnCoord, Config.RentalVehicleSpawnHeading, function(vehicle)
		local playerPed = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	end)
end)

function OpenVehicleMenu(items)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Offroad Vehicle Rental",
		align = "center",
		elements = items
	}, function(data, menu)		
		local item, price, name = data.current.spawnCode, data.current.price, data.current.label
		TriggerServerEvent('esx_CountyAlive:RentVehicle', price, item)
	end,
	function(data, menu)
		menu.close()
	end)
end

-- Hiking --
if Config.EnableHiking then
	Citizen.CreateThread(function()
		local safeZCoord = GetGroundZAndNormalFor_3dCoord(Config.TrailSignInCoord.x, Config.TrailSignInCoord.y, Config.TrailSignInCoord.z)
		local HikingSign = CreateObject(Config.TrailSignInSignHash, Config.TrailSignInCoord.x, Config.TrailSignInCoord.y, Config.TrailSignInCoord.z - Config.TrailSignInCoordZOffset, true, true, false)
		SetEntityHeading(HikingSign, Config.TrailSignInHeading)
	end)
end

if Config.EnableHiking and Config.EnableHikingBlip then
	Citizen.CreateThread(function()
		local blip = AddBlipForCoord(Config.TrailSignInCoord)
		SetBlipSprite(blip, Config.HikingBlipSprite)
		SetBlipColour(blip, Config.HikingBlipColour)
		SetBlipScale(blip, Config.HikingBlipScale)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Hiking")
		EndTextCommandSetBlipName(blip)
end)
end

if Config.EnableHiking and Config.GlobalHikingNotification then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end
	
		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(PlayerPedId())
			while #(GetEntityCoords(PlayerPedId()) - Config.TrailSignInCoord) <= 3.0 do
				Citizen.Wait(0)
				ESX.Game.Utils.DrawText3D(Config.TrailSignInCoord, "Press ~o~[E]~s~ to begin your hike!", 0.6)
				if IsControlJustReleased(0, 51) then
					if not isHiking then
						TriggerServerEvent('esx_CountyAlive:GlobalAlert', Config.HikingAlertText)
						isHiking = true
					else
						ESX.ShowNotification('~r~[ERROR]~w~ You have already began your hike!')
					end
				end
			end
		end
	end)
end

if Config.EnableHiking then
	Citizen.CreateThread(function()
		while not NetworkIsSessionStarted() do
			Wait(500)
		end

		while true do
			Citizen.Wait(1)
			local coords = GetEntityCoords(PlayerPedId())
			while #(GetEntityCoords(PlayerPedId()) - Config.TrailEndCoords) <= 3.0 do
				Citizen.Wait(0)
				ESX.Game.Utils.DrawText3D(Config.TrailEndCoords, "Press ~o~[E]~s~ to end your hike!", 0.6)
				if IsControlJustReleased(0, 51) then
					if isHiking then
						if Config.EnableHikingReward then
							if Config.HikingRewardMoney then
								--TriggerServerEvent('esx_CountyAlive:AddMoney', Config.HikingRewardAmount) ** Use this if you want, some people decide not to in case of exploits **
								TriggerServerEvent('esx_CountyAlive:AddHikingRewardMoney')
							else
								--TriggerServerEvent('esx_CountyAlive:AddInventoryItem', Config.HikingRewardItem) ** Use this if you want, some people decide not to in case of exploits **
								TriggerServerEvent('esx_CountyAlive:AddHikingRewardItem')
							end
						end
						ESX.ShowNotification('Your hike has ended! Congratulations!')
						isHiking = false
					else
						ESX.ShowNotification('~r~[ERROR]~w~ You have not began your hike!')
					end
				end
			end
		end
	end)
end

if Config.EnableHiking then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if isHiking then
				for k,v in pairs(Config.TrailCheckPoints) do
					DrawMarker(1, v.x, v.y, v.z - 0.98, 
					0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 15.0, 245, 182, 66, 200, 
					false, true, 2, false, nil, nil, false)
				end
			end
		end
	end)
end

-- Debug --
if Config.EnableDebug then
	RegisterCommand('_tentDetails', function()
		GetTentDetails()
	end)
end

-- EXPORTS --
function GetTentStatus()
	return tentSet
end

function GetFireStatus()
	return fireStarted
end

function GetGrillStatus()
	return grillSet
end

function GetChairStatus()
	return grillSet
end

function GetEditModeStatus()
	return editMode
end

function GetFishingStatus()
	return isFishing
end

function GetHikingStatus()
	return isHiking
end

function GetTentDetails()
	tentDetails.coords = GetEntityCoords(tent)
	tentDetails.heading = GetEntityHeading(tent)
	return tentDetails
end

function GetFireDetails()
	fireDetails.coords = GetEntityCoords(fire)
	fireDetails.heading = GetEntityHeading(fire)
	return fireDetails
end

function GetGrillDetails()
	grillDetails.coords = GetEntityCoords(grill)
	grillDetails.heading = GetEntityHeading(grill)
	return grillDetails
end

function GetChairDetails()
	chairDetails.coords = GetEntityCoords(chair)
	chairDetails.heading = GetEntityHeading(chair)
	return chairDetails
end