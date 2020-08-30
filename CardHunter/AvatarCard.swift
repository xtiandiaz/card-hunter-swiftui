//
//  AvatarCard.swift
//  CardHunter
//
//  Created by Cristian Díaz on 30.8.2020.
//

import SwiftUI

class AvatarCard: Card {
    
    let id: UUID
    let type: CardType
    let stats: CardStats
    
    var stackIndex = 0
    
    init(value: Int) {
        id = UUID()
        type = .avatar
        stats = CardStats(value: value)
    }
    
    static func produce(withValue value: Int) -> AvatarCard {
        AvatarCard(value: value)
    }
}
