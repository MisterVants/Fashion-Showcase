//
//  IntegrationTests.swift
//  IntegrationTests
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import XCTest
@testable import FashionShowcase

class IntegrationTests: XCTestCase {

    private let realTimeout: TimeInterval = 10

    func testFetchProducts_fromMockAPI() {
        let expectation = self.expectation(description: "Fetch request should succeed")
        let api = APIWrapper()
        var products: [Product]?
        
        api.fetchProducts { result in
            products = try? result.get()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: realTimeout, handler: nil)
        XCTAssertNotNil(products, "An API request should return a valid and decoded object model")
    }
}
