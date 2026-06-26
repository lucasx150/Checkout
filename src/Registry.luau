--!strict

local Types = require("./Types")

local Registry = {}

Registry.Gamepasses = {} :: {[number]: Types.Gamepass}
Registry.GamepassIds = {} :: {[number]: boolean}
Registry.DevProducts = {} :: {[number]: Types.DevProduct}
Registry.GamepassesWithClientRun = {} :: {[number]: boolean}
Registry.DevProductsWithClientRun = {} :: {[number]: boolean}
Registry.Hooks = {} :: {[string]: {(any) -> ()}}

Registry.AddGamepass = function(gamepass: Types.Gamepass)
    for _, id in gamepass.Ids do
        Registry.Gamepasses[id] = gamepass
        Registry.GamepassIds[id] = true
    end
end

Registry.AddDevProduct = function(devProduct: Types.DevProduct)
    for _, id in devProduct.Ids do
        Registry.DevProducts[id] = devProduct
    end
end

Registry.AddClientGamepass = function(gamepass: Types.ClientGamepass)
    for _, id in gamepass.Ids do
        Registry.GamepassesWithClientRun[id] = true
    end
end

Registry.AddClientDevProduct = function(devProduct: Types.ClientDevProduct)
    for _, id in devProduct.Ids do
        Registry.DevProductsWithClientRun[id] = true
    end
end


Registry.GetDevProduct = function(id: number): Types.DevProduct
    return Registry.DevProducts[id]
end

Registry.GetGamepass = function(id: number): Types.Gamepass
    return Registry.Gamepasses[id]
end

Registry.HasClientDevProduct = function(productId: number)
    return Registry.DevProductsWithClientRun[productId]
end

Registry.HasClientGamepass = function(gamepassId: number)
    return Registry.GamepassesWithClientRun[gamepassId]
end

Registry.AddHook = function(hook: Types.Hook)
    local hookTypeTable = Registry.Hooks[hook.HookType]
    if not hookTypeTable then
        hookTypeTable = {}
        Registry.Hooks[hook.HookType] = hookTypeTable
    end

    table.insert(hookTypeTable, hook.HookFn)
end

Registry.FireHooks = function(hookType: string, ...: any)
    local hookTypeTable = Registry.Hooks[hookType]
    if not hookTypeTable then return end

    for _, hook in ipairs(hookTypeTable) do
        hook(...)
    end
end


return Registry