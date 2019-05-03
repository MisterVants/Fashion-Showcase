//
//  FSError.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

enum FSError: Error {
    case networkError(Error)
    case noResponse
    case badStatusCode(Int)
    case inputDataNil
    case jsonDecodeFailed(Error)
}

extension FSError {
    
    var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
    
    var isNoResponseError: Bool {
        if case .noResponse = self { return true }
        return false
    }
    
    var isBadStatusCodeError: Bool {
        if case .badStatusCode = self { return true }
        return false
    }
    
    var isNilDataError: Bool {
        if case .inputDataNil = self { return true }
        return false
    }
}
