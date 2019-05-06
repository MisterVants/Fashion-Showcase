//
//  ShoppingCartProductViewModel.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 06/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ShoppingCartProductViewModel {
    var productName: String {get}
    var productPrice: String {get}
    var supplementaryPrice: NSAttributedString? {get}
    var productImageData: Reactive<Data?> {get}
    func loadProductImage()
}
