//
//  URLSession+Protocols.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
