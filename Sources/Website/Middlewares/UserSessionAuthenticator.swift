import Vapor
import HTMLKit

struct UserSessionAuthenticator: AsyncSessionAuthenticator {
    
    typealias User = Website.UserModel.Output
    
    func authenticate(sessionID: String, for request: Request) async throws {
    
        if let entity = try await UserRepository(database: request.db).find(name: sessionID) {
            
            let user = UserModel.Output(entity)
            
            request.application.htmlkit.environment.add(object: IdentityMetadata(user: user))
            
            request.auth.login(user)
        }
    }
}
