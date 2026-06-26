export type ReceiptInfo = {
    PurchaseId: string,
    PlayerId: number,
    ProductId: number,
    CurrencySpent: number,
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

return {}