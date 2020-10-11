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
        "🍖"
    }
    
    var backgroundColor: Color {
        Color.grayDark
    }
    
    var foregroundColor: Color {
        Color.white
    }
    
    var isInvalidated: Bool {
        value <= 0
    }
    
    func eat() {
        metrics.set(value: 0, forKey: .health)
    }
}

extension FoodCard: Edible {
    
    var value: Int {
        metrics.safeValue(forKey: .health)
    }
}
