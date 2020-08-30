//
//  BoardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct BoardView: View {
    
    @EnvironmentObject var board: Board
    
    var body: some View {
        ZStack {
            ForEach(0..<board.slots.count/cols) {
                row in
                SlotRow(slots: Array(board.slots[SlotRow.indexRange(rowIndex: row, cols: cols)])) {
                    card in
                } onCardDropped: {
                    card, dropOffset, slot in
                    if let destSlot = board.slotForPosition(slot.bounds.center + dropOffset) {
                        slot.popCard()
                        destSlot.pushCard(card)
                    }
                }
            }
            .resolveLayout(forBoard: board)
        }
        .padding()
    }
    
    // MARK: Private
    
    private let rows = 4
    private let cols = 3
}

struct SlotRow: View {
    
    let slots: [Slot]
    let onCardPicked: ((Card) -> Void)
    let onCardDropped: ((_ card: Card, _ dropOffset: CGPoint, _ originalSlot: Slot) -> Void)
    
    var body: some View {
        HStack {
            ForEach(slots) {
                slot in
                SlotView(slot: slot) {
                    onCardPicked($0)
                    zIndex = 100
                } onCardDropped: {
                    onCardDropped($0, $1, slot)
                    zIndex = 0
                }
                .anchorBounds(forSlotId: slot.id)
            }
        }
        .zIndex(zIndex)
    }
    
    static func indexRange(rowIndex: Int, cols: Int) -> Range<Int> {
        rowIndex * cols ..< (rowIndex * cols) + cols
    }
    
    // MARK: Private
    
    @State private var zIndex = Double(0)
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(Board())
    }
}
