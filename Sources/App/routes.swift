import Vapor
import Fluent
import FluentMongoDriver

func routes(_ app: Application) throws {

    // MARK: - Product

    /// Returns all products with basic information
    app.get("products") { req -> EventLoopFuture<[Product]> in
        return Product.query(on: req.db).all()
    }

    /// Returns single product with details
    app.get("product", ":id", "details") { req -> Product in
        guard let id = req.parameters.get("id", as: UUID.self
        ) else {
            throw Abort(.badRequest)
        }

        guard let product = Stub().products.first(where: { product in
            product.id == id
        }) else {
            throw Abort(.badRequest)
        }

        return product
    }

    // MARK: - Shopping Cart

    let shoppingCart = app.grouped("shoppingCart")

    /// Submit orders in the shopping cart
    shoppingCart.post("submit") { req -> EventLoopFuture<ShoppingCart> in
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.create(on: req.db)
            .map { shoppingCart }
    }

    /// Save the shopping cart
    shoppingCart.post("save") { req -> EventLoopFuture<ShoppingCart> in
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.save(on: req.db).map {
            shoppingCart
        }
    }

    /// Replace the shopping cart in database
    shoppingCart.put("update") { req -> EventLoopFuture<ShoppingCart> in
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.update(on: req.db).map { shoppingCart }
    }

    /// Delete the shopping cart in database
    shoppingCart.delete("delete") { req -> EventLoopFuture<ShoppingCart> in
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        return shoppingCart.delete(on: req.db).map { shoppingCart }
    }
}
