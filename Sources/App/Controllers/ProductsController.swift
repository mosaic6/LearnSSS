//
//  File.swift
//  
//
//  Created by Joshua Walsh on 9/29/21.
//

import Foundation
import Vapor

struct ProductsController {
    func readAll(req: Request) throws -> EventLoopFuture<[Product]> {
        return Product.query(on: req.db).all()
    }

    func read(req: Request) throws -> EventLoopFuture<Product> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
