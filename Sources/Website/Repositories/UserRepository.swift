import Fluent
import Foundation
import Vapor

final class UserRepository {
    
    let database: Database
    
    init(database: Database) {
        
        self.database = database
    }
    
    func find(id: UUID) async throws -> UserModel? {
        
       return try await UserModel.query(on: database)
            .with(\.$credential)
            .filter(\.$id == id)
            .first()
    }
    
    func find(name: String) async throws -> UserModel? {
        
        return try await UserModel.query(on: database)
            .with(\.$credential)
            .filter(\.$email == name)
            .first()
    }
    
    func find(using name: String) async throws -> UserModel {
        let user = try await UserModel.query(on: database)
            .filter(\.$email == name)  // for now
            .first()
        guard let user = user else {
            throw Abort(.notAcceptable, reason: "User Not Found")
        }
        return user
    }
    
    func getUsersNames() async throws -> [String] {
        let users = try await UserModel.query(on: database)
            .field(\.$email)
            .all()
        return users.map { $0.email }
    }
    
    func find() async throws -> [UserModel] {
        
        return try await UserModel.query(on: database)
            .sort(\.$modifiedAt, .descending)
            .all()
    }
    
    func page(index: Int, with items: Int) async throws -> [UserModel] {
        
        return try await UserModel.query(on: database)
            .paginate(PageRequest(page: index, per: items))
            .map { page in
                return page.items
            }
            .get()
    }
    
    func insert(entity: UserModel) async throws {
        try await entity.create(on: database)
    }
    
    func patch<Field: QueryableProperty>(field: KeyPath<UserModel, Field>, to value: Field.Value, for id: UUID) async throws where Field.Model == UserModel {
        
        try await UserModel.query(on: database)
            .filter(\.$id == id)
            .set(field, to: value)
            .update()
    }
    
    func update(entity: UserModel, on id: UUID) async throws {
        
        try await UserModel.query(on: database)
            .filter(\.$id == id)
            .set(\.$email, to: entity.email)
            .set(\.$firstName, to: entity.firstName)
            .set(\.$lastName, to: entity.lastName)
            .set(\.$description, to: entity.description)
            .update()
    }
    
    func delete(id: UUID) async throws {
        
        try await UserModel.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func count() async throws -> Int {
        
        return try await UserModel.query(on: database)
            .count()
    }
}
