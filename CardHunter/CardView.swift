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
        stackOffset = CGSize(width: 0, height: CGFloat(card.stackIndex) * Slot.stackedCardOffset)
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
                .shadow(radius: 4)
            
            CardContentView(content: card.content)
            
            if let health = card.metrics[.health] {
                MetricView(
                    metric: health,
                    anchor: .top,
                    foregroundColor: card.foregroundColor
                )
            }
            
            if let attack = card.metrics[.attack] {
                MetricView(
                    metric: attack,
                    anchor: .top,
                    foregroundColor: card.foregroundColor
                )
            }
        }
        .aspectRatio(Slot.aspectRatio, contentMode: .fit)
        .scaleEffect(isDragging ? 1.05 : 1)
        .offset(draggingOffset + stackOffset)
        .gesture(dragGesture, including: isMovable ? .all : .none)
    }
    
    // MARK: Private
    
    @State private var draggingOffset = CGSize.zero
    @State private var isDragging = false
    
    private let stackOffset: CGSize
    
    private var isMovable: Bool {
        card is Movable && card.stackIndex == 0
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: AvatarCard(health: 10, attack: 5, defense: 0, wealth: 0)) {
        } onCardDropped: { _ in
        }
    }
}

// MARK: - Subviews

struct CardContentView: View {
    
    let content: CardContent
    
    init?(content: CardContent) {
        guard content != .none else {
            return nil
        }
        self.content = content
    }
    
    var body: some View {
        switch content {
        case .systemIcon(let name): return AnyView(
            Image(systemName: name)
                .font(.system(size: 32, weight: .medium))
        )
        case .string(let value): return AnyView(
            Text(value)
                .font(.system(size: 40))
        )
        default: return AnyView(Color.clear)
        }
    }
}

private struct MetricView: View {
    
    let metric: CardMetric
    let anchor: VerticalAlignment
    let foregroundColor: Color
    
    var valueView: some View {
        Text("\(metric.value)")
            .font(.system(size: 15, weight: .black))
            .foregroundColor(foregroundColor)
            .frame(minWidth: 12, maxHeight: 15)
    }
    
    var iconView: some View {
        Text(metric.icon)
            .font(.system(size: 12))
    }
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
            if anchor == .bottom {
                Spacer()
            }
            HStack(alignment: .top, spacing: 0) {
                iconView
                Spacer()
                valueView
            }
            if anchor == .top {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(4)
    }
}
