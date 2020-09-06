//
//  AvatarCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import SwiftUI

class AvatarCard: Card, Destructible {
    
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
    
    deinit {
        print("You died!")
    }
    
    var content: String {
        switch health {
        case 0:
            return "💀"
        case 1..<5:
            return "😨"
        case 5..<10:
            return "😬"
        default:
            return "😎"
        }
    }
    
    var isInvalidated: Bool {
        health <= 0
    }
    
    var backgroundColor: Color {
        Color.white
    }
    
    var foregroundColor: Color {
        Color.black
    }
    
    func attack(target: Int) -> Int {
        let attack = metrics.safeValue(forKey: .attack)
        let power = min(target, attack)
        
        metrics.add(value: -target, toKey: .attack)
        
        return power
    }
}
