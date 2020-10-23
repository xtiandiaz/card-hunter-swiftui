//
//  InventoryController.swift
//  CardHunter
//
//  Created by Cristian Díaz on 23.10.2020.
//

import Foundation

class InventoryController {
    
    init(weaponSlot: Slot) {
        self.weaponSlot = weaponSlot
    }
    
    func store(collectible: Collectible) -> Bool {
        let result: Bool
        defer {
            collectible.isCollected = result
        }
        
        switch collectible.type {
        case .weapon:
            result = weaponSlot.pushCard(collectible)
        default:
            result = false
        }
        
        return result
    }
    
    // MARK: Private
    
    private let weaponSlot: Slot
}
