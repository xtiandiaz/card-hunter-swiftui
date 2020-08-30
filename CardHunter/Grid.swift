//
//  Grid.swift
//  TagDay
//
//  Created by Cristian Díaz on 11.11.2019.
//  Copyright © 2019 Berilio. All rights reserved.
//

import SwiftUI

struct Grid<Content: View>: View {
    
    let cols: Int
    let rows: Int
    let spacing: CGFloat?
    let content: (Int, Int, Int) -> Content
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<cols, id: \.self) { col in
                        content(col, row, row * cols + col)
                    }
                }
            }
        }
    }
    
    init(cols: Int, rows: Int, spacing: CGFloat?, @ViewBuilder content: @escaping (Int, Int, Int) -> Content) {
        self.cols = cols
        self.rows = rows
        self.spacing = spacing
        self.content = content
    }
    
    init(cols: Int, rows: Int, @ViewBuilder content: @escaping (Int, Int, Int) -> Content) {
        self.init(cols: cols, rows: rows, spacing: nil, content: content)
    }
}
