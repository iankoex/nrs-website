import Vapor
import Fluent

struct IdentityMetadata: Codable, Content {
    var email: String?
    var name: String?
    var status: String?
    
    init(user: UserModel.Output) {
        self.email = user.email
        self.name = user.firstName
        self.status = "online"
    }
}

struct ViewMetadata: Codable {
    
    var title: String?
}

struct PageMetadata: Codable {
    
    var totalItems: Int
    var pageSize: Int = 10
    var previousPage: Int?
    var currentPage: Int
    var nextPage: Int?
    var totalPages: Int = 1
    
    var hasPrevious: Bool = false
    var hasNext: Bool = false
    var hasItems: Bool = false
    
    init(metadata: Fluent.PageMetadata) {
        
        self.totalItems = metadata.total
        self.currentPage = metadata.page
        self.pageSize = metadata.per
        
        let total = Int(ceil(Double(metadata.total) / Double(metadata.per)))
        
        if total > 0 {
            self.totalPages = total
        }
        
        if self.totalItems > 0 {
            self.hasItems = true
        }
        
        if self.currentPage > 1 {
            self.previousPage = currentPage - 1
            self.hasPrevious = true
        }
        
        if (self.currentPage + 1) < totalPages {
            self.nextPage = currentPage + 1
            self.hasNext = true
        }
    }
}

