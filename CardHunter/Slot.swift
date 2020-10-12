//
//  Slot.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

enum SlotType {
    
    case field
    case inventory
}

class Slot: ObservableObject, Identifiable {
    
    let id: UUID
    let index: Int
    let type: SlotType
    let capacity: Int
    
    var bounds = CGRect.zero
    
    var isLocked = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    var cards = [Card]()
    
    init(index: Int, type: SlotType, capacity: UInt) {
        self.id = UUID()
        self.index = index
        self.type = type
        self.capacity = Int(capacity)
    }
    
    var cardMask: CardType {
        switch type {
        case .inventory:
            return .item
        default:
            return []
        }
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
        guard cardMask.isEmpty || cardMask.contains(card.type) else {
            print("\(self) doesn't accept cards of type \(card.type)")
            return false
        }
        
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
    
    func cleanUp() {
        for (index, card) in cards.enumerated().reversed() {
            if card.isInvalidated {
                cards.remove(at: index)
            }
        }
    }
    
    // MARK: Private
    
    private func sort() {
        cards.enumerated().forEach {
            $0.element.stackIndex = $0.offset
        }
    }
}

extension Slot: Equatable {
    
    static func == (lhs: Slot, rhs: Slot) -> Bool {
        lhs.id == rhs.id
    }
}
