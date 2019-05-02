//
//  Products.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

struct Product: Codable {
    let name: String
    let style: String
    let colorCode: String
    let colorSlug: String
    let colorName: String
    let isOnSale: Bool
    let regularPrice: String
    let actualPrice: String
    let discountPercent: String
    let installments: String
    let imageUrlString: String
    let sizes: [ProductSize]
}

extension Product {
    
    enum CodingKeys: String, CodingKey {
        case name
        case style
        case colorCode = "code_color"
        case colorSlug = "color_slug"
        case colorName = "color"
        case isOnSale = "on_sale"
        case regularPrice = "regular_price"
        case actualPrice = "actual_price"
        case discountPercent = "discount_percentage"
        case installments
        case imageUrlString = "image"
        case sizes
    }
}
