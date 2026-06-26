--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DevProductHandler = require("@self/Handlers/DevProductHandler")
local GamepassHandler = require("@self/Handlers/GamepassHandler")
local MatchAny = require("@self/Utils/MatchAny")
local Registry = require("@self/Registry")
local Shared = require("@self/Shared")
local Types = require("@self/Types")

Shared.Client.Parent = ReplicatedStorage

local function registerDescendantsIn(container: Instance, matchPattern, register)
	for _, descendant in container:GetDescendants() do
		if descendant:IsA("ModuleScript") and (not matchPattern or MatchAny(descendant.Name, matchPattern)) then
			register(descendant)
		end
	end
end

local Checkout = {}

Checkout.Registry = Registry

-- Grant a DevProduct directly
Checkout.GrantDevProduct = function(player: Player, productId: number, receiptInfo: Types.ReceiptInfo?)
	local devProduct = Registry.GetDevProduct(productId)
	if not devProduct then
		warn(string.format("Tried to grant DevProduct with unknown id %s.", tostring(productId) or "nil"))
		return
	end

	local info: Types.ReceiptInfo = receiptInfo or {
		PlayerId = player.UserId,
		ProductId = productId,
		CurrencySpent = 0,
		PurchaseId = HttpService:GenerateGUID(),
	}

	DevProductHandler.GrantDevProduct(devProduct, player, productId, info)
end

-- Grant a Gamepass directly
Checkout.GrantGamepass = function(player: Player, gamepassId: number)
	local gamepass = Registry.GetGamepass(gamepassId)
	if not gamepass then
		warn(string.format("Tried to grant Gamepass with unknown id %s.", tostring(gamepassId) or "nil"))
		return
	end


	GamepassHandler.GrantGamepass(gamepass, player, gamepassId)
end


-- Register a DevProduct from a ModuleScript
Checkout.RegisterDevProduct = function(module: ModuleScript)
	local data = require(module) :: Types.DevProduct
	Registry.AddDevProduct(data)
end

-- Register a Gamepass from a ModuleScript
Checkout.RegisterGamepass = function(module: ModuleScript)
	local data = require(module) :: Types.Gamepass
    Registry.AddGamepass(data)
end

-- Register a Hook from a ModuleScript
Checkout.RegisterHook = function(module: ModuleScript)
	local data = require(module) :: Types.Hook
    Registry.AddHook(data)
end

-- Register a Client DevProduct from a ModuleScript
Checkout.RegisterClientDevProduct = function(module: ModuleScript)
	local data = require(module) :: Types.ClientDevProduct
	Registry.AddClientDevProduct(data)
	module.Parent = Shared.Client.DevProducts
end

-- Register a Client Gamepass from a ModuleScript
Checkout.RegisterClientGamepass = function(module: ModuleScript)
	local data = require(module) :: Types.ClientGamepass
	Registry.AddClientGamepass(data)
	module.Parent = Shared.Client.Gamepasses
end


--[[

	Load from containers

]]

-- Register Client DevProducts from a container
Checkout.RegisterClientDevProductsIn = function(container: Instance, matchPattern: (string | {string})?)
	registerDescendantsIn(container, matchPattern, Checkout.RegisterClientDevProduct)
end

-- Register Client Gamepasses from a container
Checkout.RegisterClientGamepassesIn = function(container: Instance, matchPattern: (string | {string})?)
	registerDescendantsIn(container, matchPattern, Checkout.RegisterClientGamepass)
end

-- Register DevProducts from a container
Checkout.RegisterDevProductsIn = function(container: Instance, matchPattern: (string | {string})?)
	registerDescendantsIn(container, matchPattern, Checkout.RegisterDevProduct)
end

-- Register Gamepasses from a container
Checkout.RegisterGamepassesIn = function(container: Instance, matchPattern: (string | {string})?)
	registerDescendantsIn(container, matchPattern, Checkout.RegisterGamepass)
end

-- Register Hooks from a container
Checkout.RegisterHooksIn = function(container: Instance, matchPattern: (string | {string})?)
	registerDescendantsIn(container, matchPattern, Checkout.RegisterHook)
end


--[[
	Adds an alternative ProcessReceipt callback. Will be called if no DevProduct module is found.
	Useful for legacy code.
	Should return false or Enum.ProductPurchaseDecision.NotProcessedYet if failed.
]] 
Checkout.AddToProcessReceipt = function(func: (Types.ReceiptInfo) -> (any))
    DevProductHandler.AddToProcessReceipt(func)
end


return Checkout