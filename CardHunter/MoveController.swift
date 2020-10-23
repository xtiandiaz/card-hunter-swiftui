//
//  MoveController.swift
//  CardHunter
//
//  Created by Cristian Díaz on 23.10.2020.
//

import Foundation

enum Move {
    
    case advance
    case store
    case attack
    case consume
}

class MoveController {
    
    init(inventoryController: InventoryController) {
        self.inventoryController = inventoryController
    }
    
    func resolve(from origin: Slot, to destination: Slot) -> Move? {
        guard let card = origin.topCard else {
            return nil
        }
        
        switch origin.type {
        case .field:
            guard let avatar = card as? AvatarCard else {
                return nil
            }
            
            if destination.isEmpty {
                return commit(move: .advance, from: origin, to: destination)
            } else if let target = destination.topCard {
                switch target {
                case let collectible as Collectible:
                    if inventoryController.store(collectible: collectible) {
                        destination.popCard()
                        
                        return commit(move: .store, from: origin, to: destination)
                    }
                case let consumable as Consumable:
                    avatar.metrics.add(value: consumable.consumableValue, toKey: consumable.consumableKey)
                    consumable.consume()
                    
                    return commit(move: .consume, from: origin, to: destination)
                    
                case let destructible as Destructible:
                    let destructibleHealth = destructible.health
                    destructible.damage(withValue: avatar.health)
                    avatar.damage(withValue: destructibleHealth)
                    
                    return commit(move: .attack, from: origin, to: destination)
                    
                default: return nil
                }
            }
        default:
            return nil
        }
        
        return nil
    }
    
    private func commit(move: Move, from origin: Slot, to destination: Slot) -> Move? {
        if let card = origin.topCard, destination.pushCard(card) {
            origin.popCard()
            return move
        }
        return nil
    }
    
    // MARK: Private
    
    private let inventoryController: InventoryController
}
