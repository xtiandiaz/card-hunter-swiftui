//
//  SlotView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct SlotView: View {
    
    let onCardPicked: ((Card) -> Void)
    let onCardDropped: ((Card, CGPoint) -> Void)
    
    @ObservedObject var slot: Slot
    
    var body: some View {
        ZStack {
            ForEach(slot.cards.enumerated().map { $0 }, id: \.element) {
                index, card in
                CardView(card: card, stackIndex: index) {
                    self.onCardPicked(card)
                    zIndex = 100
                } onCardDropped: {
                    localOffset in
                    self.onCardDropped(card, localOffset)
                    zIndex = 0
                }
                .zIndex(Double(-index))
            }
            
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .strokeBorder(Color.white.opacity(0.2), lineWidth: 2.0)
                .aspectRatio(1, contentMode: .fit)
                .zIndex(-100)
        }
        .zIndex(zIndex)
    }
    
    // MARK: Private
    
    @State private var zIndex = Double(0)
}
