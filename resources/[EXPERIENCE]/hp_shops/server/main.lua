local ShopItems = {}


function GetItemFromShop(Item, Zone)
	local item = {}

	if Config.Zones[Zone].Items[Item] ~= nil then
		return true, Config.Zones[Zone].Items[Item].price, Config.Zones[Zone].Items[Item].label
	end
	return false
end


RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, amount, zone)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local Exists, price,label = GetItemFromShop(itemName,zone)
	amount = ESX.Math.Round(amount)

	if amount < 0 then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to exploit the shop!'):format(source))
		return
	end

	if not Exists then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to exploit the shop!'):format(source))
		return
	end

	if Exists then
		price = price * amount
	-- can the player afford this item?
		if xPlayer.getMoney() >= price then
			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, amount) then
				xPlayer.removeMoney(price, label .. " " .. TranslateCap('purchase'))
				xPlayer.addInventoryItem(itemName, amount)
				xPlayer.showNotification(TranslateCap('bought', amount, label, ESX.Math.GroupDigits(price)))
			else
				xPlayer.showNotification(TranslateCap('player_cannot_hold'))
			end
		else
			local missingMoney = price - xPlayer.getMoney()
			xPlayer.showNotification(TranslateCap('not_enough', ESX.Math.GroupDigits(missingMoney)))
		end
	end
end)

RegisterNetEvent("hp_shops:BuyItems", function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Basket = data.itemsArray
	local PaymentType = (data.paymentType == "cash" and "money" or "bank")
	local TotalPrice = 0

	if Config.Zones[data.title] ~= nil then
		for k, v in pairs(Basket) do
			local Exists, price, label = GetItemFromShop(v.item, data.title)
			if Exists then
				TotalPrice = TotalPrice + (price * v.quantity)
			else
				return (xPlayer.showNotification("Wystapil blad!"))
			end
		end
	else
		return (xPlayer.showNotification("Wystapil blad!"))
	end

	if xPlayer.getAccount(PaymentType).money >= TotalPrice then
		xPlayer.removeAccountMoney(PaymentType, TotalPrice)
		for k, v in pairs(Basket) do
			xPlayer.addInventoryItem(v.item, v.quantity)
		end
		return (xPlayer.showNotification("Zakupiono!"))
	else
		return (xPlayer.showNotification("Brakuje ci "..(TotalPrice - xPlayer.getAccount(PaymentType).money).."$!"))
	end
	return (xPlayer.showNotification("Wystapil blad!"))
end)