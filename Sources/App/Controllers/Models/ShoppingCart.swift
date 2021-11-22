//
//  File.swift
//  
//
//  Created by Guanglei Liu on 9/9/21.
//

import Vapor
import Fluent

/// A list of orders that user selected
final class ShoppingCart: Model, Content {

    static let schema = "shoppingCart"

    @ID
    var id: UUID?

    @Field(key: "products")
    var products: [Product]
    
    init() {}

    init(id: UUID? = nil, products: [Product]) {
        self.id = id
        self.products = products
    }
}

// MARK: Migration

struct CreateShoppingCart: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ShoppingCart.schema)
            .id()
            .field("products", .array(of: .custom(Product.self)))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ShoppingCart.schema).delete()
    }
}
