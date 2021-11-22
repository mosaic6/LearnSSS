//
//  File.swift
//  
//
//  Created by Joshua Walsh on 9/29/21.
//

import Foundation
import Vapor

struct ShoppingCartController {

    /// Fetch a shopping cart
    func read(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        return ShoppingCart.query(on: req.db).first()
            .unwrap(or: Abort(.notFound))
    }

    /// Submitting a shopping cart will perform the following actions
    /// - Update the product stock quantity
    /// - Remove/Delete the shopping cart object from the database
    func submit(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)

        // decrease product stockQuantity count
        for product in shoppingCart.products {
            guard let productId = product.id else {
                throw Abort(.notFound)
            }
            updateProductStockCount(id: productId, quantity: product.selectedQuantity, req: req)
        }

        return ShoppingCart()
            .delete(on: req.db)
            .map { .ok }
    }

    /// Saves a single shopping cart
    func save(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        
        return shoppingCart
            .save(on: req.db)
            .map {
                shoppingCart
            }
    }

    /// Updates a single shopping cart
    func update(req: Request) throws -> EventLoopFuture<ShoppingCart> {
        let shoppingCart = try req.content.decode(ShoppingCart.self)

        return ShoppingCart.query(on: req.db).first()
            .unwrap(or: Abort(.notFound))
            .flatMap { cart in
                cart.products = shoppingCart.products
                return cart.save(on: req.db)
                    .map { ShoppingCart(id: cart.id, products: cart.products)}
            }
    }

    /// Removes the shopping cart from the database
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ShoppingCart.query(on: req.db).first()
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
}
