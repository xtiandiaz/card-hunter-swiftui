//
//  SlotView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct SlotView: View {
    
    @ObservedObject var slot: Slot
    
    let onCardDropped: ((Card, CGPoint) -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .strokeBorder(lineWidth: 2.0, antialiased: true)
                .aspectRatio(contentMode: .fit)
                .opacity(0.1)
            
            ForEach(slot.cards.enumerated().map { $0 }, id: \.element) {
                index, card in
                CardView(card: card, stackIndex: index) {
                    localOffset in
                    self.onCardDropped(card, localOffset)
                }
                .zIndex(Double(-index))
            }
        }
    }
}
