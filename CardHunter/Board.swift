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
    
    lazy var slots: [Slot] = slotDict.compactMap { $0.value }.sorted(by: \.id)
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        (0..<rows * cols).forEach {
            slotDict[$0] = Slot(id: $0, capacity: 2)
        }
        
        self[1, 2]?.pushCard(AvatarCard(health: 10, attack: 10, defense: 0, wealth: 0))
        
        slots.forEach {
            if $0.isEmpty, let card = deck.deal() {
                $0.pushCard(card)
            }
        }
    }
    
    subscript(slotId: Int) -> Slot? {
        slotDict[slotId]
    }
    
    subscript(col: Int, row: Int) -> Slot? {
        slots[row * cols + col]
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
        slots.first {
            let origin = $0.bounds.origin
            let end = $0.bounds.end
            
            return position.x >= origin.x && position.y >= origin.y &&
                position.x <= end.x && position.y <= end.y
        }
    }
    
    // MARK: Private
    
    private let deck = Deck()
    
    private var slotDict = [Int: Slot]()
    
    private func cleanUp() {
        slots.forEach { $0.cleanUp() }
    }
}

struct BoundsPreference {
    
    let id: Int
    let bounds: Anchor<CGRect>
}

struct SlotBoundsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [BoundsPreference] = []
    
    static func reduce(value: inout [BoundsPreference], nextValue: () -> [BoundsPreference]) {
        return value.append(contentsOf: nextValue())
    }
}

extension View {
    
    func anchorBounds(forSlotId slotId: Int) -> some View {
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
