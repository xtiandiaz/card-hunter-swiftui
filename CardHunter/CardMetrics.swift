//
//  CardMetrics.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import SwiftUI

struct CardMetric {
    
    enum Key {
        
        case health, wealth, attack, defense, power
        
        var icon: String {
            switch self {
            case .health: return "❤️"
            case .wealth: return "💎"
            case .attack: return "⚔️"
            case .defense: return "🛡"
            default: return ""
            }
        }
    }
    
    let key: Key
    let value: Int
    let icon: String
    
    init(key: Key, value: Int, icon: String?) {
        self.key = key
        self.value = value
        self.icon = icon ?? key.icon
    }
}

class CardMetrics: ObservableObject {
    
    subscript(key: CardMetric.Key) -> CardMetric? {
        metrics[key]
    }
    
    func set(value: Int, forKey key: CardMetric.Key, icon: String? = nil) {
        objectWillChange.send()
        metrics[key] = CardMetric(key: key, value: max(value, 0), icon: icon)
    }
    
    func add(value: Int, toKey key: CardMetric.Key) {
        let metric = metrics[key]
        set(value: (metric?.value ?? 0) + value, forKey: key, icon: metric?.icon)
    }
    
    func safeValue(forKey key: CardMetric.Key) -> Int {
        metrics[key]?.value ?? 0
    }
    
    // MARK: Private
    
    private var metrics = [CardMetric.Key: CardMetric]()
}
