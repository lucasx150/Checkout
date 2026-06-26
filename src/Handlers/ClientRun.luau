local Shared = require("../Shared")

local ClientRun = {}

ClientRun.RunDevProduct = function(player: Player, productId: number)
    Shared.Remote:FireClient(player, "RunDevProduct", productId)
end

ClientRun.RunGamepass = function(player: Player, gamepassId: number)
    Shared.Remote:FireClient(player, "RunGamepass", gamepassId)
end

return ClientRun