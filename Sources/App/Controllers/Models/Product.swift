//
//  File.swift
//  File
//
//  Created by Joshua Walsh on 9/3/21.
//

import Vapor
import Fluent

enum Category: String, CaseIterable, Codable {
    case food
    case drink
}

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

    @Field(key: "stockQuantity")
    var stockQuantity: Int

    @Enum(key: "category")
    var category: Category

    init() {}

    init(id: UUID? = nil,
         name: String,
         description: String,
         imageURL: String,
         price: String,
         stockQuantity: Int,
         category: Category) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.stockQuantity = stockQuantity
        self.category = category
    }

    func decreaseStockQuanity() throws {
        self.stockQuantity -= 1s
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
            .field("stockQuantity", .int)
            .field("category", .enum(.init(name: "Category", cases: ["food", "drink"])))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
