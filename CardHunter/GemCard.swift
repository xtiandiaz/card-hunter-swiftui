//
//  GemCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 7.9.2020.
//

import SwiftUI

class GemCard: Card {
    
    let id: UUID
    let type: CardType
    let metrics = CardMetrics()
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .gem
        
        metrics.set(value: value, forKey: .wealth)
    }
    
    var content: String {
        "💎"
    }
    
    var backgroundColor: Color {
        Color.grayDark
    }
    
    var foregroundColor: Color {
        Color.white
    }
    
    var isInvalidated: Bool {
        value <= 0
    }
    
    func cash() {
        metrics.set(value: 0, forKey: .wealth)
    }
}

extension GemCard: Cashable {
    
    var value: Int {
        metrics.safeValue(forKey: .wealth)
    }
}

