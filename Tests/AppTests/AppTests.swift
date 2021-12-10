@testable import App
import XCTVapor
import Fluent

final class AppTests: XCTestCase {
    var app: Application!

    enum Routes: String {
        case products
    }

    override func setUp() {
        super.setUp()

        app = try! Application.testable()
    }

    override func tearDown() {
        app = nil

        super.tearDown()
    }


    func testProductRoute() throws {
        let _ = try Product.create(on: app.db)

        try app.test(.GET, Routes.products.rawValue) { res in
            sleep(1)
            XCTAssertEqual(res.status, .ok)
        }
    }
    
}
