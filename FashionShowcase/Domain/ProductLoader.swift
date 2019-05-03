//
//  ProductLoader.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ProductLoader {
    func loadProducts(into catalogue: ProductCatalogue, replacingItems: Bool)
}

extension ProductLoader {
    func loadProducts(into catalogue: ProductCatalogue, replacingItems: Bool = false) {
        return loadProducts(into: catalogue, replacingItems: replacingItems)
    }
}

class ProductDataAccess {
    
    let api: ProductsAPI? = nil
}
