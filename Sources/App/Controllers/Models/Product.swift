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

    @ID(key: .id)
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

    @Field(key: "selectedQuantity")
    var selectedQuantity: Int

    @Field(key: "isFeatured")
    var isFeatured: Bool

    @Enum(key: "category")
    var category: Category

    init() {}

    init(id: UUID? = nil,
         name: String,
         description: String,
         imageURL: String,
         price: String,
         stockQuantity: Int,
         selectedQuantity: Int,
         isFeatured: Bool,
         category: Category) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.stockQuantity = stockQuantity
        self.selectedQuantity = selectedQuantity
        self.isFeatured = isFeatured
        self.category = category
    }

    func decreaseStockQuanity(quantity: Int) {
        if self.stockQuantity > 0 {
            self.stockQuantity -= quantity
        }
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
            .field("selectedQuantity", .int)
            .field("isFeatured", .bool)
            .field("category", .enum(.init(name: "Category", cases: ["food", "drink"])))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}

// MARK: - Product Helpers

func updateProductStockCount(id: UUID, quantity: Int, req: Request) {
    _ = Product.find(id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { item -> EventLoopFuture<Void> in
        item.decreaseStockQuanity(quantity: quantity)
        return item.update(on: req.db)
    }
}
