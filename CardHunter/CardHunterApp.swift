//
//  CardHunterApp.swift
//  CardHunter
//
//  Created by Cristian Díaz on 16.8.2020.
//

import SwiftUI

@main
struct CardHunterApp: App {
    
    let board = Board()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(board)
        }
    }
}
