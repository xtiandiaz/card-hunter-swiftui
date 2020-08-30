//
//  CardMetrics.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import Combine

struct CardMetric {
    
    enum Key {
        
        case health, wealth, attack, defense
        
        var icon: String {
            switch self {
            case .health:
                return "❤️"
            case .wealth:
                return "💎"
            case .attack:
                return "⚔️"
            case .defense:
                return "🛡"
            }
        }
    }
    
    let key: Key
    let value: Int
}

class CardMetrics: ObservableObject {
    
    subscript(key: CardMetric.Key) -> CardMetric? {
        metrics[key]
    }
    
    func set(value: Int, forKey key: CardMetric.Key) {
        metrics[key] = CardMetric(key: key, value: value)
    }
    
    // MARK: Private
    
    private var metrics = [CardMetric.Key: CardMetric]()
}
