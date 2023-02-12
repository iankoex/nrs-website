import Fluent

extension ShiftModel {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            try await database.schema(ShiftModel.schema)
                .id()
                .field("opened_by_id", .uuid, .required, .references(UserModel.schema, .id))
                .field("closed_by_id", .uuid, .references(UserModel.schema, .id))
                .field("starting_balance", .int, .required)
                .field("current_balance", .int, .required)
                .field("opened_at", .datetime)
                .field("closed_at", .datetime)
                .field("last_modified_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(ShiftModel.schema)
                .delete()
        }
    }
}
