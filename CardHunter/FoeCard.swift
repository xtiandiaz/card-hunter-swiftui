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
    
    var stackIndex = 0
    
    init(health: Int) {
        id = UUID()
        type = .foe
        
        metrics.set(value: health, forKey: .health)
    }
    
    deinit {
        print("Foe destroyed!")
    }
    
    var content: String {
        "👹"
    }
    
    var isInvalidated: Bool {
        health <= 0
    }
    
    var backgroundColor: Color {
        Color.red
    }
    
    var foregroundColor: Color {
        Color.white
    }
}
