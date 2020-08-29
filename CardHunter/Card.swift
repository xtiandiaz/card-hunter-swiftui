//
//  Card.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    
    static let avatar = Card(id: 0, value: 10, content: "😎", color: Color.yellow)
    static let weapon = Card(id: 1, value: 5, content: "⚔️", color: Color.gray)
    static let foe = Card(id: 2, value: 10, content: "👹", color: Color.red)
    static let potion = Card(id: 3, value: 3, content: "🧪", color: Color.green)
    static let gem = Card(id: 4, value: 5, content: "💎", color: Color.blue)
    
    let id: Int
    let value: Int
    let content: String
    let color: Color
}
