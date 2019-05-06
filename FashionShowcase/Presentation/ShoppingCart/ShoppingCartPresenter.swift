//
//  ShoppingCartPresenter.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ShoppingCartPresenterDelegate: AnyObject {
    func onPromptToDeleteItem(shouldDelete: @escaping (Bool) -> Void)
    func onItemDeleted(at indexPath: IndexPath)
}

protocol ShoppingCartPresenter {
    var numberOfCartItems: Int {get}
    func cartItemViewModel(for indexPath: IndexPath) -> ShoppingCartProductViewModel?
}

class ShoppingCartViewPresenter: ShoppingCartPresenter, ShoppingCartProductViewModelDelegate {
    
    let shoppingCart: ProductShoppingCart
    
    var productsInCart: [ShoppingCartProductViewModel]
    
    weak var delegate: ShoppingCartPresenterDelegate?
    
    init(shoppingCart: ProductShoppingCart, factory: ViewModelFactory) {
        self.shoppingCart = shoppingCart
        self.productsInCart = shoppingCart.items
            .sorted(by: { $0.product.name < $1.product.name })
            .map {
            let amount = shoppingCart.getTotalAmount(of: $0)
            return factory.makeShoppingCartProductViewModel(from: $0, quantity: amount)
        }
        
        self.productsInCart.forEach {
            var viewModel = $0
            viewModel.delegate = self
        }
    }
    
    var numberOfCartItems: Int {
        return shoppingCart.count
    }
    
    func cartItemViewModel(for indexPath: IndexPath) -> ShoppingCartProductViewModel? {
        guard indexPath.row >= 0 && indexPath.row < productsInCart.count else { return nil }
        return productsInCart[indexPath.row]
    }
    
    func shouldChangeQuantityOf(_ cartProduct: ShoppingCartProduct, to newQuantity: Int) -> Bool {
        if newQuantity > shoppingCart.getTotalAmount(of: cartProduct) {
            return shouldIncrement(cartProduct, to: newQuantity)
        } else {
            return shouldDecrement(cartProduct, to: newQuantity)
        }
    }
    
    private func shouldIncrement(_ cartProduct: ShoppingCartProduct, to newQuantity: Int) -> Bool {
        if newQuantity <= shoppingCart.capacityPerItem {
            shoppingCart.addItem(cartProduct)
            return true
        } else {
            return false
        }
    }
    
    private func shouldDecrement(_ cartProduct: ShoppingCartProduct, to newQuantity: Int) -> Bool {
        if newQuantity > 0 {
            shoppingCart.removeItem(cartProduct)
            return true
        } else {
            delegate?.onPromptToDeleteItem(shouldDelete: { shouldDelete in
                if shouldDelete {
                    guard let productIndex = self.productsInCart.firstIndex(where: { $0.matches(cartProduct) }) else { return }
                    let deletedIndexPath = IndexPath(row: productIndex, section: 0)
                    self.shoppingCart.removeItem(cartProduct)
                    self.productsInCart.remove(at: productIndex)
                    self.delegate?.onItemDeleted(at: deletedIndexPath)
                }
            })
            return false
        }
    }
}
