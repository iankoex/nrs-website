import Fluent

extension CreditModel {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            try await database.schema(CreditModel.schema)
                .id()
                .field("user_id", .uuid, .required, .references(UserModel.schema, .id))
                .field("activity_id", .uuid, .references(ItemActivityModel.schema, .id))
                .field("created_by_id", .uuid, .references(UserModel.schema, .id))
                .field("shift_id", .uuid, .references(ShiftModel.schema, .id))
                .field("amount", .int, .required)
                .field("created_at", .datetime)
                .field("last_modified_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(CreditModel.schema)
                .delete()
        }
    }
}
