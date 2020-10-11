//
//  Card.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

enum CardType: Int {
    
    case avatar, foe, weapon, food, gem
}

protocol Card: AnyObject {
    
    var id: UUID { get }
    var type: CardType { get }
    var content: String { get }
    var metrics: CardMetrics { get }
    var stackIndex: Int { get set }
    
    var isInvalidated: Bool { get }
    
    var backgroundColor: Color { get }
    var foregroundColor: Color { get }
}

protocol Draggable {
    
}

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

protocol Edible {
    
    var value: Int { get }
    
    func eat()
}

protocol Cashable {
    
    var value: Int { get }
    
    func cash()
}

extension Card {
    
    var zIndex: Double {
        Double(-stackIndex)
    }
    
    func apply(other: Card) {
        switch other {
        case let avatar as AvatarCard:
            switch self {
            case let destructible as Destructible:
//                let power = avatar.attack(target: destructible.health)
//                if power > 0 {
//                    destructible.damage(withValue: power)
//                } else {
                    let destructibleHealth = destructible.health
                    destructible.damage(withValue: avatar.health)
                    avatar.damage(withValue: destructibleHealth)
//                }
            case let edible as Edible:
                avatar.metrics.add(value: edible.value, toKey: .health)
                edible.eat()
            case let cashable as Cashable:
                avatar.metrics.add(value: cashable.value, toKey: .wealth)
                cashable.cash()
            default:
                break
            }
            break
        default:
            break
        }
    }
}
