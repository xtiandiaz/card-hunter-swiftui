//
//  FoeCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 6.9.2020.
//

import SwiftUI

class FoeCard: Card, Destructible {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    let style = CardStyle(backgroundColor: .red, foregroundColor: .white)
    
    var stackIndex = 0
    
    init(health: Int) {
        id = UUID()
        type = .foe
        
        metrics.set(value: health, forKey: .health, icon: "💀")
    }
    
    deinit {
        print("Foe destroyed!")
    }
    
    var content: CardContent {
        .string(value: "👹")
    }
    
    var isInvalidated: Bool {
        health <= 0
    }
}
