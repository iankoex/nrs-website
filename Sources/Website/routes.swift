import Vapor
import HTMLKitVapor

func routes(_ app: Application) throws {
    
    try app.register(collection: HomePageController())
    try app.register(collection: LoginPageController())
    
    try app.group("employees") { routes in
        let group = routes.grouped(app.sessions.middleware, UserSessionAuthenticator(), UserModel.Output.redirectMiddleware(path: "/login"))
        try group.register(collection: EmployeesPageController())
    }
    
    try app.group("admin") { routes in
        let group = routes.grouped(app.sessions.middleware, UserSessionAuthenticator(), UserModel.Output.redirectMiddleware(path: "/login/admin"))
        try group.register(collection: AdminPageController())
    }
}
