//
//  ShoppingCart.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ShoppingCart {
    associatedtype Item
    
    var items: [Item] {get}
    var isEmpty: Bool {get}
    var count: Int {get}
    var totalPriceFull: Double {get}
    var totalPriceDiscounted: Double {get}
    
    func getTotalAmount(of item: Item) -> Int
    func getTotalPrice(for item: Item, discounted: Bool) -> Double
    
    func addItem(_ item: Item)
    func removeItem(_ item: Item)
    func deleteItem(_ item: Item)
    func deleteAllItems()
}

class ProductShoppingCart: ShoppingCart {
    typealias Item = ShoppingCartProduct
    
    private var products: [ShoppingCartProduct : Int] = [:]
    
    let capacityPerItem: Int
    
    init(withCapacity capacity: Int = 99, products: [ShoppingCartProduct : Int] = [:]) {
        self.capacityPerItem = capacity
        self.products = products
    }
    
    var items: [ShoppingCartProduct] {
        return Array(products.keys)
    }
    
    var isEmpty: Bool {
        return products.isEmpty
    }
    
    var count: Int {
        return products.count
    }
    
    var totalPriceFull: Double {
        return products.reduce(0.0) {
            $0 + (($1.key.product.regularPriceValue ?? 0.0) * Double($1.value))
        }
    }
    
    var totalPriceDiscounted: Double {
        return products.reduce(0.0) {
            $0 + (($1.key.product.actualPriceValue ?? 0.0) * Double($1.value))
        }
    }
    
    func getTotalAmount(of item: ShoppingCartProduct) -> Int {
        return products[item] ?? 0
    }
    
    func getTotalPrice(for item: ShoppingCartProduct, discounted: Bool) -> Double {
        let itemPrice = (discounted ? item.product.actualPriceValue : item.product.regularPriceValue) ?? 0.0
        let quantity = Double(products[item] ?? 0)
        return itemPrice * quantity
    }
    
    func addItem(_ item: ShoppingCartProduct) {
        if let quantity = products[item] {
            products[item] = min(quantity + 1, capacityPerItem)
        } else {
            products[item] = 1
        }
    }
    
    func removeItem(_ item: ShoppingCartProduct) {
        if let quantity = products[item] {
            if quantity > 1 {
                products[item] = quantity - 1
            } else {
                products.removeValue(forKey: item)
            }
        }
    }
    
    func deleteItem(_ item: ShoppingCartProduct) {
        products.removeValue(forKey: item)
    }
    
    func deleteAllItems() {
        products.removeAll()
    }
}
