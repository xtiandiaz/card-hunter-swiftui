//
//  CardMetrics.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import SwiftUI

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
        
        var foregroundColor: Color {
            switch self {
            case .health:
                return .red
            case .wealth:
                return .blue
            case .attack:
                return .grayDark
            case .defense:
                return .grayDark
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
        objectWillChange.send()
        metrics[key] = CardMetric(key: key, value: max(value, 0))
    }
    
    func add(value: Int, toKey key: CardMetric.Key) {
        set(value: safeValue(forKey: key) + value, forKey: key)
    }
    
    func safeValue(forKey key: CardMetric.Key) -> Int {
        metrics[key]?.value ?? 0
    }
    
    func isNil(_ key: CardMetric.Key) -> Bool {
        safeValue(forKey: key) <= 0
    }
    
    // MARK: Private
    
    private var metrics = [CardMetric.Key: CardMetric]()
}
