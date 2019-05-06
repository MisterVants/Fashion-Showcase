//
//  ShoppingCartProduct.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 06/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

struct ShoppingCartProduct: Hashable {
    let product: Product
    let selectedSize: ProductSize
}

extension ShoppingCartProduct {
    
    var regularPriceValue: Double? {
        return PriceFormatter.default.number(from: self.product.regularPrice)
    }
    
    var actualPriceValue: Double? {
        return PriceFormatter.default.number(from: self.product.actualPrice )
    }
}

