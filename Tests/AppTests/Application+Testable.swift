//
//  File.swift
//  
//
//  Created by Joshua Walsh on 12/3/21.
//

import XCTVapor
import Vapor
import App

extension Application {
    static func testable() throws -> Application {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.autoRevert().wait()
        try app.autoMigrate().wait()

        return app
    }
}
