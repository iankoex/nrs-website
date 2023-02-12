import Fluent
import Foundation
import Vapor

final class CreditModel: Model {
    
    static let schema = "credits"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: UserModel
    
    @Parent(key: "activity_id")
    var activity: ItemActivityModel
    
    @Parent(key: "created_by_id")
    var createdBy: UserModel
    
    @Parent(key: "shift_id")
    var shift: ShiftModel
    
    @Field(key: "amount")
    var amount: Int
    
    @Timestamp(key: "created_at", on: .none)
    var createdAt: Date?
    
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: UserModel.IDValue,
        activityID: ItemActivityModel.IDValue,
        createdByID: UserModel.IDValue,
        shiftID: ShiftModel.IDValue,
        amount: Int
    ) {
        self.$user.id = userID
        self.$activity.id = activityID
        self.$createdBy.id = createdByID
        self.$shift.id = shiftID
        self.amount = amount
    }
}

extension CreditModel: Content {
    
    struct Input: Content, Validatable {
        var username: String
        var amount: Int
        
        static func validations(_ validations: inout Validations) {
            validations.add("username", as: String.self, is: .valid)
            validations.add("amount", as: Int.self, is: .valid)
        }
    }
}
