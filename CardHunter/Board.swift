//
//  Board.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

class Board: ObservableObject {
    
    let rows = 4
    let cols = 3
    
    lazy var slots: [Slot] = slotDict.compactMap { $0.value }.sorted(by: \.id)
    
    init() {
        (0..<12).forEach {
            slotDict[$0] = Slot(id: $0, capacity: 1)
        }
        
        self[1, 2]?.pushCard(AvatarCard.produce(withValue: 10))
    }
    
    subscript(slotId: Int) -> Slot? {
        slotDict[slotId]
    }
    
    subscript(col: Int, row: Int) -> Slot? {
        slots[row * cols + col]
    }
    
    func tryMovingCard(_ card: Card, fromSlot origin: Slot, withPositionOffset offset: CGPoint) {
        if
            let destination = slotForPosition(origin.bounds.center + offset),
            origin.popCard()
        {
            destination.pushCard(card)
        }
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
    
    private var slotDict = [Int: Slot]()
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
