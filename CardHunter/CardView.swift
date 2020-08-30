//
//  CardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    let onCardPicked: (() -> Void)
    let onCardDropped: ((CGPoint) -> Void)
    
    @ObservedObject var metrics: CardMetrics
    
    init(
        card: Card,
        onCardPicked: @escaping (() -> Void),
        onCardDropped: @escaping ((CGPoint) -> Void)
    ) {
        self.card = card
        self.onCardPicked = onCardPicked
        self.onCardDropped = onCardDropped
        
        metrics = card.metrics
        stackOffset = CGSize(width: 0, height: CGFloat(card.stackIndex) * 4.0)
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
                .fill(card.backgroundColor)
            
            Text(card.content)
                .font(.system(size: 56))
            
            if let health = card.metrics[.health] {
                MetricView(metric: health, color: card.foregroundColor, anchor: .topLeading)
            }
            
            if let attack = card.metrics[.attack] {
                MetricView(metric: attack, color: card.foregroundColor, anchor: .topTrailing)
            }
            
            if let defense = card.metrics[.defense] {
                MetricView(metric: defense, color: card.foregroundColor, anchor: . bottomLeading)
            }
            
            if let wealth = card.metrics[.wealth] {
                MetricView(metric: wealth, color: card.foregroundColor, anchor: .bottomTrailing)
            }
                    
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(isDragging ? 1.05 : 1)
        .offset(draggingOffset + stackOffset)
        .gesture(dragGesture, including: card.stackIndex == 0 ? .all : .none)
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
    
    private let stackOffset: CGSize
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: AvatarCard(health: 10, attack: 5, defense: 0, wealth: 0)) {
        } onCardDropped: { _ in
        }
    }
}

// MARK: - Subviews

private struct MetricView: View {
    
    let metric: CardMetric
    let color: Color
    let anchor: Alignment
    
    var valueView: some View {
        Text("\(metric.value)")
            .font(.system(size: 18, weight: .black))
            .foregroundColor(color)
    }
    
    var iconView: some View {
        Text(metric.key.icon)
            .font(.system(size: 12))
    }
    
    var body: some View {
        VStack(alignment: anchor.horizontal, spacing: 0) {
            if anchor.vertical == .top {
                valueView
                iconView
            } else {
                iconView
                valueView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: anchor)
        .padding(4)
    }
}
