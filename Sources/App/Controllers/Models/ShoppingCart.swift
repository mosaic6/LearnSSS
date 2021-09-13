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

    static let schema = "cart"

    @ID
    var id: UUID?

    @Field(key: "orders")
    var orders: [Order]

    init() {}

    init(id: UUID? = nil, orders: [Order]) {
        self.id = id
        self.orders = orders
    }
}

// MARK: Migration

struct CreateShoppingCart: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("cart")
            .id()
            .field("orders", .array(of: .custom(Order.self)))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("cart").delete()
    }
}
