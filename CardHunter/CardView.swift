//
//  CardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    let stackIndex: Int
    let onCardPicked: (() -> Void)
    let onCardDropped: ((CGPoint) -> Void)
    
    init(
        card: Card,
        stackIndex: Int,
        onCardPicked: @escaping (() -> Void),
        onCardDropped: @escaping ((CGPoint) -> Void)
    ) {
        self.card = card
        self.stackIndex = stackIndex
        self.onCardPicked = onCardPicked
        self.onCardDropped = onCardDropped
        
        stackOffset = CGSize(width: 0, height: CGFloat(stackIndex) * 4.0)
    }
    
    var body: some View {
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged {
                self.isDragging = true
                self.draggingOffset = $0.translation
                
                onCardPicked()
            }
            .onEnded {
                value in
                onCardDropped(CGPoint(
                    x: value.translation.width,
                    y: value.translation.height
                ))
                
                withAnimation(.easeOut(duration: 0.1)) {
                    self.draggingOffset = .zero
                    self.isDragging = false
                }
            }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .fill(card.type.color)
            
            Text(card.content)
                .font(.system(size: 56))
            
            ZStack {
                Text(String(card.value))
                    .foregroundColor(Color.white)
                    .font(.system(size: 20, weight: .bold))
                    .shadow(color: Color.black.opacity(0.75), radius: 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(8)
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(isDragging ? 1.05 : 1)
        .offset(draggingOffset + stackOffset)
        .gesture(dragGesture, including: stackIndex == 0 ? .all : .none)
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
    
    private let stackOffset: CGSize
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.produce(ofType: .avatar, withValue: 10), stackIndex: 0) {
        } onCardDropped: { _ in
        }
    }
}
