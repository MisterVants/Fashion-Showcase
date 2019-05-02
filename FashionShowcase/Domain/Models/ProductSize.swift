//
//  ProductSize.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

struct ProductSize: Codable {
    let isAvailable: Bool
    let size: String
    let stockKeepingUnit: String
}

extension ProductSize {
    
    enum CodingKeys: String, CodingKey {
        case isAvailable = "available"
        case size
        case stockKeepingUnit = "sku"
    }
}
