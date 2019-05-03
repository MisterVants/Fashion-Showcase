//
//  URLSessionDataTaskMock.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation
@testable import FashionShowcase

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func resume() {
        DispatchQueue.main.async {
            self.completion()
        }
    }
}
