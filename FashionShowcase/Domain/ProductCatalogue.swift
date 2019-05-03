//
//  ProductCatalogue.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

typealias ProductsCallback = (Result<[Product], FSError>) -> Void

protocol ProductCatalogue {
    func getProducts() -> [Product]?
    func loadProducts(from api: ProductsAPI, completion: @escaping ProductsCallback)
}

class ProductDataStore: ProductCatalogue {
    
    var products: [Product] = []
    
    func getProducts() -> [Product]? {
        guard !products.isEmpty else { return nil }
        return products
    }
    
    func loadProducts(from api: ProductsAPI, completion: @escaping ProductsCallback) {
        api.fetchProducts { result in
            if let loadedProducts = try? result.get() {
                self.products = loadedProducts
            }
            completion(result)
        }
    }
}
