//
//  File.swift
//  
//
//  Created by Joshua Walsh on 12/2/21.
//

import Foundation
@testable import App
import XCTVapor
import Fluent

final class ShoppingCartTests: XCTestCase {
    var app: Application!

    enum Routes: String {
        case shoppingCart
        case shoppingCartSubmit = "shoppingCart/submit"
        case shoppingCartSave = "shoppingCart/save"
    }

    override func setUpWithError() throws {
      app = try Application.testable()
    }

    override func tearDown() {
      app.shutdown()
    }


    func testShoppingCartRoute() throws {
        let _ = try ShoppingCart.create(on: app.db)
        try app.test(.GET, "shoppingCart") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }

    func testShoppingCartSubmitRoute() throws {
        let shoppingCart = try ShoppingCart.create(on: app.db)

        try app.test(.POST, Routes.shoppingCartSubmit.rawValue, beforeRequest: { req in
            try req.content.encode(shoppingCart)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testShoppingCartSaveRoute() throws {
        try app.test(.POST, Routes.shoppingCartSave.rawValue, beforeRequest: { req in
            try req.content.encode(Product.testProduct)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
}
