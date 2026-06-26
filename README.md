# Checkout

Checkout is a DevProduct and Gamepass handler for Roblox. It lets you define grant logic as individual ModuleScripts, automatically handles `ProcessReceipt`, checks gamepass ownership on player join, supports client side handlers, and lets you grant DevProducts or Gamepasses directly without a real purchase.

## Setup

**Server**:
```lua
local Checkout = require(path.to.Checkout)

-- Register all DevProducts and Gamepasses from a container
Checkout.RegisterDevProductsIn(path.to.DevProducts)
Checkout.RegisterGamepassesIn(path.to.Gamepasses)

-- Register client-side handlers (replicated to the client automatically)
Checkout.RegisterClientDevProductsIn(path.to.ClientDevProducts)
Checkout.RegisterClientGamepassesIn(path.to.ClientGamepasses)
```

**Client**:
```lua
require(path.to.Checkout)
```

## Structure

Checkout is driven by ModuleScripts organised into folders. Each folder is passed to a `Register...In` call, and Checkout will pick up every ModuleScript inside it.

```
ServerScriptService
├── DevProducts
│   ├── Coins.luau
│   └── Gems.luau
├── Gamepasses
│   └── VIP.luau
├── ClientDevProducts       -- optional, for client-side effects
│   └── Coins.luau
└── ClientGamepasses        -- optional
    └── VIP.luau
```

A server and client module for the same item can exist independently - you don't need both. A DevProduct with only a client module and no server module is valid (e.g. cosmetic effects that don't need server state).

## DevProduct Modules

Each DevProduct module handles one or more product ids.

- **`Ids`** - array of DevProduct ids this module handles.
- **`Grant`** - called from the server when a DevProduct with an id that is in Ids is purchased.

Return `false` or `Enum.ProductPurchaseDecision.NotProcessedYet` to signal failure.
If omitted, the product is treated as client-only.

```lua
local DevProduct = {}

DevProduct.Ids = {01234, 56789}
DevProduct.Grant = function(player: Player, productId: number, receiptInfo): Enum.ProductPurchaseDecision | boolean
    -- grant the product to the player
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

return DevProduct
```

## Gamepass module

Each Gamepass module handles one or more gamepass IDs.

- **`Ids`** - array of Gamepass ids this module handles.
- **`Grant`** - called from the server when a player owns a gamepass with an id that is in Ids.

If omitted, the product is treated as client-only.

```lua
local Gamepass = {}

Gamepass.Ids = {2345, 6789}
Gamepass.Grant = function(player: Player, gamepassId: number)
    -- grant the gamepass to the player
end

return Gamepass
```

## Client modules

Client modules run on the purchasing player's client after the (if existing) server handler succeeds. 

- **`Ids`** - array of ids this module handles, matching the server-side module.
- **`Grant`** - called on the client after a successful server grant.

```lua
-- ClientDevProduct
local DevProduct = {}

DevProduct.Ids = {01234}
DevProduct.Grant = function(productId: number)
    -- e.g. play a sound or show an effect
end

return DevProduct
```

```lua
-- ClientGamepass
local Gamepass = {}

Gamepass.Ids = {2345}
Gamepass.Grant = function(gamepassId: number)
    -- e.g. update the local UI
end

return Gamepass
```

## Hooks

Hooks fire after a successful grant. Available hook types: `DevProductPurchased`, `GamepassPurchased`. They are primarily intended for logging.

```lua
local Hook = {}
Hook.HookType = "DevProductPurchased"
Hook.HookFn = function(player: Player, productId: number, receiptInfo) end
return Hook
```

```lua
Checkout.RegisterHooksIn(path.to.Hooks)
```

## Manual granting
Checkout also lets you give DevProduct or Gamepass perks to players from other sources.

```lua
Checkout.GrantDevProduct(player, productId)
Checkout.GrantGamepass(player, gamepassId)
```

## Legacy ProcessReceipt

If you have existing ProcessReceipt logic for DevProducts not managed by Checkout:

```lua
Checkout.AddToProcessReceipt(function(receiptInfo)
    -- your other ProcessReceipt callback
end)
```
