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

}
