//
//  URLSessionMock.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation
@testable import FashionShowcase

class URLSessionMock: URLSessionProtocol {
    
    var taskData: Data?
    var taskResponse: HTTPURLResponse?
    var taskError: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        
        let data = self.taskData
        let response = self.taskResponse
        let error = self.taskError
        
        return URLSessionDataTaskMock(completion: {
            completionHandler(data, response, error)
        })
    }
}
