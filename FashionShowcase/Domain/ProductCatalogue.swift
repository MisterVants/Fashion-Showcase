//
//  ProductCatalogue.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ProductCatalogue {
//    func getProducts(completion: @escaping )
    func setProducts(_ products: [Product])
}

class ProductDataStore {
    
    var products: [Product] = []
}
