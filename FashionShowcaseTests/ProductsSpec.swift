//
//  ProductsSpec.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Quick
import Nimble

@testable import FashionShowcase

class ProductsSpec: QuickSpec {

    override func spec() {
        
        var products: [Product] = []
        
        beforeSuite {
            products = ProductsAPIStub().mockProducts() ?? []
        }
        
        describe("Products") {
            it("is correctly decoded from raw data") {
                expect(products).toNot(beEmpty())
            }
            
            describe("price values") {
                it("formatter should successfully convert the price string") {
                    expect(products.first?.actualPriceValue).notTo(beNil())
                    expect(products.first?.regularPriceValue).notTo(beNil())
                }
            }
        }
    }
}
