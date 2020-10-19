//
//  ItemCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 11.10.2020.
//

import SwiftUI

enum Item {
    
    case potion, torch, escape
}

class ItemCard: Card {
    
    let id: UUID
    let type: CardType
    let item: Item
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(item: Item, value: Int = 1) {
        id = UUID()
        type = .item
        self.item = item
        
        metrics.add(value: value, toKey: .power)
    }
    
    var content: CardContent {
        switch item {
        case .potion: return .string(value: "🧪")
        case .torch: return .string(value: "🔦")
        case .escape: return .string(value: "💨")
        }
    }
    
    var isInvalidated: Bool {
        consumableValue <= 0
    }
    
    var backgroundColor: Color {
        Color.green
    }
    
    var foregroundColor: Color {
        Color.white
    }
}

extension ItemCard: Consumable {
    
    var consumableKey: CardMetric.Key {
        .power
    }
}
