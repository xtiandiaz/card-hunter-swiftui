//
//  CGExtensions.swift
//  CardHunter
//
//  Created by Cristian Díaz on 23.8.2020.
//

import CoreGraphics

extension CGRect {
    
    var center: CGPoint {
        CGPoint(
            x: origin.x + width * 0.5,
            y: origin.y + height * 0.5
        )
    }
    
    var end: CGPoint {
        CGPoint(
            x: origin.x + width,
            y: origin.y + height
        )
    }
}

extension CGPoint {
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
