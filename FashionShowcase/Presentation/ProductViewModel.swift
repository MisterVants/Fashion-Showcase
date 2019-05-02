//
//  ProductViewModel.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ProductViewModel {
    var productName: String {get}
    var regularPrice: String {get}
    var promotionalPrice: String {get}
    var isProductOnSale: Bool {get}
//    var availableSizes: []
    var productImageData: Reactive<Data?> {get}
    var isLoadingImage: Reactive<Bool> {get}
}

extension Product {
    class ViewModel {
        
        let product: Product
        
        init(from product: Product) {
            self.product = product
        }
    }
}
