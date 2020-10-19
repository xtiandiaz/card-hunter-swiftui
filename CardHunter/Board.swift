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
    let collectibleRows: Int
    
    lazy var fieldSlots = slots(forType: .field).sorted(by: \.index)
    lazy var weaponsSlot = addSlot(withType: .inventory, index: 0, capacity: 10)
    lazy var collectibleSlots = slots(forType: .inventory).sorted(by: \.index)
    
    init(rows: Int, cols: Int, inventoryRows: Int) {
        self.rows = rows
        self.cols = cols
        self.collectibleRows = inventoryRows
        
        (0..<rows * cols).forEach {
            addSlot(withType: .field, index: $0, capacity: 2)
        }
        
        (0..<inventoryRows * cols).forEach {
            addSlot(withType: .inventory, index: $0, capacity: 2)
        }
        
        startSlot.pushCard(avatar)
        
        deal()
        
        setFogOfWar(atIndex: startSlot.index)
    }
    
    func tryMovingCard(_ card: Card, fromSlot origin: Slot, withPositionOffset offset: CGPoint) {
        guard
            let destination = slot(forPosition: origin.bounds.center + offset),
            destination.isEnabled, !destination.isLocked,
            destination != origin
        else {
            return
        }
        
        var didMove = false
        
        if destination.isEmpty {
            if destination.pushCard(card) {
                origin.popCard()
                didMove = true
            }
        } else if let target = destination.cards.first {
            if target.type == .weapon,
               weaponsSlot.pushCard(target)
            {
                destination.popCard()
                
                if destination.pushCard(card) {
                    origin.popCard()
                    didMove = true
                }
            } else if
                target.type == .item,
                let invSlot = firstFreeInventorySlot,
                invSlot.pushCard(target)
            {
                destination.popCard()
                
                if destination.pushCard(card) {
                    origin.popCard()
                    didMove = true
                }
            } else {
                target.apply(other: card)
                
                if target.isInvalidated, destination.pushCard(card) {
                    origin.popCard()
                    didMove = true
                }
            }
        }
        
        cleanUp()
        
        if didMove, card.type == .avatar {
            setFogOfWar(atIndex: destination.index)
            
            setTrail(toDestination: destination)
        }
    }
    
    func slot(forId id: UUID) -> Slot? {
        slotForId[id]
    }
    
    func slot(forIndex index: Int) -> Slot? {
        guard index >= 0, index < rows * cols else {
            return nil
        }
        return slotForIndex[.field]![index]
    }
    
    func slot(forLocation location: Location) -> Slot? {
        guard let index = index(forLocation: location) else {
            return nil
        }
        return slot(forIndex: index)
    }
    
    func slot(forPosition position: CGPoint) -> Slot? {
        slotForId.values.first {
            let origin = $0.bounds.origin
            let end = $0.bounds.end
            
            return position.x >= origin.x &&
                position.y >= origin.y &&
                position.x <= end.x &&
                position.y <= end.y
        }
    }
    
    // MARK: Private
    
    private let deck = Deck()
    private let avatar = AvatarCard(health: 10, attack: 10, defense: 0, wealth: 0)
    
    private var slotForId = [UUID: Slot]()
    private var slotForIndex = [SlotType: [Int: Slot]]()
    private lazy var trail: [Slot] = [startSlot]
    
    private var startSlot: Slot {
        slot(forLocation: Location(col: 2, row: 2))!
    }
    
    private var firstFreeInventorySlot: Slot? {
        collectibleSlots.first { $0.isEmpty }
    }
    
    private func deal() {
        fieldSlots.forEach {
            if $0.isEmpty, let card = deck.deal() {
                $0.pushCard(card)
            }
        }
    }
    
    private func setFogOfWar(atIndex index: Int) {
        avatar.locationIndex = index
        
        slots(forType: .field).forEach {
            $0.isLocked = true
        }
        
        guard let location = self.location(forIndex: index) else {
            return
        }
        
        slot(forLocation: location)?.isLocked = false
        slot(forLocation: location.oneUp())?.isLocked = false
        slot(forLocation: location.oneDown())?.isLocked = false
        slot(forLocation: location.oneLeft())?.isLocked = false
        slot(forLocation: location.oneRight())?.isLocked = false
    }
    
    private func setTrail(toDestination destination: Slot) {
        guard !deck.isEmpty else {
            return
        }
        
        if trail.contains(destination) {
            trail.reverse()
        } else {
            trail.append(destination)
        }
        
        print(trail.map { $0.index})
        
        if
            trail.count > 2,
            let origin = trail.first, origin.isEmpty,
            let card = deck.deal()
        {
            origin.pushCard(card)
            trail.remove(at: 0)
        }
    }
    
    private func cleanUp() {
        fieldSlots.forEach { $0.cleanUp() }
    }
    
    private func clear() {
        fieldSlots.forEach { $0.clear() }
    }
    
    @discardableResult
    private func addSlot(withType type: SlotType, index: Int, capacity: UInt) -> Slot {
        add(slot: Slot(index: index, type: type, capacity: capacity))
    }
    
    @discardableResult
    private func add(slot: Slot) -> Slot {
        slotForId[slot.id] = slot
        
        if slotForIndex[slot.type] == nil {
            slotForIndex[slot.type] = [:]
        }
        
        slotForIndex[slot.type]![slot.index] = slot
        
        return slot
    }
    
    private func slots(forType type: SlotType) -> [Slot] {
        slotForIndex[type]?.values.compactMap { $0 } ?? []
    }
}

// MARK: - Location

extension Board {
    
    struct Location {
        
        let col: Int
        let row: Int
        
        func oneUp() -> Location {
            Location(col: col, row: row + 1)
        }
        
        func oneDown() -> Location {
            Location(col: col, row: row - 1)
        }
        
        func oneRight() -> Location {
            Location(col: col + 1, row: row)
        }
        
        func oneLeft() -> Location {
            Location(col: col - 1, row: row)
        }
    }
    
    private func index(forLocation location: Location) -> Int? {
        guard isValid(location: location) else {
            return nil
        }
        return location.row * cols + location.col
    }
    
    private func location(forIndex index: Int) -> Location? {
        let col = index % cols
        let row = index / cols
        
        guard col < cols, row < rows else {
            return nil
        }
        return Location(col: col, row: row)
    }
    
    private func isValid(location: Location) -> Bool {
        location.col >= 0 && location.col < cols && location.row >= 0 && location.row < rows
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
                        board.slot(forId: $0.id)?.bounds = proxy[$0.bounds]
                    }
                }
                return Color.clear
            }
        }
    }
}
