import HTMLKitVapor
import Vapor

// [/]
final class HomePageController {
    
    // [/]
    func getIndex(_ request: Request) async throws -> View {
        var context = EmptyContext(
            view: ViewMetadata(title: "NRS")
        )
        guard let user = request.auth.get(UserModel.Output.self) else {
            return try await request.htmlkit.render(HomePage.IndexView(context: context))
        }
        context.identity = IdentityMetadata(user: user)
        return try await request.htmlkit.render(HomePage.IndexView(context: context))
    }
}

extension HomePageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("", configure: { routes in
            
            routes.get("", use: self.getIndex)
        })
    }
}
