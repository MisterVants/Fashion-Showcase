//
//  ProductsCatalogueSpec.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 03/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Quick
import Nimble

@testable import FashionShowcase

class ProductsCatalogueSpec: QuickSpec {

    override func spec() {
        
        var catalogue: ProductCatalogue!
        
        beforeEach {
            catalogue = ProductDataStore()
        }
        
        describe("init") {
            it("should start empty") {
                expect(catalogue.getProducts()).to(beNil())
            }
        }
        
        describe("load products") {
            it("should store loaded products") {
                let api = ProductsAPIStub()
                waitUntil { done in
                    catalogue.loadProducts(from: api, completion: { _ in
                        expect(catalogue.getProducts()).notTo(beNil())
                        done()
                    })
                }
            }
        }
    }

}
