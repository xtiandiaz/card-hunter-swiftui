//
//  Card.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

enum CardType: Int {
    
    case avatar, foe, weapon, food, gem
}

protocol Card: AnyObject {
    
    var id: UUID { get }
    var type: CardType { get }
    var content: String { get }
    var metrics: CardMetrics { get }
    var backgroundColor: Color { get }
    var foregroundColor: Color { get }
    var stackIndex: Int { get set }
}

extension Card {
    
    var zIndex: Double {
        Double(-stackIndex)
    }
}
