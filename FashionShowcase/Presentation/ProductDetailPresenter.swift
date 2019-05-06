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
    func didFinishDismissingView()
}

class ProductDetailViewPresenter: ProductDetailPresenter {
    
    let viewModel: ProductViewModel
    
    var shouldOpenShoppingCart: (() -> Void)?
    
    init(product: ProductViewModel) {//}, dataClient: DataClient) {
        self.viewModel = product
        
    }

    func addProductToCart() {
        
    }
    
    func didFinishDismissingView() {
        self.shouldOpenShoppingCart?()
    }
}
