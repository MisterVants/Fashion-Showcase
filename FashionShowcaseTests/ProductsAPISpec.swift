//
//  ProductsAPISpec.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 03/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Quick
import Nimble

@testable import FashionShowcase

class ProductsAPISpec: QuickSpec {
    
    override func spec() {
        
        var api: ProductsAPI!
        
        var client: NetworkClient!
        var sessionMock: URLSessionMock!
        
        beforeEach {
            sessionMock = URLSessionMock()
            client = NetworkClient(session: sessionMock)
            client.clearCache()
            api = APIWrapper(client: client)
        }
        
        describe("fetch products") {
            
            it("should return an array of products") {
                sessionMock.taskResponse = HTTPURLResponse(url: URL(string: "https://httpbin.org/get")!, statusCode: 200, httpVersion: nil, headerFields: nil)
                sessionMock.taskData = ProductsAPIStub().mockDecodableData()
                
                waitUntil { done in
                    api.fetchProducts(completion: { result in
                        let products = try? result.get()
                        expect(products).notTo(beNil())
                        done()
                    })
                }
            }
        }
    }
}
