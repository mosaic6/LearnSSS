//
//  File.swift
//  
//
//  Created by Guanglei Liu on 9/9/21.
//

import Vapor

/// A list of orders that user selected
struct ShoppingCart: Content {
    var id: Int
    var orders: [Order]
}

/// Order details of a single product
struct Order: Content {
    var productId: Int
    var quantity: Int
}
