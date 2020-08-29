//
//  File.swift
//  CardHunter
//
//  Created by Cristian Díaz on 29.8.2020.
//

import CoreGraphics

extension CGSize {
    
    static func +(left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}
