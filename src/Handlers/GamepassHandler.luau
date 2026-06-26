--!strict

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local ClientRun = require("./ClientRun")
local Registry = require("../Registry")
local Types = require("../Types")


local function grant(gamepass: Types.Gamepass, player: Player, gamepassId: number): boolean
    local handler = gamepass.Grant

    local granted = false

    if handler then
        handler(player, gamepassId)
        granted = true
    end

    if Registry.HasClientGamepass(gamepassId) then
		ClientRun.RunGamepass(player, gamepassId)
        granted = true
	end

    return granted
end

local function checkOwnsAndGrant(player: Player, gamepassId: number): boolean
    if not MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId) then return false end

    local gamepass = Registry.GetGamepass(gamepassId)
    if not gamepass then
        print("Could not find Gamepass for id", gamepassId)
        return false
    end

    local granted = grant(gamepass, player, gamepassId)

    return granted
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, wasPurchased)
    if not wasPurchased then return end
    local ran = checkOwnsAndGrant(player, gamepassId)

    if ran then
        Registry.FireHooks("GamepassPurchased", player, gamepassId)
    end
end)

Players.PlayerAdded:Connect(function(player)
    for gamepassId in pairs(Registry.GamepassIds) do
        checkOwnsAndGrant(player, gamepassId)
    end
end)

local GamepassHandler = {}

GamepassHandler.GrantGamepass = grant

return GamepassHandler