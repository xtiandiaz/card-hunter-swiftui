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
    let style = CardStyle(backgroundColor: .gray, foregroundColor: .white)
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .weapon
        
        metrics.set(value: value, forKey: .attack)
    }
    
    var content: CardContent {
        .string(value: "🗡")
    }
    
    var isInvalidated: Bool {
        false
    }
}
