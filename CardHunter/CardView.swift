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
    let onCardDropped: ((CGPoint) -> Void)
    
    var body: some View {
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged {
                self.isDragging = true
                self.draggingOffset = $0.translation
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
        
        return RoundedRectangle(cornerRadius: 8.0, style: .continuous)
            .fill(Color.black)
            .aspectRatio(contentMode: .fit)
            .scaleEffect(isDragging ? 1.1 : 1)
            .offset(draggingOffset)
            .gesture(dragGesture, including: stackIndex == 0 ? .all : .none)
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
}
