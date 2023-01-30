//
//  Slot.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

enum SlotType: Equatable, Hashable {
    
    case spacer
    case trigger(event: BoardEvent)
    case field
    case inventory
}

class Slot: ObservableObject, Identifiable {
    
    let id: UUID
    let index: Int
    let type: SlotType
    let capacity: Int
    
    var bounds = CGRect.zero
    
    var topCard: GameCard? {
        cards.first
    }
    
    var proximityFactor: Double = 1.0 {
        didSet {
            cards.forEach {
                $0.style.lightness = proximityFactor
            }
        }
    }
    
    var isLocked = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    var zIndex = Double(0) {
        didSet {
            print(zIndex)
            objectWillChange.send()
        }
    }
    
    var cards = [GameCard]()
    
    init(index: Int, type: SlotType, capacity: UInt) {
        self.id = UUID()
        self.index = index
        self.type = type
        self.capacity = Int(capacity)
    }
    
    var isEnabled: Bool {
        type != .spacer
    }
    
    var isEmpty: Bool {
        cards.isEmpty
    }
    
    var isActionable: Bool {
        guard !isLocked, let topCard = topCard else {
            return false
        }
        
        return topCard is Movable
    }
    
    var cardMask: CardType {
        switch type {
        case .inventory:
            return [.item, .weapon]
        default:
            return []
        }
    }
    
    @discardableResult
    func popCard() -> Bool {
//        guard !isLocked else {
//            print("\(self) is locked; cards can't be popped from it!")
//            return false
//        }
        
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
    func pushCard(_ card: GameCard) -> Bool {
        guard cardMask.isEmpty || cardMask.contains(card.type) else {
            print("\(self) doesn't accept cards of type \(card.type)")
            return false
        }
        
//        guard !isLocked else {
//            print("\(self) is locked; cards can't be pushed into it!")
//            return false
//        }
        
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
    
    func clear() {
        cards.removeAll()
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

// MARK: - Appearance

extension Slot {
    
    static let aspectRatio: CGFloat = 5 / 6
    static let interitemSpacing: CGFloat = 8
    static let stackedCardOffset: CGFloat = 4
    
    var content: CardContent {
        switch type {
        case .trigger(let event):
            switch event {
            case .attack(let direction):
                switch direction {
                case .up: return .systemIcon(name: "chevron.up")
                case .right: return .systemIcon(name: "chevron.right")
                case .left: return .systemIcon(name: "chevron.left")
                case .down: return .systemIcon(name: "chevron.down")
                default: return .none
                }
            }
        default: return .none
        }
    }
}

// MARK: - Templates

extension Slot {
    
    static var spacer: Slot {
        Slot(index: 0, type: .spacer, capacity: 0)
    }
    
    static func trigger(forEvent event: BoardEvent) -> Slot {
        Slot(index: 0, type: .trigger(event: event), capacity: 1)
    }
}
