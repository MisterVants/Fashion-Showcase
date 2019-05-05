//
//  AppFonts.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func gothamBlack(_ fontSize: CGFloat) -> UIFont {
        let fontName = "Gotham-Black"
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font file not found in bundle for font \(fontName)") }
        return font
    }
    
    static func gothamBold(_ fontSize: CGFloat) -> UIFont {
        let fontName = "Gotham-Bold"
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font file not found in bundle for font \(fontName)") }
        return font
    }
    
    static func gothamMedium(_ fontSize: CGFloat) -> UIFont {
        let fontName = "Gotham-Medium"
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font file not found in bundle for font \(fontName)") }
        return font
    }
    
    static func gothamLight(_ fontSize: CGFloat) -> UIFont {
        let fontName = "Gotham-Light"
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font file not found in bundle for font \(fontName)") }
        return font
    }
    
    static func gothamThin(_ fontSize: CGFloat) -> UIFont {
        let fontName = "Gotham-Thin"
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font file not found in bundle for font \(fontName)") }
        return font
    }
}
