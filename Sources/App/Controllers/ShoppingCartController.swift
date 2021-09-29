//
//  File.swift
//  
//
//  Created by Joshua Walsh on 9/29/21.
//

import Foundation
import Vapor

struct ShoppingCartController {
    func submit(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)

        // decrease product stockQuantity count
        for order in shoppingCart.orders {
            updateProductStockCount(id: order.productId, quantity: order.quantity, req: req)
        }

        return shoppingCart.create(on: req.db)
            .map { shoppingCart }
    }

    func save(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.save(on: req.db).map {
            shoppingCart
        }
    }

    func update(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.update(on: req.db).map { shoppingCart }
    }

    func delete(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.delete(on: req.db).map { shoppingCart }
    }
}
