//
//  BoardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI
import Emerald

struct BoardView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                
//                SlotRow(slots: board.collectibleSlots)
                
//                LineView(style: StrokeStyle(lineWidth: 4), color: Color.white.opacity(0.1))
//                    .frame(maxHeight: 24)
                
                ForEach(0..<board.fieldSlots.count/board.cols) {
                    row in
                    SlotRow(slots: Array(board.fieldSlots[SlotRow.indexRange(rowIndex: row, cols: board.cols)]))
                }
                
                Spacer()
                
                LineView(
                    style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [16]),
                    color: Color.white.opacity(0.1),
                    alignment: .top)
                    .frame(height: 1)
                
                SlotRow(slots: Array(repeating: Slot.spacer, count: board.cols))
                
                SlotRow(slots: [Slot.spacer, Slot.spacer, board.weaponsSlot, Slot.spacer, Slot.spacer])
                
                SlotRow(slots: Array(repeating: Slot.spacer, count: board.cols))
            }
            .resolveLayout(forBoard: board)
        }
    }
    
    // MARK: Private
    
    @EnvironmentObject private var board: Board
}

struct SlotRow: View {
    
    let slots: [Slot]
//    let onCardPicked: ((Card) -> Void)
//    let onCardDropped: ((Card, _ fromSlot: Slot, _ withOffset: CGPoint) -> Void)
    
    var body: some View {
        HStack {
            ForEach(slots) {
                slot in
                SlotView(slot: slot) { _ in
//                    onCardPicked($0)
                    zIndex = 100
                } onCardDropped: {
//                    onCardDropped($0, slot, $1)
                    board.tryMovingCard($0, fromSlot: slot, withPositionOffset: $1)
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
    
    @EnvironmentObject private var board: Board
    @State private var zIndex = Double(0)
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(Board(rows: 4, cols: 3, inventoryRows: 1))
    }
}
