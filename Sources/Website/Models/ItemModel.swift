import Fluent
import Foundation
import Vapor

final class ItemModel: Model {
    
    static let schema = "items"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "portions")
    var portions: Int
    
    @Field(key: "value")
    var value: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        title: String,
        description: String,
        portions: Int,
        value: Int
    ) {
        self.title = title
        self.description = description
        self.portions = portions
        self.value = value
    }
}

extension ItemModel: Content {
    
    struct Input: Content, Validatable {
        var title: String
        var description: String
        var portions: Int
        var value: Int
        
        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: .valid)
            validations.add("description", as: String.self, is: .valid)
            validations.add("portions", as: Int.self, is: .valid)
            validations.add("value", as: Int.self, is: .valid)
        }
    }
}
