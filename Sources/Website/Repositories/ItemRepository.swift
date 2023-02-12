import Fluent
import Foundation
import Vapor

final class ItemRepository {
    
    let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func find(using title: String) async throws -> ItemModel {
        let item = try await ItemModel.query(on: database)
            .filter(\.$title == title)
            .first()
        guard let item = item else {
            throw Abort(.notFound, reason: "Could Not Find Item")
        }
        return item
    }
    
    func createItem(_ input: ItemModel.Input) async throws {
        let item = ItemModel(
            title: input.title,
            description: input.description,
            portions: input.portions,
            value: input.value
        )
        try await item.create(on: database)
    }
    
    func allItems() async throws -> [String] {
        let items = try await ItemModel.query(on: database)
            .sort(\.$title)
            .field(\.$title)
            .all()
        return items.map { $0.title }
    }
    
    func getPaymentMethod(from value: String?) -> ItemActivityModel.PaymentMethod {
        if value == ItemActivityModel.PaymentMethod.cash.rawValue {
            return .cash
        }
        if value == ItemActivityModel.PaymentMethod.mpesa.rawValue {
            return .mpesa
        }
        if value == ItemActivityModel.PaymentMethod.credit.rawValue {
            return .credit
        }
        return .cash
    }
    
    func restockItem(_ input: ItemActivityModel.Input, by user: UserModel.Output, on shiftRepo: ShiftRepository) async throws {
        let item = try await self.find(using: input.itemTitle)
        guard let shift = try await shiftRepo.currentShift() else {
            throw Abort(.notAcceptable, reason: "No Current Shift")
        }
        let paymentMethod = getPaymentMethod(from: input.paymentMethodStr)
        let activity = ItemActivityModel(
            itemID: try item.requireID(),
            shiftID: shift.id,
            perfomedByID: user.id,
            portions: input.portions,
            value: input.value,
            activityType: .stocking,
            paymentMethod: paymentMethod
        )
        let shiftModel = try await shiftRepo.find(using: shift.id)
        item.value += input.value
        item.portions += input.portions
        shiftModel.currentBalance -= input.value
        try await activity.create(on: database)
        try await item.update(on: database)
        try await shiftModel.update(on: database)
    }
    
    func produceItem(_ input: ItemActivityModel.Input, by user: UserModel.Output, on shiftRepo: ShiftRepository) async throws {
        let item = try await self.find(using: input.itemTitle)
        guard let shift = try await shiftRepo.currentShift() else {
            throw Abort(.notAcceptable, reason: "No Current Shift")
        }
        let activity = ItemActivityModel(
            itemID: try item.requireID(),
            shiftID: shift.id,
            perfomedByID: user.id,
            portions: input.portions,
            value: input.value,
            activityType: .production,
            paymentMethod: .cash
        )
        item.value -= input.value
        item.portions -= input.portions
        try await activity.create(on: database)
        try await item.update(on: database)
    }
    
    func sellItem(_ input: ItemActivityModel.Input, by user: UserModel.Output, on shiftRepo: ShiftRepository) async throws -> UUID {
        let item = try await self.find(using: input.itemTitle)
        guard let shift = try await shiftRepo.currentShift() else {
            throw Abort(.notAcceptable, reason: "No Current Shift")
        }
        let paymentMethod = getPaymentMethod(from: input.paymentMethodStr)
        let activity = ItemActivityModel(
            id: UUID(),
            itemID: try item.requireID(),
            shiftID: shift.id,
            perfomedByID: user.id,
            portions: input.portions,
            value: input.value,
            activityType: .sale,
            paymentMethod: paymentMethod
        )
        item.value -= input.value
        item.portions -= input.portions
        try await activity.create(on: database)
        try await item.update(on: database)
        return try activity.requireID()
    }
    
    func getAllActivities() async throws -> [ItemActivityModel.Output] {
        let activities = try await ItemActivityModel.query(on: database)
            .with(\.$shift) { shift in
                shift.with(\.$openedBy) { openedBy in
                    openedBy.with(\.$credential)
                }
                shift.with(\.$closedBy) { closedBy in
                    closedBy.with(\.$credential)
                }
            }
            .with(\.$item)
            .with(\.$performedBy) { user in
                user.with(\.$credential)
            }
            .sort(\.$createdAt)
            .all()
        return activities.map { ItemActivityModel.Output($0) }
    }
}
