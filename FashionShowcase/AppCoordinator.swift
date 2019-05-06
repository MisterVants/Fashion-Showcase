//
//  AppCoordinator.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

protocol Coordinator {
    var rootViewController: UIViewController {get}
    func start()
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let navigationController: UINavigationController
    
    let viewModelFactory: ViewModelFactory
    let productsCatalogue: ProductCatalogue
    let productsApi: ProductsAPI
    let networkClient: NetworkClient
    var shoppingCart: ProductShoppingCart
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        self.productsCatalogue = ProductDataStore()
        self.networkClient = NetworkClient()
        self.productsApi = APIWrapper(client: networkClient)
        self.viewModelFactory = ViewModelFactory(dataClient: networkClient)
        self.shoppingCart = ProductShoppingCart()
    }
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        navigationController.pushViewController(makeRootViewController(), animated: false)
    }
}

extension AppCoordinator {
    
    func didSelectProduct(_ viewModel: ProductViewModel) {
        let detailViewController = makeProductDetailViewController(viewModel)
        navigationController.present(detailViewController, animated: true, completion: nil)
    }
    
    func shouldOpenShoppingCart() {
        let shoppingCartViewController = makeShoppingCartViewController()
        navigationController.pushViewController(shoppingCartViewController, animated: true)
    }
    
    func didAddProductToCart(isNew: Bool) {
        
    }
}

extension AppCoordinator {
    
    func makeRootViewController() -> UIViewController {
        let viewController = ShowcaseViewController()
        let presenter = ShowcaseViewPresenter(catalogue: productsCatalogue, api: productsApi, factory: viewModelFactory)
        viewController.presenter = presenter
        presenter.delegate = viewController
        presenter.didOpenShoppingCart = { [unowned self] in
            self.shouldOpenShoppingCart()
        }
        presenter.didSelectProduct = { [unowned self] in
            self.didSelectProduct($0)
        }
        return viewController
    }
    
    func makeProductDetailViewController(_ viewModel: ProductViewModel) -> UIViewController {
        let viewController = ProductDetailViewController()
        let presenter = ProductDetailViewPresenter(product: viewModel)
        viewController.presenter = presenter
        presenter.shouldOpenShoppingCart = { [unowned self] in
            self.shouldOpenShoppingCart()
        }
        return viewController
    }
    
    func makeShoppingCartViewController() -> UIViewController {
        let viewController = ShoppingCartViewController()
        let presenter = ShoppingCartViewPresenter(shoppingCart: shoppingCart)
        viewController.presenter = presenter
        
        return viewController
    }
}
