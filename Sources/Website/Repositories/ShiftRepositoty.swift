import Fluent
import Foundation
import Vapor

final class ShiftRepository {
    
    let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func find(using id: UUID) async throws -> ShiftModel {
        let shift = try await ShiftModel.find(id, on: database)
        guard let shift = shift else {
            throw Abort(.notFound, reason: "Could Not Find Shift")
        }
        return shift
    }
    
    func insert(_ entity: ShiftModel) async throws {
        try await entity.create(on: database)
    }
    
    func currentShift() async throws -> ShiftModel.Output? {
        let shift = try await ShiftModel.query(on: database)
            .filter(\.$closedAt == nil)
            .with(\.$openedBy) { openedBy in
                openedBy.with(\.$credential)
            }
            .with(\.$closedBy) { closedBy in
                closedBy.with(\.$credential)
            }
            .first()
        guard let shift = shift else {
            return nil
        }
        let output = ShiftModel.Output(shift)
        return output
    }
    
    func closeShift(_ shift: ShiftModel, by closedBy: UserModel.Output) async throws {
        shift.closedAt = Date()
        shift.$closedBy.id = closedBy.id
        try await shift.update(on: database)
    }
    
    func creditUser( _ input: CreditModel.Input, by creator: UserModel.Output, from activityID: UUID) async throws {
        let userRepo = UserRepository(database: database)
        let user = try await userRepo.find(using: input.username)
        guard let shift = try await currentShift() else {
            throw Abort(.notAcceptable, reason: "No Current Shift")
        }
        let creditModel = CreditModel(
            userID: try user.requireID(),
            activityID: activityID,
            createdByID: creator.id,
            shiftID: shift.id,
            amount: input.amount
        )
        // subtract from users balance and everything
        //
        try await creditModel.create(on: database)
    }
    
    func getOverviewReport() async throws -> ShiftModel.OverviewReport? {
        guard let shift = try await currentShift() else {
            return nil
        }
        let report = ShiftModel.OverviewReport(shift)
        return report
    }
}

