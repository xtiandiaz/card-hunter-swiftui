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
            Cap(fill: Color.white.opacity(0.07))
            
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
            
            if slot.isLocked {
                Cap(fill: Color.black.opacity(1))
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
                    .zIndex(1000)
            }
        }
        .zIndex(zIndex)
    }
    
    // MARK: Private
    
    @State private var zIndex = Double(0)
    
    private struct Cap: View {
        
        let fill: Color
        
        var body: some View {
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .fill(fill)
                .aspectRatio(1, contentMode: .fit)
        }
    }
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
