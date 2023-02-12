import Fluent
import Foundation
import Vapor

final class UserModel: Model {
    
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @OptionalField(key: "first_name")
    var firstName: String?
    
    @OptionalField(key: "last_name")
    var lastName: String?
    
    @OptionalField(key: "description")
    var description: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "modified_at", on: .update)
    var modifiedAt: Date?

    @OptionalParent(key: "credential_id")
    var credential: CredentialEntity?
    
    init() {}
    
    init(
        id: UUID? = nil,
        email: String,
        firstName: String? = nil,
        lastName: String? = nil,
        description: String? = nil,
        credentialId: UUID? = nil,
        createdAt: Date? = nil,
        modifiedAt: Date? = nil
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.description = description
        self.$credential.id = credentialId
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
    convenience init(input: UserModel.Input) {
        
        self.init(email: input.email, firstName: input.firstName, lastName: input.lastName, description: input.description)
    }
    
    //var output: Output? // delete 
}

extension UserModel: Content {
    
    
    
    struct Input: Content, Validatable {
        
        var avatarId: String?
        var email: String
        var firstName: String?
        var lastName: String?
        var description: String?
        
        static func validations(_ validations: inout Validations) {
            
            validations.add("email", as: String.self, is: !.empty)
        }
    }
    
    struct Output: Content, SessionAuthenticatable {
        
        var id: UUID
        var email: String
        var firstName: String?
        var lastName: String?
        var description: String?
        var credential: CredentialModel.Output?
        var createdAt: Date
        var modifiedAt: Date
        var sessionID: String {
            self.email
        }
        
        init(id: UUID, email: String, firstName: String? = nil, lastName: String? = nil, description: String? = nil, credential: CredentialModel.Output? = nil, createdAt: Date, modifiedAt: Date) {
            
            self.id = id
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.description = description
            self.credential = credential
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
        }
        
        init(_ entity: UserModel) {
            
            self.init(id: entity.id!, email: entity.email, firstName: entity.firstName, lastName: entity.lastName, description: entity.description, createdAt: entity.createdAt!, modifiedAt: entity.modifiedAt!)
            
            if let credential = entity.credential {
                self.credential = CredentialModel.Output(entity: credential)
            }
        }
    }
}
