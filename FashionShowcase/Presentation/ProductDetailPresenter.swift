//
//  ProductDetailPresenter.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ProductDetailPresenterDelegate: AnyObject {
    func onSizeSelect(_ index: Int)
}

protocol ProductDetailPresenter {
    var viewModel: ProductViewModel {get}
    func selectSize(index: Int)
    func addProductToCart()
    func didFinishDismissingView()
}

class ProductDetailViewPresenter: ProductDetailPresenter {
    
    let viewModel: ProductViewModel
    let shoppingCart: ProductShoppingCart
    
    var shouldOpenShoppingCart: ((Bool) -> Void)?
    
    var selectedSize: ProductSize?
    var addedNewProduct: Bool
    
    weak var delegate: ProductDetailPresenterDelegate?
    
    init(product: ProductViewModel, shoppingCart: ProductShoppingCart) {//}, dataClient: DataClient) {
        self.viewModel = product
        self.shoppingCart = shoppingCart
        self.selectedSize = nil
        self.addedNewProduct = false
    }
    
    func selectSize(index: Int) {
        guard index >= 0 && index < viewModel.availableSizes.count else { return }
        self.selectedSize = viewModel.availableSizes[index]
        delegate?.onSizeSelect(index)
    }

    func addProductToCart() {
        guard let selectedSize = selectedSize else { return }
        let productToAdd = ShoppingCartProduct(product: viewModel.getUnderlyingModel(), selectedSize: selectedSize)
        addedNewProduct = shoppingCart.getTotalAmount(of: productToAdd) == 0
        shoppingCart.addItem(productToAdd)
    }
    
    func didFinishDismissingView() {
        self.shouldOpenShoppingCart?(addedNewProduct)
    }
}
