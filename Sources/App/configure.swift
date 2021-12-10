import Vapor
import Fluent
import FluentMongoDriver
import FluentPostgresDriver


// configures your application
public func configure(_ app: Application) throws {
    let connectionString = "mongodb+srv://joshbnr:learnsss@cluster0.ndjmq.mongodb.net/LearnSSS?retryWrites=true&w=majority"

    if app.environment == .testing {
        app.databases.use(.postgres(hostname: "localhost",
                                    port: 5433,
                                    username: "vapor_username",
                                    password: "vapor_password",
                                    database: "vapor-test"),
                          as: .psql)
    } else {
        try app.databases.use(.mongo(connectionString: connectionString), as: .mongo)
    }
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateShoppingCart())

    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    try routes(app)
}
