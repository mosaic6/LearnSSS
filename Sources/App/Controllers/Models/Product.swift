//
//  File.swift
//  File
//
//  Created by Joshua Walsh on 9/3/21.
//

import Vapor
import Fluent

final class Product: Model, Content {

    static let schema = "products"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    @Field(key: "imageURL")
    var imageURL: String

    @Field(key: "price")
    var price: String

    @Field(key: "quantity")
    var quantity: Int

    init() {}

    init(id: UUID? = nil, name: String, description: String, imageURL: String, price: String, quantity: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.quantity = quantity
    }
}

// MARK: Migration

struct CreateProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("description", .string)
            .field("imageURL", .string)
            .field("price", .string)
            .field("quantity", .int)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
