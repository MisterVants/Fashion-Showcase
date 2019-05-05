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
    }
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        navigationController.pushViewController(makeRootViewController(), animated: false)
    }
}

extension AppCoordinator {
    
    func makeRootViewController() -> UIViewController {
        let viewController = ShowcaseViewController()
        let presenter = ShowcaseViewPresenter(catalogue: productsCatalogue, api: productsApi, factory: viewModelFactory)
        viewController.presenter = presenter
        presenter.delegate = viewController
        presenter.didOpenShoppingCart = { //[unowned self] in
            print("open shop cart")
        }
        presenter.didSelectProduct = {
            print("selected product")
        }
        return viewController
    }
}
