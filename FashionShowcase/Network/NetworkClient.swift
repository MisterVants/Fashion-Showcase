//
//  NetworkClient.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

class NetworkClient {
    
    private let session: URLSessionProtocol
    private let cache: URLCache
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
        self.cache = URLCache(memoryCapacity: 5 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
    }
    
    func getData(at url: URL, completion: @escaping (Result<Data, FSError>) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let cachedResponse = cache.cachedResponse(for: urlRequest) {
            completion(.success(cachedResponse.data))
        } else {
            let dataTask = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
                let taskResult = self.checkoutResponse(data, urlResponse, error)
                if case let .success(validData) = taskResult, let response = urlResponse {
                    let cachedResponse = CachedURLResponse(response: response, data: validData)
                    self.cache.storeCachedResponse(cachedResponse, for: urlRequest)
                }
                completion(taskResult)
            }
            dataTask.resume()
        }
    }
    
    func clearCache() {
        cache.removeAllCachedResponses()
    }
    
    private func checkoutResponse(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Result<Data, FSError> {
        if let error = error {
            return .failure(FSError.networkError(error))
        }
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            return .failure(FSError.noResponse)
        }
        guard HTTPStatusCode.isSuccess(urlResponse.statusCode) else {
            return .failure(FSError.badStatusCode(urlResponse.statusCode))
        }
        guard let validData = data else {
            return .failure(FSError.inputDataNil)
        }
        return .success(validData)
    }
}
