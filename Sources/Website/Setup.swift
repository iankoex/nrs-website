import FluentPostgresDriver
import Foundation
import HTMLKitVapor
import Vapor

@main
public struct Setup {
    
    public static func main() throws {
        
        var env = try Environment.detect()
        
        try LoggingSystem.bootstrap(from: &env)
        
        let app = Application(env)
        
        defer { app.shutdown() }
        
        try configure(app)
        try app.run()
    }
}
