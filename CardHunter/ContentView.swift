//
//  ContentView.swift
//  CardHunter
//
//  Created by Cristian Díaz on 16.8.2020.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            BoardView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Board(rows: 5, cols: 5, inventoryRows: 1))
    }
}
