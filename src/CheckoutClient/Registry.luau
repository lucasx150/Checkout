--!strict

local Types = require("./Types")

local Registry = {}

Registry.Gamepasses = {} :: {[number]: Types.ClientGamepass}
Registry.DevProducts = {} :: {[number]: Types.ClientDevProduct}

Registry.AddDevProduct = function(devProduct: Types.ClientDevProduct)
    for _, id in devProduct.Ids do
        Registry.DevProducts[id] = devProduct
    end
end

Registry.GetDevProduct = function(id: number): Types.ClientDevProduct?
    return Registry.DevProducts[id]
end

Registry.AddGamepass = function(gamepass: Types.ClientGamepass)
    for _, id in gamepass.Ids do
        Registry.Gamepasses[id] = gamepass
    end
end

Registry.GetGamepass = function(id: number): Types.ClientGamepass?
    return Registry.Gamepasses[id]
end

return Registry
