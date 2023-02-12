import Fluent
import Foundation
import Vapor

final class ShiftModel: Model {

    static let schema = "shifts"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "opened_by_id")
    var openedBy: UserModel
    
    @OptionalParent(key: "closed_by_id")
    var closedBy: UserModel?
    
    @Field(key: "starting_balance")
    var startingBalance: Int
    
    @Field(key: "current_balance")
    var currentBalance: Int // Becomes the closing balance
    
    @Timestamp(key: "opened_at", on: .create)
    var openedAt: Date?
    
    @Timestamp(key: "closed_at", on: .none)
    var closedAt: Date?
    
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        openedByID: UserModel.IDValue,
        startingBalance: Int
    ) {
        self.$openedBy.id = openedByID
        self.startingBalance = startingBalance
        self.currentBalance = startingBalance
    }
}

extension ShiftModel: Content {
    
    struct Input: Content, Validatable {
        var startingBalance: Int
        
        static func validations(_ validations: inout Validations) {
            validations.add("startingBalance", as: Int.self, is: .valid)
        }
    }
    
    struct Output: Content {
        var id: UUID
        var openedBy: UserModel.Output
        var closedBy: UserModel.Output?
        var startingBalance: Int
        var currentBalance: Int
        var openedAt: Date?
        var lastModifiedAt: Date?
        var closedAt: Date?
        
        init(_ entity: ShiftModel) {
            self.id = entity.id ?? UUID()
            self.openedBy = UserModel.Output(entity.openedBy)
            self.startingBalance = entity.startingBalance
            self.currentBalance = entity.currentBalance
            self.openedAt = entity.openedAt
            self.lastModifiedAt = entity.lastModifiedAt
            self.closedAt = entity.closedAt
            
            if let closedBy = entity.closedBy {
                self.closedBy = UserModel.Output(closedBy)
            }
        }
    }
    
    struct OverviewReport: Content {
        var id: UUID
        var openedByName: String
        var closedByName: String?
        var startingBalance: Int
        var currentBalance: Int
        var openedAt: Date
        var lastModifiedAt: Date
        var closedAt: Date?
        
        init(_ shift: ShiftModel.Output) {
            self.id = shift.id
            self.openedByName = shift.openedBy.email
            self.closedByName = shift.closedBy?.email
            self.startingBalance = shift.startingBalance
            self.currentBalance = shift.currentBalance
            self.openedAt = shift.openedAt ?? Date()
            self.lastModifiedAt = shift.lastModifiedAt ?? Date()
            self.closedAt = shift.closedAt
        }
    }
}
