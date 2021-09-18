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
    app.get("products", ":id") { req -> EventLoopFuture<Product> in
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    let product = app.grouped("product")

    // Create a single product to post to the DB
    product.post("submit") { req -> EventLoopFuture<Product> in
        let product = try req.content.decode(Product.self)
        return product.create(on: req.db).map { product }
    }

    // MARK: - Shopping Cart

    let shoppingCart = app.grouped("shoppingCart")

    /// Submit orders in the shopping cart
    shoppingCart.post("submit") { req -> EventLoopFuture<ShoppingCart> in
        let shoppingCart = try req.content.decode(ShoppingCart.self)

        // decrease product stockQuantity count
        for order in shoppingCart.orders {
            updateProduct(id: order.productId, quantity: order.quantity, req: req)
        }

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

// MARK: - Product Helpers

func updateProduct(id: UUID, quantity: Int, req: Request) {
    _ = Product.find(id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { item -> EventLoopFuture<Void> in
        item.decreaseStockQuanity(quantity: quantity)
        return item.update(on: req.db)
    }
}
