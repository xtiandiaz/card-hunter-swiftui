//
//  WeaponCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 19.10.2020.
//

import SwiftUI

class WeaponCard: Card, Collectible {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    
    var stackIndex = 0
    var isCollected = false
    
    init(value: Int) {
        id = UUID()
        type = .weapon
        
        metrics.set(value: value, forKey: .attack)
    }
    
    var content: CardContent {
        .string(value: "🗡")
    }
    
    var style: CardStyle {
        isCollected
            ? CardStyle(backgroundColor: .white, foregroundColor: .black)
            : CardStyle(backgroundColor: .grayDark, foregroundColor: .white)
    }
    
    var isInvalidated: Bool {
        metrics.safeValue(forKey: .attack) <= 0
    }
}
