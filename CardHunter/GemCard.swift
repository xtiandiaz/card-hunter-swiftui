//
//  GemCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 7.9.2020.
//

import SwiftUI

class GemCard: Card {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .gem
        
        metrics.set(value: value, forKey: .wealth)
    }
    
    var content: CardContent {
        .string(value: "💎")
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

extension GemCard: Consumable {
    
    var consumableKey: CardMetric.Key {
        .wealth
    }
}

