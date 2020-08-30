//
//  Deck.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import Foundation

class Deck {
    
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
