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
    func updateCollection(adding insertIndexes: [IndexPath], remove removeIndexes: [IndexPath])
}

protocol ShowcasePresenter {
    var navigationTitle: String {get}
    var segmentSections: [(title: String, index: Int)] {get}
    var currentSegmentIndex: Int {get}
    var numberOfDisplayedItems: Int {get}
    func productViewModel(for indexPath: IndexPath) -> ProductViewModel?
    func selectedItem(at indexPath: IndexPath)
    func changeDisplaySegment(_ value: Int)
    func openShoppingCart()
    func loadShowcase()
}

class ShowcaseViewPresenter: ShowcasePresenter {
    
    enum DisplaySegment: Int, CaseIterable {
        case all = 0
        case onSale
        
        var title: String {
            switch self {
            case .all: return "Tudo"
            case .onSale: return "Em Oferta"
            }
        }
    }
    
    let api: ProductsAPI
    let catalogue: ProductCatalogue
    let factory: ViewModelFactory
    
    var didSelectProduct: ((ProductViewModel) -> Void)?
    var didOpenShoppingCart: (() -> Void)?
    
    var displayedProducts: [ProductViewModel] = []
    var allProducts: [ProductViewModel] = []
    var isLoading: Bool
    var currentSegment: DisplaySegment
    
    weak var delegate: ShowcasePresenterDelegate?
    
    init(catalogue: ProductCatalogue, api: ProductsAPI, factory: ViewModelFactory) {
        self.api = api
        self.catalogue = catalogue
        self.factory = factory
        self.isLoading = false
        self.currentSegment = .all
    }
    
    var navigationTitle: String {
        return "LOJA"
    }
    
    var segmentSections: [(title: String, index: Int)] {
        return DisplaySegment.allCases.map { ($0.title, $0.rawValue) }
    }
    
    var currentSegmentIndex: Int {
        return currentSegment.rawValue
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
    
    func changeDisplaySegment(_ value: Int) {
        guard let segment = DisplaySegment(rawValue: value) else { return }
        
        let currentDisplayedItems = displayedProducts
        let itemsToDisplay = filterProducts(allProducts, by: segment)
        let indexDiff = computeIndexDiff(itemsToDisplay: itemsToDisplay.map { $0.getUnderlyingModel() }, currentItems: currentDisplayedItems.map { $0.getUnderlyingModel() })
        
        displayedProducts = itemsToDisplay
        delegate?.updateCollection(adding: indexDiff.inserted, remove: indexDiff.removed)
    }
    
    func loadShowcase() {
        
        if let products = catalogue.getProducts() {
            setViewModels(from: products)
            delegate?.onLoadFinish()
            delegate?.onLoadSuccess()
        } else {
            guard !isLoading else { return }
            isLoading = true
            
            catalogue.loadProducts(from: api) { [weak self] result in
                self?.isLoading = false
                
                switch result {
                case .success(let loadedProducts):
                    self?.setViewModels(from: loadedProducts)
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
    
    private func setViewModels(from products: [Product]) {
        let productsViewModels = products.compactMap { self.factory.makeProductViewModel(from: $0) }
        allProducts = productsViewModels
        displayedProducts = filterProducts(productsViewModels, by: currentSegment)
    }
    
    private func filterProducts(_ products: [ProductViewModel], by segment: DisplaySegment) -> [ProductViewModel] {
        switch segment {
        case .all: return products
        case .onSale: return products.filter { $0.isProductOnSale }
        }
    }
}
