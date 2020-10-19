//
//  Deck.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import Foundation

class Deck {
    
    init() {
        for _ in 0..<20 {
            cards.append(FoeCard(health: Int.random(in: 1...5)))
        }

        for _ in 0..<10 {
            cards.append(FoodCard(value: Int.random(in: 1...5)))
        }
        
        for _ in 0..<5 {
            cards.append(GemCard(value: Int.random(in: 1...3) * 5))
        }
        
        cards.append(contentsOf: Array(repeating: ItemCard(item: .potion), count: 2))
        cards.append(ItemCard(item: .torch))
        
        cards.shuffle()
    }
    
    var isEmpty: Bool {
        cards.isEmpty
    }
    
    func deal() -> Card? {
        guard !cards.isEmpty else {
            return nil
        }
        
        return cards.remove(at: 0)
    }
    
    func deal(count: Int) -> [Card] {
        guard !cards.isEmpty else {
            return []
        }
        
        let range = 0..<min(count, cards.count)
        let deal = Array(cards[range])
        
        cards.removeSubrange(range)
        
        return deal
    }
    
    // MARK: Private
    
    private var cards = [Card]()
}
