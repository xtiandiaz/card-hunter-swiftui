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
    
    var content: String {
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

protocol Card: AnyObject {
    
    var id: UUID { get }
    var type: CardType { get }
    var stats: CardStats { get }
    
    var stackIndex: Int { get set }
}

extension Card {
    
    var zIndex: Double {
        Double(-stackIndex)
    }
}

class CardStats: ObservableObject {
    
    @Published var value: Int
    
    init(value: Int) {
        self.value = value
    }
}
