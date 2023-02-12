import HTMLKitVapor
import Vapor

// [/admin]
final class AdminPageController {
    
    // [/]
    func getIndex(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let repo = ShiftRepository(database: request.db)
        let report = try await repo.getOverviewReport()
        let context = ItemContext(
            view: ViewMetadata(title: "Admin"),
            identity: IdentityMetadata(user: user),
            item: report
        )
        return try await request.htmlkit.render(AdminPage.IndexView(context: context))
    }
    
    // [/createItem]
    func createItem(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let context = EmptyContext(
            view: ViewMetadata(title: "Create Item"),
            identity: IdentityMetadata(user: user)
        )
        return try await request.htmlkit.render(AdminPage.CreateItemView(context: context))
    }
    
    // [/createItem/:model]
    func createItemPost(_ request: Request) async throws -> Response {
        //        guard let user = request.auth.get(UserModel.Output.self) else {
        //            throw Abort(.unauthorized)
        //        }
        try ItemModel.Input.validate(content: request)
        let model = try request.content.decode(ItemModel.Input.self)
        let repo = ItemRepository(database: request.db)
        try await repo.createItem(model)
        return request.redirect(to: "/employees")
    }
    
    func getActivities(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let repo = ItemRepository(database: request.db)
        let activities = try await repo.getAllActivities()
        let context = ItemsContext(
            view: ViewMetadata(title: "All Activities"),
            identity: IdentityMetadata(user: user),
            items: activities
        )
        return try await request.htmlkit.render(AdminPage.ActivityView(context: context))
    }
}

extension AdminPageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("", configure: { routes in
            
            routes.get("", use: self.getIndex)
            routes.get("createItem", use: self.createItem)
            routes.post("createItem", use: self.createItemPost)
            routes.get("activities", use: self.getActivities)
        })
    }
}
