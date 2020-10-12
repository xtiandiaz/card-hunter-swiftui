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
        ZStack {
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
                .transition(card is Movable
                    ? .identity
                    : .asymmetric(
                        insertion: AnyTransition.opacity.combined(with: .scale)
                            .animation(.easeInOut(duration: 0.5)),
                        removal: .identity
                ))
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

//extension AnyTransition {
//
//    static var cardDeal: AnyTransition {
//        get {
//            AnyTransition.modifier(active: CardDealTranstion(), identity: .identity)
//        }
//    }
//}
//
//struct CardDealTranstion: ViewModifier {
//    func body(content: Content) -> some View {
//        content.scaleEffect(1)
//    }
//}
