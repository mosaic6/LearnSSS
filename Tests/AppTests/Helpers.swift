//
//  File.swift
//  
//
//  Created by Joshua Walsh on 12/2/21.
//

import Foundation
@testable import App
import Fluent
import XCTVapor

extension Product {
    /// A single testable Product
    static let testProduct = Product(id: UUID(),
                                     name: "A good name",
                                     description: "a good description",
                                     imageURL: "www.imageURL.com",
                                     price: "10.00",
                                     stockQuantity: 100,
                                     selectedQuantity: 1,
                                     isFeatured: false
//                                     category: .food
    )

    static func create(
        id: UUID = UUID(),
        name: String = "Product name",
        description: String = "Product description",
        imageURL: String = "Image URL",
        price: String = "10.00",
        stockQuantity: Int = 100,
        selectdQuantity: Int = 1,
        isFeatured: Bool = false,
//        category: App.Category = App.Category.food,
        on database: Database
    ) throws -> Product {
        let product = Product(id: id,
                              name: name,
                              description: description,
                              imageURL: imageURL,
                              price: price,
                              stockQuantity: stockQuantity,
                              selectedQuantity: selectdQuantity,
                              isFeatured: isFeatured
//                              category: .food
        )
        try product.save(on: database).wait()
        return product
    }
}

extension App.ShoppingCart {
    /// A single testable ShoppingCart
    static let testShoppingCart = ShoppingCart(id: UUID(), products: [Product.testProduct])

    /// Create a testable ShoppingCart on the database
    static func create(
        id: UUID = UUID(),
        products: [Product] = [Product.testProduct],
        on database: Database
    ) throws -> ShoppingCart {
        let cart = ShoppingCart(id: id, products: products)
        try cart.save(on: database).wait()
        return cart
    }
}
