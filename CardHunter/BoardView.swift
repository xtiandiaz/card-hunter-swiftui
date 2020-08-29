//
//  BoardView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import SwiftUI

struct BoardView: View {
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @EnvironmentObject var board: Board
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, alignment: .center) {
                ForEach(board.slots) {
                    slot in
                    SlotView(slot: slot) {
                        card in
                    } onCardDropped: {
                        card, localOffset in
                        if
                            let slot = board[slot.id],
                            let destSlot = board.slotForPosition(slot.bounds.center + localOffset)
                        {
                            slot.popCard()
                            destSlot.pushCard(card)
                        }
                    }
                    .anchorBounds(forSlotId: slot.id)
                }
            }
            .resolveLayout(forBoard: board)
        }
        .padding()
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(Board())
    }
}
