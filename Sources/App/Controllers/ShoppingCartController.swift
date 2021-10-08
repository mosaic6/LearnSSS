//
//  File.swift
//  
//
//  Created by Joshua Walsh on 9/29/21.
//

import Foundation
import Vapor

struct ShoppingCartController {

    /// Fetch a shopping cart by ID
    func read(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return ShoppingCart.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    /// Submitting a shopping cart will perform the following actions
    /// - Update the product stock quantity
    /// - Remove/Delete the shopping cart object from the database
    func submit(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        let shoppingCart = try req.content.decode(ShoppingCart.self)

        // decrease product stockQuantity count
        for order in shoppingCart.orders {
            guard let productId = order.product.id else {
                throw Abort(.notFound)                
            }
            updateProductStockCount(id: productId, quantity: order.quantity, req: req)
        }

        return ShoppingCart.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }

    /// Saves a single shopping cart
    func save(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.save(on: req.db).map {
            shoppingCart
        }
    }

    /// Updates a single shopping cart
    func update(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        let shoppingCart = try req.content.decode(ShoppingCart.self)

        return ShoppingCart.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { cart in
                cart.orders = shoppingCart.orders
                return cart.save(on: req.db)
                    .map { ShoppingCart(id: cart.id, orders: cart.orders)}
            }
    }

    /// Removes the shopping cart from the database
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return ShoppingCart.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
}
