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
            VStack {
                SlotRow(slots: board.inventorySlots) {
                    card in
                } onCardDropped: {
                    board.tryMovingCard($0, fromSlot: $1, withPositionOffset: $2)
                }
                
                Spacer().frame(height: 80)
                
                ForEach(0..<board.fieldSlots.count/board.cols) {
                    row in
                    SlotRow(slots: Array(board.fieldSlots[SlotRow.indexRange(rowIndex: row, cols: board.cols)])) {
                        card in
                    } onCardDropped: {
                        board.tryMovingCard($0, fromSlot: $1, withPositionOffset: $2)
                    }
                }
            }
            .resolveLayout(forBoard: board)
        }
        .padding()
    }
}

struct SlotRow: View {
    
    let slots: [Slot]
    let onCardPicked: ((Card) -> Void)
    let onCardDropped: ((Card, _ fromSlot: Slot, _ withOffset: CGPoint) -> Void)
    
    var body: some View {
        HStack {
            ForEach(slots) {
                slot in
                SlotView(slot: slot) {
                    onCardPicked($0)
                    zIndex = 100
                } onCardDropped: {
                    onCardDropped($0, slot, $1)
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
            .environmentObject(Board(rows: 4, cols: 3, inventoryRows: 1))
    }
}
