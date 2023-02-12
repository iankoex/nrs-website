import FluentPostgresDriver
import Foundation
import HTMLKitVapor
import Vapor

public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)
    
    app.sessions.use(.memory)
    
    app.passwords.use(.bcrypt)
    
//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//    ), as: .psql)
    if let databaseURL = Environment.get("DATABASE_URL"), let postgresConfig = PostgresConfiguration(url: databaseURL) {
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }
    
    try routes(app)
    
    app.migrations.add(CredentialMigration())
    app.migrations.add(UserModel.Migration())
    app.migrations.add(ShiftModel.Migration())
    app.migrations.add(ItemModel.Migration())
    app.migrations.add(ItemActivityModel.Migration())
    app.migrations.add(CreditModel.Migration())
    
//    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    
    try app.run()
}
