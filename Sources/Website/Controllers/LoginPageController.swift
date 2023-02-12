import HTMLKitVapor
import Vapor

// [/login]
final class LoginPageController {
    // [/]
    func getLogin(_ request: Request) async throws -> View {
        let context = EmptyContext(
            view: ViewMetadata(title: "Register account")
        )
        
        return try await request.htmlkit.render(LoginPage.LoginView(context: context))
    }
    
    // [/:model]
    func postLogin(_ request: Request) async throws -> Response {
        
        try LoginModel.Input.validate(content: request)
        
        let model = try request.content.decode(LoginModel.Input.self)
        
        guard let entity = try await UserRepository(database: request.db).find(name: model.email) else {
            return request.redirect(to: "/login/")
        }
        guard let credential = entity.credential else {
            return request.redirect(to: "/login")
        }
        
        if try! request.password.verify(model.password, created: credential.password) {
            
            let model = UserModel.Output(entity)
            
            request.session.authenticate(model)
            
            return request.redirect(to: "/employees")
        }
        
        return request.redirect(to: "/login/login")
    }
    
    // [/admin]
    func adminLogin(_ request: Request) async throws -> View {
        let context = EmptyContext(
            view: ViewMetadata(title: "Register account")
        )
        
        return try await request.htmlkit.render(LoginPage.AdminLoginView(context: context))
    }
    
    // [/admin/:model]
    func adminLoginPost(_ request: Request) async throws -> Response {
        
        try LoginModel.Input.validate(content: request)
        
        let model = try request.content.decode(LoginModel.Input.self)
        
        guard let entity = try await UserRepository(database: request.db).find(name: model.email) else {
            return request.redirect(to: "/login/admin")
        }
        guard let credential = entity.credential else {
            return request.redirect(to: "/login/admin")
        }
        
        if try! request.password.verify(model.password, created: credential.password) {
            
            let model = UserModel.Output(entity)
            
            request.session.authenticate(model)
            
            return request.redirect(to: "/admin")
        }
        
        return request.redirect(to: "/login/admin")
    }
    
    // [/register]
    func getRegister(_ request: Request) async throws -> View {
        let context = CreateContext(
            view: ViewMetadata(title: "Register account")
        )
        return try await request.htmlkit.render(LoginPage.RegisterView(context: context))
    }
    
    // [/register/:model]
    func postRegister(_ request: Request) async throws -> Response {
        
        try RegisterModel.Input.validate(content: request)
        
        let model = try request.content.decode(RegisterModel.Input.self)
        
        let digest = try request.password.hash(model.password)
        
        try await CredentialRepository(database: request.db)
            .insert(entity: CredentialEntity(password: digest, role: CredentialModel.Roles.administrator.rawValue, status: CredentialModel.States.unlocked.rawValue), with: UserModel(email: model.email))
        
        return request.redirect(to: "/login")
    }
    
    // [/logout]
    func getLogout(_ request: Request) async throws -> Response {
        
        request.auth.logout(UserModel.Output.self)
        request.session.unauthenticate(UserModel.Output.self)
        
        return request.redirect(to: "/")
    }
    
    // [/reset]
    func getReset(_ request: Request) async throws -> View {
        
       
        
        let context = CreateContext(
            view: ViewMetadata(title: "Reset")
        )
        
        return try await request.htmlkit.render(LoginPage.ResetView(context: context))
    }
    
    // [/reset/:model]
    func postReset(_ request: Request) async throws -> Response {
        return request.redirect(to: "/login")
    }
}

extension LoginPageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("login", configure: { routes in
            
            routes.get("", use: self.getLogin)
            routes.post("", use: self.postLogin)
            routes.get("register", use: self.getRegister)
            routes.post("register", use: self.postRegister)
            routes.get("logout", use: self.getLogout)
            routes.get("reset", use: self.getReset)
            routes.post("reset", use: self.postReset)
            routes.get("admin", use: self.adminLogin)
            routes.post("admin", use: self.adminLoginPost)
        })
    }
}
