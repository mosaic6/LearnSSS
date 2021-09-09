import Vapor

func routes(_ app: Application) throws {

    app.get("products") { req -> [Product] in
        return Stub().products
    }

    app.post("product") { req -> ProductResponse in
        let data = try req.content.decode(Product.self)
        return ProductResponse(request: data)
    }
    
}

struct ProductResponse: Content {
    let request: Product
}
