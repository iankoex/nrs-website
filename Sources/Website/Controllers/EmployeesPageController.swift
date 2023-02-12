import HTMLKitVapor
import Vapor

// [/employees]
final class EmployeesPageController {
    
    // [/]
    func getIndex(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let repo = ShiftRepository(database: request.db)
        let currentShift = try await repo.currentShift()
        let context = EmployeesPageIndexViewContext(
            view: ViewMetadata(title: "Dashboard"),
            identity: IdentityMetadata(user: user),
            shift: currentShift
        )
        return try await request.htmlkit.render(EmployeesPage.IndexView(context: context))
    }
    
    // [/startShift]
    func startShift(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let context = EmptyContext(
            view: ViewMetadata(title: "Start Shift"),
            identity: IdentityMetadata(user: user)
        )
        return try await request.htmlkit.render(EmployeesPage.StartShiftView(context: context))
    }
    
    // [/startShift/:model]
    func startShiftPost(_ request: Request) async throws -> Response {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let repo = ShiftRepository(database: request.db)
        let currentShift = try await repo.currentShift()
        guard currentShift == nil else {
            throw Abort(.notAcceptable, reason: "A shift is already underway")
        }
        try ShiftModel.Input.validate(content: request)
        let model = try request.content.decode(ShiftModel.Input.self)
        let entity = ShiftModel(openedByID: user.id, startingBalance: model.startingBalance)
        try await repo.insert(entity)
        return request.redirect(to: "/employees")
    }
    
    // [closeShift/:modelID]
    func closeShift(_ request: Request) async throws -> Response {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        guard let shift = try await ShiftModel.find(request.parameters.get("shiftID"), on: request.db) else {
            throw Abort(.notFound)
        }
        let repo = ShiftRepository(database: request.db)
        try await repo.closeShift(shift, by: user)
        return request.redirect(to: "/employees")
    }
    
    // [/restockItem]
    func restockItem(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let shiftRepo = ShiftRepository(database: request.db)
        let currentShift = try await shiftRepo.currentShift()
        let repo = ItemRepository(database: request.db)
        let items = try await repo.allItems()
        let context = RestockProduceItemContext(
            view: ViewMetadata(title: "Restock Item"),
            identity: IdentityMetadata(user: user),
            items: items,
            activityType: .stocking,
            shift: currentShift
        )
        let page = EmployeesPage.RestockProduceItemView(context: context)
        return try await request.htmlkit.render(page)
    }
    
    // [/restockItem/:model]
    func restockItemPost(_ request: Request) async throws -> Response {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        try ItemActivityModel.Input.validate(content: request)
        let model = try request.content.decode(ItemActivityModel.Input.self)
        let shiftRepo = ShiftRepository(database: request.db)
        let itemRepo = ItemRepository(database: request.db)
        try await itemRepo.restockItem(model, by: user, on: shiftRepo)
        return request.redirect(to: "/employees")
    }
    
    // [/produceItem]
    func produceItem(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let shiftRepo = ShiftRepository(database: request.db)
        let currentShift = try await shiftRepo.currentShift()
        let repo = ItemRepository(database: request.db)
        let items = try await repo.allItems()
        let context = RestockProduceItemContext(
            view: ViewMetadata(title: "Produce Item"),
            identity: IdentityMetadata(user: user),
            items: items,
            activityType: .production,
            shift: currentShift
        )
        let page = EmployeesPage.RestockProduceItemView(context: context)
        return try await request.htmlkit.render(page)
    }
    
    // [/produceItem/:model]
    func produceItemPost(_ request: Request) async throws -> Response {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        try ItemActivityModel.Input.validate(content: request)
        let model = try request.content.decode(ItemActivityModel.Input.self)
        let shiftRepo = ShiftRepository(database: request.db)
        let itemRepo = ItemRepository(database: request.db)
        try await itemRepo.produceItem(model, by: user, on: shiftRepo)
        return request.redirect(to: "/employees")
    }
    
    // [/sellItem]
    func sellItem(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        let shiftRepo = ShiftRepository(database: request.db)
        let currentShift = try await shiftRepo.currentShift()
        let repo = ItemRepository(database: request.db)
        let items = try await repo.allItems()
        let context = RestockProduceItemContext(
            view: ViewMetadata(title: "Sell Item"),
            identity: IdentityMetadata(user: user),
            items: items,
            activityType: .sale,
            shift: currentShift
        )
        let page = EmployeesPage.RestockProduceItemView(context: context)
        return try await request.htmlkit.render(page)
    }
    
    // [/sellItem/:model]
    func sellItemPost(_ request: Request) async throws -> Response {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        try ItemActivityModel.Input.validate(content: request)
        let model = try request.content.decode(ItemActivityModel.Input.self)
        let shiftRepo = ShiftRepository(database: request.db)
        let itemRepo = ItemRepository(database: request.db)
        let activityID = try await itemRepo.sellItem(model, by: user, on: shiftRepo)
        if itemRepo.getPaymentMethod(from: model.paymentMethodStr) == .credit {
            return request.redirect(to: "/employees/creditUser/\(activityID)")
        }
        return request.redirect(to: "/employees")
    }
    
    // [/creditUser]
    func creditUser(_ request: Request) async throws -> View {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        guard let activity = try await ItemActivityModel.find(request.parameters.get("activityID"), on: request.db) else {
            throw Abort(.notAcceptable, reason: "Activity Could Not Be Found")
        }
        let shiftRepo = ShiftRepository(database: request.db)
        let currentShift = try await shiftRepo.currentShift()
        let usersRepo = UserRepository(database: request.db)
        let names = try await usersRepo.getUsersNames()
        let context = CreditUserContext(
            view: ViewMetadata(title: "Charge Customer"),
            identity: IdentityMetadata(user: user),
            items: names,
            amount: activity.value,
            shift: currentShift
        )
        let page = EmployeesPage.CreditUserView(context: context)
        return try await request.htmlkit.render(page)
    }
    
    // [/creditUser/:model]
    func creditUserPost(_ request: Request) async throws -> Response {
        guard let user = request.auth.get(UserModel.Output.self) else {
            throw Abort(.unauthorized)
        }
        try CreditModel.Input.validate(content: request)
        let input = try request.content.decode(CreditModel.Input.self)
        let activityIDStr = request.parameters.get("activityID")
        guard let activityID = UUID(uuidString: activityIDStr ?? "") else {
            throw Abort(.badRequest, reason: "Failed to get activityID")
        }
        let shiftRepo = ShiftRepository(database: request.db)
        try await shiftRepo.creditUser(input, by: user, from: activityID)
        return request.redirect(to: "/employees")
    }
}

extension EmployeesPageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.group("", configure: { routes in
            
            routes.get("", use: self.getIndex)
            routes.get("startShift", use: self.startShift)
            routes.post("startShift", use: self.startShiftPost)
            routes.get("closeShift", ":shiftID", use: self.closeShift)
            routes.get("restockItem", use: self.restockItem)
            routes.post("restockItem", use: self.restockItemPost)
            routes.get("produceItem", use: self.produceItem)
            routes.post("produceItem", use: self.produceItemPost)
            routes.get("sellItem", use: self.sellItem)
            routes.post("sellItem", use: self.sellItemPost)
            routes.get("creditUser", ":activityID", use: self.creditUser)
            routes.post("creditUser", ":activityID", use: self.creditUserPost)
        })
    }
}
