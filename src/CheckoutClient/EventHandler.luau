--!strict

local Registry = require("./Registry")

local eventHandlers: {[string]: (number) -> ()} = {
    RunDevProduct = function(productId: number)
        local devProduct = Registry.GetDevProduct(productId)
        if devProduct then
            devProduct.Grant(productId)
        end
    end,

    RunGamepass = function(gamepassId: number)
        local gamepass = Registry.GetGamepass(gamepassId)
        if gamepass then
            gamepass.Grant(gamepassId)
        end
    end,
}

local remote: RemoteEvent = script.Parent:WaitForChild("RemoteEvent")

remote.OnClientEvent:Connect(function(event: string, ...)
    local handler = eventHandlers[event]

    if handler then
        handler(...)
    end
end)

return {}
