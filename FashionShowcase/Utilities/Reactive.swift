//
//  Reactive.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

class Reactive<T> {
    
    var value: T {
        didSet {
            self.valueChanged?(self.value)
        }
    }
    
    private var valueChanged : ((T)->())?
    
    init(_ v: T) {
        value = v
    }
    
    func bind(_ block: ((T)->())?) {
        self.valueChanged = block
    }
    
    func bindAndUpdate(_ block: ((T)->())?) {
        self.valueChanged = block
        self.valueChanged?(value)
    }
    
    func free() {
        self.valueChanged = nil
    }
}
