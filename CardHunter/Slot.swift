//
//  Slot.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

class Slot: ObservableObject, Identifiable {
    
    let id: Int
    var bounds = CGRect.zero
    
    @Published var cards = [Card]()
    
    init(id: Int) {
        self.id = id
    }
    
    func popCard() {
        cards.remove(at: 0)
    }
    
    func pushCard(_ card: Card) {
        cards.insert(card, at: 0)
    }
    
    // MARK: Private
}
