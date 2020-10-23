//
//  Card.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct CardType: OptionSet {
    
    let rawValue: Int
    
    static let avatar = CardType(rawValue: 1 << 0)
    static let foe = CardType(rawValue: 1 << 1)
    static let food = CardType(rawValue: 1 << 2)
    static let gem = CardType(rawValue: 1 << 3)
    static let item = CardType(rawValue: 1 << 4)
    static let weapon = CardType(rawValue: 1 << 5)
}

enum CardContent: Equatable {
    
    case none
    case string(value: String)
    case systemIcon(name: String)
}

class CardStyle {
    
    let backgroundColor: Color
    let foregroundColor: Color
    var lightness: Double
    
    init(backgroundColor: Color, foregroundColor: Color) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        lightness = 1.0
    }
}

protocol Card: AnyObject {
    
    var id: UUID { get }
    var type: CardType { get }
    var content: CardContent { get }
    var metrics: CardMetrics { get }
    var stackIndex: Int { get set }
    
    var isInvalidated: Bool { get }
    
    var style: CardStyle { get }
}

protocol Movable { }

protocol Destructible {
    
    var metrics: CardMetrics { get }
    
    func damage(withValue value: Int)
}

extension Destructible {
    
    var health: Int {
        get { metrics.safeValue(forKey: .health) }
        set { metrics.set(value: newValue, forKey: .health) }
    }
    
    func damage(withValue value: Int) {
        metrics.add(value: -value, toKey: .health)
    }
}

protocol Consumable: Card {
    
    var consumableKey: CardMetric.Key { get }
}

extension Consumable {
    
    var consumableValue: Int {
        metrics.safeValue(forKey: consumableKey)
    }
    
    func consume() {
        metrics.set(value: 0, forKey: consumableKey)
    }
}

protocol Collectible: Card {
    
    var isCollected: Bool { get set }
}

extension Card {
    
    var zIndex: Double {
        Double(-stackIndex)
    }
}
