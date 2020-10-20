//
//  SlotView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct SlotView: View {
    
    @ObservedObject var slot: Slot
    
    let onCardPicked: ((Card) -> Void)
    let onCardDropped: ((Card, CGPoint) -> Void)
    
    var body: some View {
        switch slot.type {
        case .spacer:
            return AnyView(
                Color.clear
                    .aspectRatio(Slot.aspectRatio, contentMode: .fit)
            )
        case .trigger(_):
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                        .strokeBorder(lineWidth: 2.0)
                        .foregroundColor(Color.white.opacity(0.15))
                        .aspectRatio(Slot.aspectRatio, contentMode: .fit)
                    
                    CardContentView(content: slot.content)?
                        .foregroundColor(Color.white.opacity(0.15))
                }
            )
        default:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                        .strokeBorder(lineWidth: 2.0)
                        .foregroundColor(Color.white.opacity(0.15 * slot.proximityFactor))
                        .aspectRatio(Slot.aspectRatio, contentMode: .fit)
                        .zIndex(-1000)
                    
                    ForEach(slot.cards, id: \.id) {
                        card in
                        CardView(card: card) {
                            self.onCardPicked(card)
                            zIndex = 100
                        } onCardDropped: {
                            localOffset in
                            self.onCardDropped(card, localOffset)
                            zIndex = 0
                        }
                        .zIndex(card.zIndex)
                        .offset(x: 0, y: -Slot.stackedCardOffset * CGFloat(slot.cards.count - 1))
                        .transition(card.type == .avatar
                            ? .identity
                            : .asymmetric(
                                insertion: AnyTransition.opacity.combined(with: .scale)
                                    .animation(.easeInOut(duration: 0.5)),
                                removal: .identity
                        ))
                    }
                }
                .zIndex(zIndex)
            )
        }
    }
    
    // MARK: Private
    
    @State private var zIndex = Double(0)
}

struct SlotView_Previews: PreviewProvider {
    static var previews: some View {
        SlotView(slot: .trigger(forEvent: .attack(direction: .up))) { _ in
            
        } onCardDropped: { _, _ in
            
        }
    }
}
