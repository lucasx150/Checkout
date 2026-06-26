local DevProduct = {}

DevProduct.Ids = {1}

DevProduct.Grant = function(player: Player, productId: number, receiptInfo): Enum.ProductPurchaseDecision | boolean
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

return DevProduct