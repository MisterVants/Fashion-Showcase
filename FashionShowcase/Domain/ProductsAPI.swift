//
//  ProductsAPI.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol ProductsAPI {
    func fetchProducts(completion: @escaping (Result<[Product], FSError>) -> Void)
}

class APIWrapper: ProductsAPI {
    
    enum Endpoint: String {
        case productsMock = "/v2/59b6a65a0f0000e90471257d"
        // As the API grows, add more endpoints
    }
    private let urlScheme = "https"
    private let hostName = "www.mocky.io"
    
    let client: NetworkClient
    
    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], FSError>) -> Void) {
        guard let productsUrl = endpointUrl(for: .productsMock) else {
            completion(.failure(FSError.malformedURL))
            return
        }
        client.get(ProductsDto.self, url: productsUrl) { result in
            completion(result.map { $0.products })
        }
    }
    
    private func endpointUrl(for endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = urlScheme
        urlComponents.host = hostName
        urlComponents.path = endpoint.rawValue
        return urlComponents.url
    }
}
