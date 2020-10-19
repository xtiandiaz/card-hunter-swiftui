//
//  FoodCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 7.9.2020.
//

import SwiftUI

class FoodCard: Card {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .food
        
        metrics.set(value: value, forKey: .health)
    }
    
    var content: String {
        switch consumableValue {
        case 1: return "🍬"
        case 2: return "🍫"
        case 3: return "🍕"
        case 4: return "🍗"
        case 5: return "🍖"
        default: return "🥘"
        }
    }
    
    var backgroundColor: Color {
        Color.grayDark
    }
    
    var foregroundColor: Color {
        Color.white
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
