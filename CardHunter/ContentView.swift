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
            BoardView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
