ESX = nil
local users = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_CountyAlive:PurchaseItem')
AddEventHandler('esx_CountyAlive:PurchaseItem', function(item, price)
    local xPlayer = ESX.GetPlayerFromId(source)
	if price <= xPlayer.getMoney() then
		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(item, 1)
		xPlayer.showNotification("You purchased: ~y~" .. ESX.GetItemLabel(item))
	else
		xPlayer.showNotification("~r~[ERROR]~w~ Not enough money to purchase item!")
	end
end)

RegisterServerEvent('esx_CountyAlive:AddInventoryItem')
AddEventHandler('esx_CountyAlive:AddInventoryItem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem(item, 1) then
        xPlayer.addInventoryItem(item, 1)
    else
        xPlayer.showNotification('~r~[ERROR]~w~ You cannot carry that item!')
    end
end)

RegisterServerEvent('esx_CountyAlive:AddMoney')
AddEventHandler('esx_CountyAlive:AddMoney', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if users[source] then 
		xPlayer.addMoney(Config.HikingRewardAmount)
		users[source] = nil 
	else
		print(('esx_policejob: %s attempted to confiscate!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_CountyAlive:RentVehicle')
AddEventHandler('esx_CountyAlive:RentVehicle', function(price, vehicle)
    local xPlayer = ESX.GetPlayerFromId(source)
	if price <= xPlayer.getMoney() then
        xPlayer.removeMoney(price)
		xPlayer.triggerEvent('esx_CountyAlive:RentVehicleReturn', vehicle)
	else
		xPlayer.showNotification("~r~[ERROR]~w~ Not enough money to rent vehicle!")
	end
end)

RegisterServerEvent('esx_CountyAlive:GlobalAlert')
AddEventHandler('esx_CountyAlive:GlobalAlert', function(text)
    local xPlayer = ESX.GetPlayerFromId(source)
	users[source] = true 
	TriggerClientEvent('esx_CountyAlive:ShowGlobalAlert', -1, text)
end)

ESX.RegisterServerCallback('esx_CountyAlive:CheckPlayerBalance', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
	if price <= xPlayer.getMoney() then
		cb(true)
	else
		cb(false)
	end
end)