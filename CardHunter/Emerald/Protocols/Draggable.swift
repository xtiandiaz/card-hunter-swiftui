//
//  Draggable.swift
//  Emerald
//
//  Created by Cristian Diaz on 9.5.2022.
//

import Foundation
import SpriteKit

public protocol Draggable: Selectable {
    
    var dragAxis: Axis { get }
    
    func drag(to location: CGPoint)
}

extension Draggable {
    
    public func drag(to location: CGPoint) {
        position = {
            switch dragAxis {
            case .x: return CGPoint(x: location.x, y: position.y)
            case .y: return CGPoint(x: position.x, y: location.y)
            default: return location
            }
        }()
    }
}
