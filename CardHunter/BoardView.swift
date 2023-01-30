//
//  BoardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct BoardView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: Slot.interitemSpacing) {
                ForEach(0..<board.fieldSlots.count/board.cols) {
                    row in
                    SlotRow(slots: Array(board.fieldSlots[SlotRow.indexRange(rowIndex: row, cols: board.cols)]))
                }
            }
            .layoutPriority(1)
            .offset(board.boardOffset)
            .zIndex(0)
            
            Spacer().frame(height: Slot.interitemSpacing * 2)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 2)
                
                Spacer().frame(height: Slot.interitemSpacing * 2)
                
                SlotRow(slots: [.spacer, .spacer, board.weaponSlot, .spacer, .spacer])
                
                Spacer().frame(height: Slot.interitemSpacing * 2)
            }
            .background(Color.black)
            .zIndex(2)
        }
        .edgesIgnoringSafeArea([.top, .trailing, .leading])
        .resolveLayout(forBoard: board)
    }
    
    // MARK: Private
    
    @EnvironmentObject private var board: GameBoard
}

private struct SlotRow: View {
    
    let slots: [Slot]
    
    var body: some View {
        HStack(spacing: Slot.interitemSpacing) {
            ForEach(slots) {
                slot in
                SlotView(slot: slot) {
                    zIndex = 1000
                } onCardDropped: {
                    board.tryMovingCard(from: slot, withPositionOffset: $0)
                    zIndex = 0
                }
                .offset(CGSize(width: slot.zIndex, height: 0))
                .anchorBounds(forSlotId: slot.id)
            }
        }
        .zIndex(zIndex)
    }
    
    static func indexRange(rowIndex: Int, cols: Int) -> Range<Int> {
        rowIndex * cols ..< (rowIndex * cols) + cols
    }
    
    // MARK: Private
    
    @EnvironmentObject private var board: GameBoard
    @State private var zIndex = Double(0)
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(GameBoard(rows: 5, cols: 5, inventoryRows: 1))
    }
}
