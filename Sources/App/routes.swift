import Vapor
import Fluent
import FluentMongoDriver

func routes(_ app: Application) throws {

    // MARK: - Controllers
    let productsController = ProductsController()
    let shoppingCartController = ShoppingCartController()

    // MARK: - Products

    /// Returns all products with basic information
    app.get("products", use: productsController.readAll)
    /// Returns single product with details
    app.get("products", ":id", use: productsController.read)

    // MARK: - Shopping Cart

    let shoppingCart = app.grouped("shoppingCart")
    /// Submit orders in the shopping cart
    shoppingCart.post("submit", use: shoppingCartController.submit)
    /// Save the shopping cart
    shoppingCart.post("save", use: shoppingCartController.save)
    /// Replace the shopping cart in database
    shoppingCart.put("update", use: shoppingCartController.update)
    /// Delete the shopping cart in database
    shoppingCart.delete("delete", ":id", use: shoppingCartController.delete)
}


