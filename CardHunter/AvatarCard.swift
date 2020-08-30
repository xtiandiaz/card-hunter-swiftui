//
//  AvatarCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import SwiftUI

class AvatarCard: Card {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(health: Int, attack: Int, defense: Int, wealth: Int) {
        id = UUID()
        type = .avatar
        
        metrics.set(value: health, forKey: .health)
        metrics.set(value: attack, forKey: .attack)
        metrics.set(value: defense, forKey: .defense)
        metrics.set(value: wealth, forKey: .wealth)
    }
    
    var content: String {
        "😎"
    }
    
    var backgroundColor: Color {
        Color.yellow
    }
    
    var foregroundColor: Color {
        Color.black
    }
}
