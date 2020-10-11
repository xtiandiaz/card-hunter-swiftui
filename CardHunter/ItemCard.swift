//
//  ItemCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 11.10.2020.
//

import SwiftUI

enum Item {
    case potion
}

class ItemCard: Card, Movable {
    
    let id: UUID
    let type: CardType
    let item: Item
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(item: Item) {
        id = UUID()
        type = .item
        self.item = item
    }
    
    var content: String {
        switch item {
        case .potion: return "🧪"
        }
    }
    
    var isInvalidated: Bool {
        false
    }
    
    var backgroundColor: Color {
        switch item {
        case .potion: return Color.green
        }
    }
    
    var foregroundColor: Color {
        Color.white
    }
}
