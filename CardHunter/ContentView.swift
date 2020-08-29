//
//  ContentView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 16.8.2020.
//

import SwiftUI

class Board: ObservableObject {
    
    @Published var slots: [Slot]
    @Published var cards: [Card]
    @Published var slotPositions = [Int: CGPoint]()
    
    init() {
        slots = (0..<12).map { Slot(id: $0) }
        cards = (0..<3).map { Card(id: $0) }
        
        cards.forEach {
            slots[$0.id].pushCard($0)
        }
    }
}

struct BoardInfoPreference {
    
    let id: Int
    let bounds: Anchor<CGRect>
}

struct BoardPreferenceKey: PreferenceKey {
    
    static var defaultValue: [BoardInfoPreference] = []
    
    static func reduce(value: inout [BoardInfoPreference], nextValue: () -> [BoardInfoPreference]) {
        return value.append(contentsOf: nextValue())
    }
}

extension View {
    
    func boardInfoId(_ id: Int) -> some View {
        self.anchorPreference(key: BoardPreferenceKey.self, value: .bounds) {
            [BoardInfoPreference(id: id, bounds: $0)]
        }
    }
    
    func boardInfo(_ info: Binding<BoardInfo>) -> some View {
        self.backgroundPreferenceValue(BoardPreferenceKey.self) {
            prefs in
            GeometryReader {
                proxy -> Color in
                DispatchQueue.main.async {
                    info.wrappedValue.slots = prefs.compactMap {
                        BoardInfo.SlotItem(id: $0.id, bounds: proxy[$0.bounds])
                    }
                }
                
                return Color.clear
            }
        }
    }
}

struct BoardInfo: Equatable {
    
    var slots: [SlotItem] = []
    
    var columnCount: Int {
        guard slots.count > 1 else {
            return slots.count
        }
        
        var k = 1
        
        for i in 1..<slots.count {
            if slots[i].bounds.origin.x < slots[i-1].bounds.origin.x {
                k += 1
            } else {
                break
            }
        }
        
        return k
    }
    
    var slotRange: ClosedRange<Int>? {
        guard
            let lower = slots.first?.id,
            let upper = slots.last?.id
        else {
            return nil
        }
        
        return lower...upper
    }
    
    func slotWidth(_ id: Int) -> CGFloat {
        columnCount > 0 ? columnWidth(id % columnCount) : 0
    }
    
    func columnWidth(_ col: Int) -> CGFloat {
        columnCount > 0 && col < columnCount ? slots[col].bounds.width : 0
    }
    
    func spacing(_ col: Int) -> CGFloat {
        guard columnCount < 0 else {
            return 0
        }
        
        let left = col < columnCount ? slots[col].bounds.maxX : 0
        let right = col+1 < columnCount ? slots[col+1].bounds.minX : left
        
        return right - left
    }
    
    struct SlotItem: Equatable {
        let id: Int
        let bounds: CGRect
    }
}

struct ContentView: View {
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @EnvironmentObject var board: Board
    @State private var info: BoardInfo = BoardInfo()
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, alignment: .center) {
                ForEach(board.slots) {
                    slot in
                    SlotView(slot: slot) {
                        card, localOffset in
                        
                        if let destSlot = slotForPosition(
                            info.slots[slot.id].bounds.center + localOffset
                        ) {
                            slot.popCard()
                            destSlot.pushCard(card)
                        }
                    }
                    .boardInfoId(slot.id)
                }
            }
            .boardInfo($info)
//
//            ForEach(board.cards) {
//                CardView(card: $0, position: .zero)
//            }
        }
        .padding()
    }
    
    // MARK: Private
    
    func slotForPosition(_ position: CGPoint) -> Slot? {
        board.slots.first {
            let bounds = info.slots[$0.id].bounds
            let origin = bounds.origin
            let end = bounds.end
            
            return position.x >= origin.x && position.y >= origin.y &&
                position.x <= end.x && position.y <= end.y
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Board())
    }
}

class Slot: ObservableObject, Identifiable {
    
    let id: Int
    
    @Published var cards = [Card]()
    
    init(id: Int) {
        self.id = id
    }
    
    func popCard() {
        cards.remove(at: 0)
    }
    
    func pushCard(_ card: Card) {
        cards.insert(card, at: 0)
    }
}

struct SlotView: View {
    
    @ObservedObject var slot: Slot
    
    let onCardDropped: ((Card, CGPoint) -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                .strokeBorder(lineWidth: 2.0, antialiased: true)
                .aspectRatio(contentMode: .fit)
                .opacity(0.1)
            
            ForEach(slot.cards.enumerated().map { $0 }, id: \.element) {
                index, card in
                CardView(card: card, stackIndex: index) {
                    localOffset in
                    self.onCardDropped(card, localOffset)
                }
                .zIndex(Double(-index))
            }
        }
    }
}

struct Card: Identifiable, Hashable {
    
    let id: Int
}

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
