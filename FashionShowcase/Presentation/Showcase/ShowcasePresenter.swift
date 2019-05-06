//
//  ShowcasePresenter.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ShowcasePresenterDelegate: AnyObject {
    func onLoadFinish()
    func onLoadSuccess()
    func onAlertableError(_ title: String, message: String)
}

protocol ShowcasePresenter {
    var numberOfDisplayedItems: Int {get}
    func productViewModel(for indexPath: IndexPath) -> ProductViewModel?
    func selectedItem(at indexPath: IndexPath)
    func openShoppingCart()
    func loadShowcase()
}

class ShowcaseViewPresenter: ShowcasePresenter {
    
    let api: ProductsAPI
    let catalogue: ProductCatalogue
    let factory: ViewModelFactory
    
    var didSelectProduct: ((ProductViewModel) -> Void)?
    var didOpenShoppingCart: (() -> Void)?
    
    var displayedProducts: [ProductViewModel] = []
//    var allProducts: [ProductViewModel] = []
    var isLoading: Bool
    
    weak var delegate: ShowcasePresenterDelegate?
    
    init(catalogue: ProductCatalogue, api: ProductsAPI, factory: ViewModelFactory) {
        self.api = api
        self.catalogue = catalogue
        self.factory = factory
        self.isLoading = false
    }
    
    var numberOfDisplayedItems: Int {
        return displayedProducts.count
    }
    
    func productViewModel(for indexPath: IndexPath) -> ProductViewModel? {
        guard indexPath.row >= 0 && indexPath.row < displayedProducts.count else { return nil }
        return displayedProducts[indexPath.row]
    }
    
    func selectedItem(at indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < displayedProducts.count else { return }
        didSelectProduct?(displayedProducts[indexPath.row])
    }
    
    func openShoppingCart() {
        didOpenShoppingCart?()
    }
    
    func loadShowcase() {
        
        if let products = catalogue.getProducts() {
            displayedProducts = products.compactMap { self.factory.makeProductViewModel(from: $0) }
            delegate?.onLoadFinish()
            delegate?.onLoadSuccess()
        } else {
            guard !isLoading else { return }
            isLoading = true
            
            catalogue.loadProducts(from: api) { [weak self] result in
                self?.isLoading = false
                
                switch result {
                case .success(let loadedProducts):
                    self?.displayedProducts = loadedProducts.compactMap { self?.factory.makeProductViewModel(from: $0) }
                    self?.delegate?.onLoadSuccess()
                case .failure(let error):
                    self?.handleFetchError(error)
                }
                self?.delegate?.onLoadFinish()
            }
        }
    }
    
    func handleFetchError(_ error: Error) {
        print("Fetch error: \(error)")
        if let error = error as? FSError {
            if error.isNetworkError {
                self.delegate?.onAlertableError("Could not load data", message: error.localizedDescription)
            }
            if case .badStatusCode(let statusCode) = error {
                print("Products request returned with bad status code: \(statusCode.description)")
                self.delegate?.onAlertableError("Could not load data", message: "Please try again later") // count error
            }
        }
    }
}
