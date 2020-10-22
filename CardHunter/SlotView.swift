//
//  SlotView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI
import Emerald

struct SlotView: View {
    
    @ObservedObject var slot: Slot
    
    let onCardPicked: (Card) -> Void
    let onCardDropped: (Card, CGPoint) -> Void
    let onCardMoved: (Slot, Direction) -> Bool
    
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
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged {
                    self.isDragging = true
                    self.draggingOffset = $0.translation
                }
                .onEnded {
                    value in
                    if abs(draggingOffset.width) >= slot.bounds.width / 2
                        && onCardMoved(slot, draggingOffset.width > 0 ? .right : .left) {
                        //
                    } else if abs(draggingOffset.height) >= slot.bounds.height / 2
                        && onCardMoved(slot, draggingOffset.height > 0 ? .down : .up) {
                        //
                    }
                    
                    withAnimation(.easeOut(duration: 0.1)) {
                        self.draggingOffset = .zero
                        self.isDragging = false
                    }
                }
            
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                        .strokeBorder(lineWidth: 2.0)
                        .foregroundColor(Color.white.opacity(0.15 * slot.proximityFactor))
                        .aspectRatio(Slot.aspectRatio, contentMode: .fit)
                        .zIndex(-1000)
                    
                    ForEach(slot.cards, id: \.id) {
                        card in
                        CardView(card: card)
                            .offset(card.stackIndex == 0 ? draggingOffset : .zero)
                            .lightness(slot.proximityFactor)
                            .zIndex(card.zIndex)
                            .transition(card.type == .avatar
                                ? .identity
                                : .asymmetric(
                                    insertion: AnyTransition.opacity.combined(with: .scale)
                                        .animation(.easeInOut(duration: 0.5)),
                                    removal: .identity
                            ))
                    }
                }
                .gesture(dragGesture, including: slot.isActionable ? .all : .none)
                .zIndex(zIndex)
            )
        }
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
    @State private var zIndex = Double(0)
}

struct SlotView_Previews: PreviewProvider {
    static var previews: some View {
        SlotView(slot: .trigger(forEvent: .attack(direction: .up))) { _ in
            
        } onCardDropped: { _, _ in
            
        } onCardMoved: { _, _ in  return true}
    }
}
