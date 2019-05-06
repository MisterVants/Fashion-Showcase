//
//  ShoppingCartPresenter.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ShoppingCartPresenter {
    var numberOfCartItems: Int {get}
}

class ShoppingCartViewPresenter: ShoppingCartPresenter {
    
    let shoppingCart: ProductShoppingCart
    
    init(shoppingCart: ProductShoppingCart) {
        self.shoppingCart = shoppingCart
    }
    
    var numberOfCartItems: Int {
        return 0
    }
}
