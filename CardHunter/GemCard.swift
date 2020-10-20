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
    let style = CardStyle(backgroundColor: .grayDark, foregroundColor: .white)
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .gem
        
        metrics.set(value: value, forKey: .wealth)
    }
    
    var content: CardContent {
        .string(value: "💎")
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

