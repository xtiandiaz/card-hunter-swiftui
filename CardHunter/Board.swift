//
//  Board.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

class Board: ObservableObject {
    
    let rows: Int
    let cols: Int
    let inventoryRows: Int
    
    lazy var fieldSlots: [Slot] = slots(for: .field)
    lazy var inventorySlots: [Slot] = slots(for: .inventory)
    
    init(rows: Int, cols: Int, inventoryRows: Int) {
        self.rows = rows
        self.cols = cols
        self.inventoryRows = inventoryRows
        
        (0..<rows * cols).forEach { _ in
            add(slot: Slot(type: .field, capacity: 2))
        }
        
        (0..<inventoryRows * cols).forEach { _ in
            add(slot: Slot(type: .inventory, capacity: 1))
        }
        
        self[1, 1]?.pushCard(AvatarCard(health: 10, attack: 10, defense: 0, wealth: 0))
        
        fieldSlots.forEach {
            if $0.isEmpty, let card = deck.deal() {
                $0.pushCard(card)
            }
        }
    }
    
    subscript(slotId: UUID) -> Slot? {
        slotDict[slotId]
    }
    
    subscript(col: Int, row: Int) -> Slot? {
        fieldSlots[row * cols + col]
    }
    
    func tryMovingCard(_ card: Card, fromSlot origin: Slot, withPositionOffset offset: CGPoint) {
        guard
            let destination = slotForPosition(origin.bounds.center + offset),
            destination != origin
        else {
            return
        }
        
        if destination.isEmpty {
            if destination.pushCard(card) {
                origin.popCard()
            }
        } else if let target = destination.cards.first {
            target.apply(other: card)
            
            if target.isInvalidated, destination.pushCard(card) {
                origin.popCard()
            }
        }
        
        cleanUp()
    }
    
    func slotForPosition(_ position: CGPoint) -> Slot? {
        slotDict.values.first {
            let origin = $0.bounds.origin
            let end = $0.bounds.end
            
            return position.x >= origin.x && position.y >= origin.y &&
                position.x <= end.x && position.y <= end.y
        }
    }
    
    // MARK: Private
    
    private let deck = Deck()
    
    private var slotDict = [UUID: Slot]()
    
    private func cleanUp() {
        fieldSlots.forEach { $0.cleanUp() }
    }
    
    private func add(slot: Slot) {
        slotDict[slot.id] = slot
    }
    
    private func slots(for type: SlotType) -> [Slot] {
        slotDict.compactMap { $0.value }.filter { $0.type == type }
    }
}

struct BoundsPreference {
    
    let id: UUID
    let bounds: Anchor<CGRect>
}

struct SlotBoundsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [BoundsPreference] = []
    
    static func reduce(value: inout [BoundsPreference], nextValue: () -> [BoundsPreference]) {
        return value.append(contentsOf: nextValue())
    }
}

extension View {
    
    func anchorBounds(forSlotId slotId: UUID) -> some View {
        self.anchorPreference(key: SlotBoundsPreferenceKey.self, value: .bounds) {
            [BoundsPreference(id: slotId, bounds: $0)]
        }
    }
    
    func resolveLayout(forBoard board: Board) -> some View {
        self.backgroundPreferenceValue(SlotBoundsPreferenceKey.self) {
            prefs in
            GeometryReader {
                proxy -> Color in
                DispatchQueue.main.async {
                    prefs.compactMap { $0 }.forEach {
                        board[$0.id]?.bounds = proxy[$0.bounds]
                    }
                }
                return Color.clear
            }
        }
    }
}
