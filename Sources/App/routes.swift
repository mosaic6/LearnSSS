import Vapor

func routes(_ app: Application) throws {

    // MARK: - Product

    /// Returns all products with basic information
    app.get("products") { req -> [Product] in
        // FIXME: Use real database in future PR
        return Stub().products
    }

    /// Returns single product with details
    app.get("product", ":productId", "details") { req -> Product in
        guard let id = req.parameters.get("productId", as: Int.self
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
    shoppingCart.post("submit") { req -> HTTPStatus in
        let shoppingCart = try req.content.decode(ShoppingCart.self)
        print(shoppingCart.orders.count)
        // FIXME: Check with data base and ensure there is enough project.
        return .ok
    }
}
