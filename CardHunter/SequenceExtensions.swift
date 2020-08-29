//
//  SequenceExtensions.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import Foundation

extension Sequence {
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted {
            a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
