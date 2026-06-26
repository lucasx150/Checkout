--!strict

local Registry = require("@self/Registry")
local Types = require("@self/Types")

local devProductsFolder = script.DevProducts
local gamepassesFolder = script.Gamepasses

local function registerIfModuleScript(obj: Instance, register: (ModuleScript) -> ())
    if not obj:IsA("ModuleScript") then return end
    register(obj)
end

local function registerContainerChildren(container: Instance, register: (ModuleScript) -> ())
	for _, descendant in container:GetChildren() do
		registerIfModuleScript(descendant, register)
	end

    container.ChildAdded:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            registerIfModuleScript(descendant, register)
		end
    end)
end

registerContainerChildren(devProductsFolder, function(module: ModuleScript)
    local data = require(module) :: Types.ClientDevProduct
    Registry.AddDevProduct(data)
end)

registerContainerChildren(gamepassesFolder, function(module: ModuleScript)
    local data = require(module) :: Types.ClientGamepass
    Registry.AddGamepass(data)
end)

require("@self/EventHandler")
