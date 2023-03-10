import Fluent

extension UserModel {
    struct Migration: AsyncMigration {
        
        func prepare(on database: Database) async throws {
            
            try await database.schema(UserModel.schema)
                .id()
                .field("avatar_id", .uuid, .references("assets", "id"))
                .field("email", .string, .required).unique(on: "email")
                .field("first_name", .string)
                .field("last_name", .string)
                .field("description", .string)
                .field("credential_id", .uuid, .references("credentials", "id"))
                .field("created_at", .datetime)
                .field("modified_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            
            try await database.schema(UserModel.schema)
                .delete()
        }
    }
}
