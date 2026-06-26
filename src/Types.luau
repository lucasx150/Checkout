export type ReceiptInfo = {
    PurchaseId: string,
    PlayerId: number,
    ProductId: number,
    CurrencySpent: number,
}

export type DevProduct = {
    Grant: (player: Player, productId: number, receiptInfo: ReceiptInfo) -> (Enum.ProductPurchaseDecision | boolean),
    Ids: {number}
}

export type Gamepass = {
    Grant: (player: Player, gamepassId: number) -> (),
    Ids: {number}
}

export type ClientDevProduct = {
    Grant: (productId: number) -> (),
    Ids: {number}
}

export type ClientGamepass = {
    Grant: (gamepassId: number) -> (),
    Ids: {number}
}

export type Hook = {
    HookType: string,
    HookFn: (any) -> ()
}

export type Registry = {
    Gamepasses: {[number]: Gamepass},
    DevProducts: {[number]: DevProduct},
    GamepassesWithClientRun: {[number]: boolean},
    DevProductsWithClientRun: {[number]: boolean},
    Hooks: {[string]: {(any) -> ()}},

    AddGamepass: (gamepass: Gamepass) -> (),
    AddDevProduct: (devProduct: DevProduct) -> (),
    AddClientGamepass: (gamepass: ClientGamepass) -> (),
    AddClientDevProduct: (devProduct: ClientDevProduct) -> (),
    GetGamepass: (id: number) -> Gamepass,
    GetDevProduct: (id: number) -> DevProduct,
    HasClientGamepass: (gamepassId: number) -> boolean,
    HasClientDevProduct: (productId: number) -> boolean,
    AddHook: (hook: Hook) -> (),
    FireHooks: (hookType: string, ...any) -> (),
}

return {}