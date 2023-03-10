//
//  GameBoard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

enum BoardEvent: Equatable, Hashable {
    
    case attack(direction: Direction)
}

class GameBoard: ObservableObject {
    
    let rows: Int
    let cols: Int
    let collectibleRows: Int
    
    lazy var fieldSlots = slots(forType: .field).sorted(by: \.index)
    lazy var weaponSlot = addSlot(withType: .inventory, index: 0, capacity: 10)
    lazy var collectibleSlots = slots(forType: .inventory).sorted(by: \.index)
    
    @Published var avatarLocation: Location
    @Published var boardOffset: CGSize
    
    init(rows: Int, cols: Int, inventoryRows: Int) {
        self.rows = rows
        self.cols = cols
        self.collectibleRows = inventoryRows
        
        center = Location(col: cols / 2, row: rows / 2)
        startLocation = center
        avatarLocation = startLocation
        boardOffset = .zero
        
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
    
    func tryMovingCard(fromSlot origin: Slot, toward direction: Direction) -> Move? {
        guard
            let start = location(forIndex: origin.index),
            let destination = self.slot(forLocation: start.oneToward(direction: direction))
        else {
            return nil
        }
        
        return tryMovingCard(from: origin, to: destination)
    }
    
    func tryMovingCard(from origin: Slot, withPositionOffset offset: CGPoint) -> Move? {
        guard
            let destination = slot(forPosition: origin.bounds.center + offset),
            destination.isEnabled, !destination.isLocked,
            destination != origin
        else {
            return nil
        }
        
        return tryMovingCard(from: origin, to: destination)
    }
    
    // MARK: Private
    
    private let deck = GameDeck()
    private let avatar = AvatarCard(health: 10, attack: 10, defense: 0, wealth: 0)
    private let center: Location
    private let startLocation: Location
    
    private lazy var moveController = MoveController(inventoryController: inventoryController)
    private lazy var inventoryController = InventoryController(weaponSlot: weaponSlot)
    
    private var slotForId = [UUID: Slot]()
    private var slotForIndex = [SlotType: [Int: Slot]]()
    private lazy var trail: [Slot] = [startSlot]
    
    
    private var startSlot: Slot {
        slot(forLocation: startLocation)!
    }
    
    private var firstFreeInventorySlot: Slot? {
        collectibleSlots.first { $0.isEmpty }
    }
    
    private func deal() {
        fieldSlots.forEach {
            if $0.isEmpty, let card = deck.deal()/*, Double.random(in: 0...1) > 0.5*/ {
                $0.pushCard(card)
            }
        }
    }
    
    private func tryMovingCard(from origin: Slot, to destination: Slot) -> Move? {
        let move = moveController.resolve(from: origin, to: destination)
        
        cleanUp()
        
        if move != nil {
            avatarLocation = location(forIndex: destination.index)!
            
            withAnimation(.easeIn) {
                boardOffset = CGSize(
                    width: CGFloat(center.col - avatarLocation.col) * (startSlot.bounds.width + Slot.interitemSpacing),
                    height: CGFloat(center.row - avatarLocation.row) * (startSlot.bounds.height + Slot.interitemSpacing))
            }
            
            setFogOfWar(atIndex: destination.index)
            
            setTrail(toDestination: destination)
        }
        
        return move
    }
    
    private func setFogOfWar(atIndex index: Int) {
        avatar.locationIndex = index
        
        guard let location = self.location(forIndex: index) else {
            return
        }
        
        let neighborIndices = Set(location.neighbors.compactMap { self.index(forLocation: $0) })
        
        withAnimation {
            slots(forType: .field).forEach {
                $0.proximityFactor = proximity(betweenIndex: $0.index, and: index)
                $0.isLocked = $0.index != index && !neighborIndices.contains($0.index)
            }
        }
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

extension GameBoard {
    
    struct Location: Hashable {
        
        let col: Int
        let row: Int
        
        var neighbors: [Location] {
            [oneUp(), oneDown(), oneRight(), oneLeft()]
        }
        
        func oneUp() -> Location {
            Location(col: col, row: row - 1)
        }
        
        func oneDown() -> Location {
            Location(col: col, row: row + 1)
        }
        
        func oneRight() -> Location {
            Location(col: col + 1, row: row)
        }
        
        func oneLeft() -> Location {
            Location(col: col - 1, row: row)
        }
        
        func oneToward(direction: Direction) -> Location {
            switch direction {
            case .up: return Location(col: col, row: row - 1)
            case .right: return Location(col: col + 1, row: row)
            case .down: return Location(col: col, row: row + 1)
            case .left: return Location(col: col - 1, row: row)
            default: return self
            }
        }
        
        func distance(to otherLocation: Location) -> Int {
            Int(sqrt(pow(Double(otherLocation.col - col), 2) + pow(Double(otherLocation.row - row), 2)).rounded(.up))
            
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
    
    private func proximity(betweenIndex index1: Int, and index2: Int) -> Double {
        guard
            let location1 = location(forIndex: index1),
            let location2 = location(forIndex: index2)
        else {
            return 0
        }
        return 1.0 - (0...1.0).clamp(
            value: (Double(location1.distance(to: location2)) - 1.0) / 2
        )
    }
}

private struct BoundsPreference {
    
    let id: UUID
    let bounds: SwiftUI.Anchor<CGRect>
}

private struct SlotBoundsPreferenceKey: PreferenceKey {
    
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
    
    func resolveLayout(forBoard board: GameBoard) -> some View {
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
