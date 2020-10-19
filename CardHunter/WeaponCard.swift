//
//  WeaponCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 19.10.2020.
//

import SwiftUI

class WeaponCard: Card {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .weapon
        
        metrics.set(value: value, forKey: .attack)
    }
    
    var content: CardContent {
        .string(value: "🗡")
    }
    
    var backgroundColor: Color {
        Color.gray
    }
    
    var foregroundColor: Color {
        Color.white
    }
    
    var isInvalidated: Bool {
        false
    }
}
