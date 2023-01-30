//
//  File.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import CoreGraphics

extension CGRect {
    
    var end: CGPoint {
        CGPoint(
            x: origin.x + width,
            y: origin.y + height
        )
    }
}
