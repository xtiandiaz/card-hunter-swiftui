//
//  Slot.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

class Slot: ObservableObject, Identifiable {
    
    let id: Int
    let capacity: Int
    
    var bounds = CGRect.zero
    var isLocked: Bool = false
    
    var cards = [Card]()
    
    init(id: Int, capacity: UInt) {
        self.id = id
        self.capacity = Int(capacity)
    }
    
    var isEmpty: Bool {
        cards.isEmpty
    }
    
    @discardableResult
    func popCard() -> Bool {
        guard !isLocked else {
            print("\(self) is locked; cards can't be popped from it!")
            return false
        }
        
        guard !isEmpty else {
            print("\(self) is empty; no cards can be popped from it!")
            return false
        }
        
        objectWillChange.send()
        
        cards.remove(at: 0)
        sort()
        
        return true
    }
    
    @discardableResult
    func pushCard(_ card: Card) -> Bool {
        guard !isLocked else {
            print("\(self) is locked; cards can't be pushed into it!")
            return false
        }
        
        guard cards.count < capacity else {
            print("\(self) is full; no more cards can be pushed into it!")
            return false
        }
        
        objectWillChange.send()
        
        cards.insert(card, at: 0)
        sort()
        
        return true
    }
    
    // MARK: Private
    
    private func sort() {
        cards.enumerated().forEach {
            $0.element.stackIndex = $0.offset
        }
    }
}
