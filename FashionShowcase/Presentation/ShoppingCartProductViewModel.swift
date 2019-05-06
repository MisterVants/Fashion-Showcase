//
//  ShoppingCartProductViewModel.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 06/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ShoppingCartProductViewModel {
    var delegate: ShoppingCartProductViewModelDelegate? {get set}
    var productName: String {get}
    var productSize: String {get}
    var productPrice: Reactive<String> {get}
    var supplementaryPrice: Reactive<NSAttributedString?> {get}
    var quantity: Reactive<Int> {get}
    var quantityString: Reactive<String> {get}
    var productImageData: Reactive<Data?> {get}
    func loadProductImage()
    func shouldChangeQuantity(to newQuantity: Int)
    func matches(_ product: ShoppingCartProduct) -> Bool
}

protocol ShoppingCartProductViewModelDelegate: AnyObject {
    func shouldChangeQuantityOf(_ cartProduct: ShoppingCartProduct, to newQuantity: Int) -> Bool
}

extension ShoppingCartProduct {
    
    class ViewModel: ShoppingCartProductViewModel {
        
        let cartProduct: ShoppingCartProduct
        let client: DataClient
        
        var productPrice: Reactive<String>
        var supplementaryPrice: Reactive<NSAttributedString?>
        var quantity: Reactive<Int>
        var quantityString: Reactive<String>
        var productImageData: Reactive<Data?>
        var isLoadingImage: Reactive<Bool>
        
        weak var delegate: ShoppingCartProductViewModelDelegate?
        
        private var product: Product {
            return cartProduct.product
        }
        
        init(from cartProduct: ShoppingCartProduct, quantity: Int, dataClient: DataClient) {
            self.cartProduct = cartProduct
            self.client = dataClient
            self.productPrice = Reactive("")
            self.supplementaryPrice = Reactive(nil)
            self.quantity = Reactive(0)
            self.quantityString = Reactive("")
            self.productImageData = Reactive(nil)
            self.isLoadingImage = Reactive(false)
            
            self.changeQuantity(to: quantity)
        }
        
        var productName: String {
            return product.name
        }
        
        var productSize: String {
            return "TAMANHO: \(cartProduct.selectedSize.size)"
        }
        
        func loadProductImage() {
            guard
                isLoadingImage.value == false,
                productImageData.value == nil,
                let imageUrl = cartProduct.product.imageUrl else { return }
            
            isLoadingImage.value = true
            client.getData(at: imageUrl) { [weak self] result in
                self?.isLoadingImage.value = false
                self?.productImageData.value = try? result.get()
            }
        }
        
        func shouldChangeQuantity(to newQuantity: Int) {
            if delegate?.shouldChangeQuantityOf(self.cartProduct, to: newQuantity) == true {
                changeQuantity(to: newQuantity)
            } else {
                quantity.value = quantity.value // Trigger stepper binding
            }
        }
        
        func matches(_ product: ShoppingCartProduct) -> Bool {
            return cartProduct == product ? true : false
        }
        
        private func changeQuantity(to newQuantity: Int) {
            quantity.value = newQuantity
            quantityString.value = "\(newQuantity)"
            
            if let price = product.actualPriceValue {
                let totalPrice = price * Double(newQuantity)
                if let priceString = PriceFormatter.default.string(from: totalPrice) {
                    productPrice.value = priceString
                }
            }
            
            if product.isOnSale,
                let actualPrice = product.actualPriceValue,
                let regularPrice = product.regularPriceValue,
                actualPrice != regularPrice {
                
                let totalPrice = regularPrice * Double(newQuantity)
                if let priceString = PriceFormatter.default.string(from: totalPrice) {
                    let slashedPrice = NSAttributedString(string: priceString, attributes: [NSAttributedString.Key.strikethroughStyle : 2])
                    supplementaryPrice.value = slashedPrice
                }
            }
        }
    }
}
