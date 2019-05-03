//
//  File.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

@testable import FashionShowcase

class ProductsAPIStub: ProductsAPI {
    
    func fetchProducts(completion: @escaping (Result<[Product], FSError>) -> Void) {
        if let products = mockProducts() {
            completion(.success(products))
        }
    }
    
    func mockProducts() -> [Product]? {
        if let path = Bundle(for: ProductsAPIStub.self).path(forResource: "ProductsDtoStub", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let fileData = try Data(contentsOf: fileUrl, options: .uncached)
                let decodedData = try JSONDecoder().decode(ProductsDto.self, from: fileData)
                return decodedData.products
            } catch {
                print("[ProductsAPIStub] Failed to read local test data: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func mockDecodableData() -> Data? {
        if let path = Bundle(for: ProductsAPIStub.self).path(forResource: "ProductsDtoStub", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let fileData = try Data(contentsOf: fileUrl, options: .uncached)
                return fileData
            } catch {
                print("[ProductsAPIStub] Failed to read local test data: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
