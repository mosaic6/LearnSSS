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

        try _ = decreaseProductStockCount(req: req, in: shoppingCart)

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

// MARK: - Helpers

func decreaseProductStockCount(req: Request, in shoppingCart: ShoppingCart) throws -> EventLoopFuture<Product>? {
    for product in shoppingCart.orders {
        return Product.find(product.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                if product.stockQuantity > 0 {
                    product.stockQuantity -= 1
                }
                return product.save(on: req.db)
                    .map { Product(id: product.id,
                                   name: product.name,
                                   description: product.description,
                                   imageURL: product.imageURL,
                                   price: product.price,
                                   stockQuantity: product.stockQuantity,
                                   category: product.category) }
            }
    }

    return nil
}
