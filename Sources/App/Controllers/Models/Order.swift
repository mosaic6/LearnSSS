//
//  File.swift
//  
//
//  Created by Joshua Walsh on 9/13/21.
//

import Vapor
import Fluent

/// Order details of a single product
final class Order: Model, Content {

    static let schema = "order"

    @ID
    var id: UUID?

    @Field(key: "productId")
    var productId: UUID

    @Field(key: "quantity")
    var quantity: Int

    init() {}

    init(id: UUID? = nil, productId: UUID, quantity: Int) {
        self.id = id
        self.productId = productId
        self.quantity = quantity
    }
}

// MARK: Migration

struct CreateOrder: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("order")
            .id()
            .field("productId", .uuid, .required)
            .field("quantity", .int)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("order").delete()
    }
}
