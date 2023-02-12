import Fluent
import Foundation
import Vapor

final class ItemActivityModel: Model {
    
    static let schema = "item-activities"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "item_id")
    var item: ItemModel
    
    @Parent(key: "shift_id")
    var shift: ShiftModel
    
    @Parent(key: "perfomed_by_id")
    var performedBy: UserModel
    
    @Field(key: "portions")
    var portions: Int
    
    @Field(key: "value")
    var value: Int
    
    @Enum(key: "activity_type")
    var activityType: ItemActivityModel.ActivityType
    
    @Enum(key: "payment_method")
    var paymentMethod: ItemActivityModel.PaymentMethod
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        itemID: ItemModel.IDValue,
        shiftID: ShiftModel.IDValue,
        perfomedByID: UserModel.IDValue,
        portions: Int,
        value: Int,
        activityType: ItemActivityModel.ActivityType,
        paymentMethod: ItemActivityModel.PaymentMethod
    ) {
        self.$item.id = itemID
        self.$shift.id = shiftID
        self.$performedBy.id = perfomedByID
        self.portions = portions
        self.value = value
        self.activityType = activityType
        self.paymentMethod = paymentMethod
    }
}

extension ItemActivityModel {
 
    enum ActivityType: String, Content {
        case stocking
        case production
        case sale
    }
    
    enum PaymentMethod: String, CaseIterable, Content {
        case mpesa
        case cash
        case credit
    }
}

extension ItemActivityModel: Content {
    
    struct Input: Content, Validatable {
        var itemTitle: String
        var portions: Int
        var value: Int
        var paymentMethodStr: String?
        
        static func validations(_ validations: inout Validations) {
            validations.add("itemTitle", as: String.self, is: .valid)
            validations.add("portions", as: Int.self, is: .valid)
            validations.add("value", as: Int.self, is: .valid)
            validations.add("paymentMethodStr", as: String.self, is: .valid, required: false)
        }
    }
    
    struct Output: Content {
        var id: UUID
        var item: ItemModel
        var shift: ShiftModel.Output
        var perfomedBy: UserModel.Output
        var portions: Int
        var value: Int
        var activityType: ItemActivityModel.ActivityType
        var paymentMethod: ItemActivityModel.PaymentMethod
        
        init(_ activity: ItemActivityModel) {
            self.id = activity.id ?? UUID()
            self.item = activity.item
            self.shift = ShiftModel.Output(activity.shift)
            self.perfomedBy = UserModel.Output(activity.performedBy)
            self.portions = activity.portions
            self.value = activity.value
            self.activityType = activity.activityType
            self.paymentMethod = activity.paymentMethod
        }
    }
}
