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
                
                withAnimation {
                    self.draggingOffset = .zero
                    self.isDragging = false
                }
            }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .fill(card.color)
            
            Text(card.content)
                .font(.system(size: 40))
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(isDragging ? 1.1 : 1)
        .offset(draggingOffset + stackOffset)
        .gesture(dragGesture, including: stackIndex == 0 ? .all : .none)
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
    
    private let stackOffset: CGSize
}
