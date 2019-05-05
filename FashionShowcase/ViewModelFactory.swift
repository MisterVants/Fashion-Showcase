//
//  ViewModelFactory.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

class ViewModelFactory {
    
    let sharedClient: DataClient
    
    init(dataClient: DataClient) {
        self.sharedClient = dataClient
    }
    
    func makeProductViewModel(from product: Product) -> ProductViewModel {
        let viewModel = Product.ViewModel(from: product, dataClient: sharedClient)
        return viewModel
    }
}
