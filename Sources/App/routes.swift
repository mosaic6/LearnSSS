import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("product") { req -> Product in
        let product = try req.content.decode(Product.self)
        print(product.name)
        return product
    }

    app.post("product") { req -> ProductResponse in
        let data = try req.content.decode(Product.self)
        return ProductResponse(request: data)
    }
    
}

struct Product: Content {
    var name: String
}

struct ProductResponse: Content {
    let request: Product
}
