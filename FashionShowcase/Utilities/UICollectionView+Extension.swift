//
//  UICollectionView+Extension.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 04/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable collection view cell")
        }
        return cell
    }
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(uiNibForType cellClass: T.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: cellClass.reuseIdentifier, bundle: bundle), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath) -> T? {
        return cellForItem(at: indexPath) as? T
    }
}
