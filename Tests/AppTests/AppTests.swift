@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }

    func testShoppingCartSubmit() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "shoppingCart/submit", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let shoppingCart = try res.content.decode(ShoppingCart.self)
            XCTAssertEqual(shoppingCart.orders.count, 1)
        })
    }
}
