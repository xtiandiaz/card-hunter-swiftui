//
//  AvatarCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import SwiftUI

class AvatarCard: Card, Destructible, Movable {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    let style = CardStyle(backgroundColor: .white, foregroundColor: .black)
    
    var stackIndex = 0
    var locationIndex: Int?
    
    init(health: Int, attack: Int, defense: Int, wealth: Int) {
        id = UUID()
        type = .avatar
        
        metrics.set(value: health, forKey: .health)
    }
    
    deinit {
        print("You died!")
    }
    
    var content: CardContent {
        switch health {
        case 0: return .string(value: "💀")
        case 1...3: return .string(value: "😨")
        case 4...6: return .string(value: "😬")
        default: return .string(value: "😎")
        }
    }
    
    var isInvalidated: Bool {
        health <= 0
    }
    
    func attack(target: Int) -> Int {
        let attack = metrics.safeValue(forKey: .attack)
        let power = min(target, attack)
        
        metrics.add(value: -target, toKey: .attack)
        
        return power
    }
}
