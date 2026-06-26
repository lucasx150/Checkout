local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local ClientRun = require("./ClientRun")
local Registry = require("../Registry")
local Types = require("../Types")

local externalHandlers = {}

local function grant(devProduct: Types.DevProduct, player: Player, productId: number, receiptInfo: Types.ReceiptInfo)
	local handler = devProduct.Grant

	if handler then
		local result = handler(player, productId, receiptInfo)

		if result == false or result == Enum.ProductPurchaseDecision.NotProcessedYet then
			-- Server failed, meaning that Roblox will try to grant the product again. Therefore, dont run the client handler 
			return false
		end
	end

	if Registry.HasClientDevProduct(productId) then
		ClientRun.RunDevProduct(player, productId)
	end

	return true
end

local function processReceipt(receiptInfo: Types.ReceiptInfo): Enum.ProductPurchaseDecision
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = Players:GetPlayerByUserId(userId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local devProduct = Registry.GetDevProduct(productId)
	if not devProduct then
		-- DevProduct is not handled by this script. Run external handlers
		local success = false
		
		for _, func in ipairs(externalHandlers) do
			local handlerResult = func(receiptInfo)

			if (handlerResult ~= false) and (handlerResult ~= Enum.ProductPurchaseDecision.NotProcessedYet) then
				success = true
			end
		end

		if success then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			print("Could not find DevProduct for id", productId)
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	end

	local result = grant(devProduct, player, productId, receiptInfo)

	if result ~= false then
		Registry.FireHooks("DevProductPurchased", player, productId, receiptInfo)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		print(string.format("Failed to grant DevProduct %s to player %s", tostring(productId) or "nil", player.Name or "nil"))
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

MarketplaceService.ProcessReceipt = processReceipt


local DevProductHandler = {}

DevProductHandler.GrantDevProduct = grant

DevProductHandler.ProcessReceipt = processReceipt

DevProductHandler.AddToProcessReceipt = function(func: (Types.ReceiptInfo) -> (any))
	table.insert(externalHandlers, func)
end

return DevProductHandler