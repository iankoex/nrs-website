import Fluent

extension ItemActivityModel {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            let activityType = try await database.enum("item-activity-type")
                .case(ItemActivityModel.ActivityType.stocking.rawValue)
                .case(ItemActivityModel.ActivityType.production.rawValue)
                .case(ItemActivityModel.ActivityType.sale.rawValue)
                .create()
            let paymentMethod = try await database.enum("item-payment-method")
                .case(ItemActivityModel.PaymentMethod.mpesa.rawValue)
                .case(ItemActivityModel.PaymentMethod.cash.rawValue)
                .case(ItemActivityModel.PaymentMethod.credit.rawValue)
                .create()
            
            try await database.schema(ItemActivityModel.schema)
                .id()
                .field("item_id", .uuid, .required, .references(ItemModel.schema, .id))
                .field("shift_id", .uuid, .references(ShiftModel.schema, .id))
                .field("perfomed_by_id", .uuid, .references(UserModel.schema, .id))
                .field("portions", .int, .required)
                .field("value", .int, .required)
                .field("activity_type", activityType, .required)
                .field("payment_method", paymentMethod, .required)
                .field("created_at", .datetime)
                .field("last_modified_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(ItemActivityModel.schema)
                .delete()
        }
    }
}
