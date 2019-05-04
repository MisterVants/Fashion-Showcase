//
//  PriceFormatter.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 04/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

class PriceFormatter {
    
    static let `default` = PriceFormatter()
    
    let numberFormatter: NumberFormatter
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
    }
    
    func number(from string: String) -> Double? {
        let cleanString = string.replacingOccurrences(of: " ", with: "")
        return numberFormatter.number(from: cleanString)?.doubleValue
    }
}
