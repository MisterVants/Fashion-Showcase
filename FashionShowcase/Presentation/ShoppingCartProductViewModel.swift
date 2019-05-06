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
    var productPrice: String {get}
    var productSize: String {get}
    var supplementaryPrice: NSAttributedString? {get}
    var quantity: Reactive<Int> {get}
    var quantityString: Reactive<String> {get}
    var productImageData: Reactive<Data?> {get}
    func loadProductImage()
    func changeQuantity(to newQuantity: Int)
    func matches(_ product: ShoppingCartProduct) -> Bool
}

protocol ShoppingCartProductViewModelDelegate: AnyObject {
    func shouldChangeQuantityOf(_ cartProduct: ShoppingCartProduct, to newQuantity: Int) -> Bool
}

extension ShoppingCartProduct {
    
    class ViewModel: ShoppingCartProductViewModel {
        
        let cartProduct: ShoppingCartProduct
        let client: DataClient
        
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
            self.quantity = Reactive(quantity)
            self.quantityString = Reactive("\(quantity)")
            self.productImageData = Reactive(nil)
            self.isLoadingImage = Reactive(false)
        }
        
        var productName: String {
            return product.name
        }
        
        var productPrice: String {
            return product.actualPrice
        }
        
        var productSize: String {
            return "TAMANHO: \(cartProduct.selectedSize.size)"
        }
        
        var supplementaryPrice: NSAttributedString? {
            guard
                product.isOnSale,
                let actualPrice = product.actualPriceValue,
                let regularPrice = product.regularPriceValue,
                actualPrice != regularPrice else { return nil }
            
            let slashedPrice = NSAttributedString(string: product.regularPrice, attributes: [NSAttributedString.Key.strikethroughStyle : 2])
            return slashedPrice
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
        
        func changeQuantity(to newQuantity: Int) {
            if delegate?.shouldChangeQuantityOf(self.cartProduct, to: newQuantity) == true {
                quantity.value = newQuantity
                quantityString.value = "\(newQuantity)"
            } else {
                quantity.value = quantity.value // Trigger stepper binding
            }
        }
        
        func matches(_ product: ShoppingCartProduct) -> Bool {
            return cartProduct == product ? true : false
        }
    }
}
