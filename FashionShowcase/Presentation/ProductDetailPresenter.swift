//
//  ProductDetailPresenter.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ProductDetailPresenter {
    var viewModel: ProductViewModel {get}
    func addProductToCart()
}

class ProductDetailViewPresenter: ProductDetailPresenter {
    
    let viewModel: ProductViewModel
//    let client: DataClient
    
//    var productImageData: Reactive<Data?>
//    var isLoadingImage: Reactive<Bool>
    
    init(product: ProductViewModel) {//}, dataClient: DataClient) {
        self.viewModel = product
//        self.client = dataClient
//        self.productImageData = Reactive(nil)
//        self.isLoadingImage = Reactive(false)
    }
    
//    var productName: String {
//        return product.name
//    }
//
//    var productPrice: String {
//        return product.actualPrice
//    }
//
//    var supplementaryPrice: NSAttributedString? {
//        guard
//            product.isOnSale,
//            let actualPrice = product.actualPriceValue,
//            let regularPrice = product.regularPriceValue,
//            actualPrice != regularPrice else { return nil }
//
//        let slashedPrice = NSAttributedString(string: product.regularPrice, attributes: [NSAttributedString.Key.strikethroughStyle : 2])
//        return slashedPrice
//    }
//
//    var discountAmount: String? {
//        guard !product.discountPercent.isEmpty else { return nil }
//        return "\(product.discountPercent) OFF"
//    }
//
//    var isProductOnSale: Bool {
//        return product.isOnSale
//    }
//
//    func loadProductImage() {
//        guard
//            isLoadingImage.value == false,
//            productImageData.value == nil,
//            let imageUrl = product.imageUrl else { return }
//
//        isLoadingImage.value = true
//        client.getData(at: imageUrl) { [weak self] result in
//            self?.isLoadingImage.value = false
//            self?.productImageData.value = try? result.get()
//        }
//    }
    
    func addProductToCart() {
        
    }
}
