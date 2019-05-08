//
//  DiffHelpers.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 08/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Foundation

typealias SequenceDiff<T1, T2> = (common: [(T1, T2)], removed: [T1], inserted: [T2])

typealias IndexDiff = (removed: [IndexPath], inserted: [IndexPath])

func diff<T1, T2>(_ first: [T1], _ second: [T2], with compare: (T1,T2) -> Bool) -> SequenceDiff<T1, T2> {
    let combinations = first.compactMap { firstElement in (firstElement, second.first { secondElement in compare(firstElement, secondElement) }) }
    let common = combinations.filter { $0.1 != nil }.compactMap { ($0.0, $0.1!) }
    let removed = combinations.filter { $0.1 == nil }.compactMap { ($0.0) }
    let inserted = second.filter { secondElement in !common.contains { compare($0.0, secondElement) } }
    
    return SequenceDiff(common: common, removed: removed, inserted: inserted)
}

func computeIndexDiff<T>(itemsToDisplay: [T], currentItems: [T]) -> IndexDiff where T: Equatable {
    let itemsDiff = diff(currentItems, itemsToDisplay, with: ==)
    
    let removeIndexes: [IndexPath] = itemsDiff.removed
        .compactMap { currentItems.firstIndex(of: $0) }
        .map { IndexPath(row: $0, section: 0) }
    let insertIndexes: [IndexPath] = itemsDiff.inserted
        .compactMap { itemsToDisplay.firstIndex(of: $0) }
        .map { IndexPath(row: $0, section: 0) }
    
    return (removeIndexes, insertIndexes)
}
