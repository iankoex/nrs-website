import Fluent

extension ItemModel {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            
            try await database.schema(ItemModel.schema)
                .id()
                .field("title", .string, .required)
                .field("description", .string)
                .field("portions", .int, .required)
                .field("value", .int, .required)
                .field("created_at", .datetime)
                .field("last_modified_at", .datetime)
                .unique(on: "title")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(ItemModel.schema)
                .delete()
        }
    }
}
