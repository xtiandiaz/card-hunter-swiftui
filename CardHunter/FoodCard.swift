//
//  FoodCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 7.9.2020.
//

import SwiftUI

class FoodCard: GameCard {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    let style = CardStyle(backgroundColor: .grayDark, foregroundColor: .white)
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .food
        
        metrics.set(value: value, forKey: .health)
    }
    
    var content: CardContent {
        switch consumableValue {
        case 1: return .string(value: "🍬")
        case 2: return .string(value: "🍫")
        case 3: return .string(value: "🍕")
        case 4: return .string(value: "🍗")
        case 5: return .string(value: "🍖")
        default: return .string(value: "🥘")
        }
    }
    
    var isInvalidated: Bool {
        consumableValue <= 0
    }
}

extension FoodCard: Consumable {
    
    var consumableKey: CardMetric.Key {
        .health
    }
}
