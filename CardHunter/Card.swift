//
//  Card.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

enum CardType: Int {
    
    case avatar, foe, weapon, food, gem
    
    var color: Color {
        switch self {
        case .avatar:
            return Color.yellow
        case .foe:
            return Color.red
        case .weapon:
            return Color.gray
        case .gem, .food:
            return Color.white
        }
    }
    
    func content(forValue value: Int) -> String {
        switch self {
        case .avatar:
            return "😎"
        case .foe:
            return "👹"
        case .weapon:
            return "⚔️"
        case .gem:
            return "💎"
        case .food:
            return "🍖"
        }
    }
}

struct Card: Identifiable, Hashable {
    
    let id: Int
    let value: Int
    let type: CardType
    
    init(type: CardType, value: Int) {
        id = Self.nextId()
        
        self.type = type
        self.value = value
    }
    
    var content: String {
        type.content(forValue: value)
    }
    
    static func produce(ofType type: CardType, withValue value: Int) -> Card {
        Card(type: type, value: value)
    }
    
    // MARK: Private
    
    private static var id = 0
    
    private static func nextId() -> Int {
        id += 1
        return id
    }
}
