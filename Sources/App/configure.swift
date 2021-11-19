import Vapor
import Fluent
import FluentMongoDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    let connectionString = "mongodb+srv://joshbnr:learnsss@cluster0.ndjmq.mongodb.net/LearnSSS?retryWrites=true&w=majority"

    try app.databases.use(.mongo(connectionString: connectionString), as: .mongo)

    // Adds models in list of migrations to run
    app.migrations.add([CreateProduct(), CreateShoppingCart()])
    app.logger.logLevel = .debug

    // Automatically runs migration and waits for result
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
