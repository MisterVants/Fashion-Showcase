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
    var productPrice: String {get}
    var promotionalPrice: String {get}
    var isProductOnSale: Bool {get}
//    var availableSizes: []
    var productImageData: Reactive<Data?> {get}
    var isLoadingImage: Reactive<Bool> {get}
    func loadProductImage()
}

extension Product {
    
    class ViewModel: ProductViewModel {
        
        let product: Product
        let client: DataClient
        
        var productImageData: Reactive<Data?>
        var isLoadingImage: Reactive<Bool>
        
        init(from product: Product, dataClient: DataClient) {
            self.product = product
            self.client = dataClient
            self.productImageData = Reactive(nil)
            self.isLoadingImage = Reactive(false)
        }
        
        var productName: String {
            return product.name
        }
        
        var productPrice: String {
            return product.regularPrice
        }
        
        var promotionalPrice: String {
            return product.actualPrice
        }
        
        var isProductOnSale: Bool {
            return product.isOnSale
        }
        
        func loadProductImage() {
            guard
                isLoadingImage.value == false,
                productImageData.value == nil,
                let imageUrl = product.imageUrl else { return }
            
            isLoadingImage.value = true
            client.getData(at: imageUrl) { [weak self] result in
                self?.isLoadingImage.value = false
                self?.productImageData.value = try? result.get()
            }
        }
    }
}
