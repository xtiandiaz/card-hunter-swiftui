//
//  CardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        metrics = card.metrics
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .fill(card.style.backgroundColor)
                .shadow(radius: 4)
            
            CardContentView(content: card.content)
            
            if let health = card.metrics[.health] {
                MetricView(
                    metric: health,
                    anchor: .top,
                    foregroundColor: card.style.foregroundColor
                )
            }
            
            if let attack = card.metrics[.attack] {
                MetricView(
                    metric: attack,
                    anchor: .top,
                    foregroundColor: card.style.foregroundColor
                )
            }
        }
        .aspectRatio(Slot.aspectRatio, contentMode: .fit)
    }
    
    // MARK: Private
    
    @ObservedObject private var metrics: CardMetrics
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: AvatarCard(health: 10, attack: 5, defense: 0, wealth: 0))
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
            .font(.system(size: 17, weight: .black))
            .foregroundColor(foregroundColor)
            .frame(minWidth: 12, maxHeight: 17)
    }
    
    var iconView: some View {
        Text(metric.icon)
            .font(.system(size: 13))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
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

// MARK: - Modifiers

extension View {
    
    func lightness(_ lightness: Double) -> some View {
        modifier(CardLightnessModifier(lightness: lightness))
    }
}

private struct CardLightnessModifier: ViewModifier {
    
    let lightness: Double
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .fill(Color.black)
                .opacity(1.0 - lightness))
    }
}
