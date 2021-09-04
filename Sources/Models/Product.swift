//
//  File.swift
//  File
//
//  Created by Joshua Walsh on 9/3/21.
//

import Foundation

final class Products: Model {
    // Name of the table or collection
    static let schema = "products"

    // Unique identifier for this Product.
    @ID(key: .id)
    var id: UUID?

    // The Galaxy's name.
    @Field(key: "name")
    var name: String

    // Creates a new, empty Product.
    init() { }

    // Creates a new Product with all properties set.
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
}
