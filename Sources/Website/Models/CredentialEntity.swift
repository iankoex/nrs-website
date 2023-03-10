import Fluent
import Foundation

final class CredentialEntity: Model {
    
    static let schema = "credentials"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "role")
    var role: String
    
    @Field(key: "status")
    var status: String
    
    @OptionalChild(for: \.$credential)
    var user: UserModel?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "modified_at", on: .update)
    var modifiedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, password: String, role: String, status: String, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        
        self.id = id
        self.password = password
        self.role = role
        self.status = status
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
    convenience init(input: CredentialModel.Input) {
        
        self.init(password: input.password, role: input.role, status: input.status)
    }
}

