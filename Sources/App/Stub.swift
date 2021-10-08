//
//  File.swift
//  
//
//  Created by Guanglei Liu on 9/8/21.
//

import Foundation

class Stub {
    var products: [Product] = [
        Product(
            id: UUID(uuidString: "1"),
            name: "Coconut Cupcakes",
            description: """
            Easy Chocolate Coconut Cupcakes are ultra tender and moist chocolate cupcakes topped with homemade coconut buttercream frosting and toasted coconut. Add some egg candies and it's the perfect Easter treat!
            """,
            imageURL: "https://www.handletheheat.com/wp-content/uploads/2020/03/Homemade-Chocolate-Coconut-Cupcakes-SQUARE-02-1536x1536.jpg",
            price: "7.00",
            stockQuantity: 9,
            isFeatured: true,
            category: .food
        ),
        Product(
            id: UUID(uuidString: "3"),
            name: "Chocolate Chip Cookie",
            description: """
            This Chocolate Chip Cookie Cake recipe features a thick base of chewy and slightly gooey chocolate chip cookie topped with creamy vanilla buttercream and garnished with ALL the sprinkles. It's the perfect birthday cake for any cookie lover!
            """,
            imageURL: "https://www.handletheheat.com/wp-content/uploads/2016/07/Chocolate-Chip-Cookie-Cake-SQUARE-1536x1536.jpg",
            price: "8.00",
            stockQuantity: 10,
            isFeatured: false,
            category: .food
        ),
        Product(
            id: UUID(uuidString: "3"),
            name: "Lemon Cupcakes",
            description: """
            Easy homemade Lemon Cupcakes with lemon cream cheese frosting have the perfect balance of sweet and tanginess and are perfect for spring, Easter, or Mother's Day!
            """,
            imageURL: "https://www.handletheheat.com/wp-content/uploads/2019/03/lemon-cupcakes-SQUARE-02.jpg",
            price: "9.00",
            stockQuantity: 11,
            isFeatured: false,
            category: .food
        )
    ]
}
