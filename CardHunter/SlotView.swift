//
//  SlotView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct SlotView: View {
    
    @ObservedObject var slot: Slot
    var onCardPicked: (() -> ())?
    var onCardDropped: ((CGPoint) -> ())?
    
    var body: some View {
        Group {
            if slot.type == .spacer {
                Color.clear
                    .aspectRatio(Slot.aspectRatio, contentMode: .fit)
            } else {
                let dragGesture = DragGesture(minimumDistance: 0)
                    .onChanged {
                        isDragging = true
                        draggingOffset = $0.translation
                        
                        onCardPicked?()
                    }
                    .onEnded {
                        onCardDropped?(CGPoint(
                            x: $0.translation.width,
                            y: $0.translation.height
                        ))
                        
                        withAnimation(.easeOut(duration: 0.1)) {
                            draggingOffset = .zero
                            isDragging = false
                        }
                    }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                        .strokeBorder(lineWidth: 2.0)
                        .foregroundColor(Color.white.opacity(0.15 * slot.proximityFactor))
                        .aspectRatio(Slot.aspectRatio, contentMode: .fit)
                        .zIndex(-1)
                    
                    ForEach(slot.cards, id: \.id) {
                        card in
                        CardView(card: card)
                            .lightness(slot.proximityFactor - card.stackDimness)
                            .offset((card.isTop ? draggingOffset : .zero) + card.stackOffset)
                            .zIndex(card.zIndex)
                            .scaleEffect(isDragging && card.isTop ? 1.05 : 1)
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
                .zIndex(isDragging ? 1000 : 0)
            }
        }
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
}

struct SlotView_Previews: PreviewProvider {
    static var previews: some View {
        SlotView(slot: .trigger(forEvent: .attack(direction: .up)))
    }
}
