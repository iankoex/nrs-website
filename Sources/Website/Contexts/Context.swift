import Vapor


protocol Context {
    var view: ViewMetadata { get set }
    var identity: IdentityMetadata? { get set }
}

struct EmptyContext: Context, Content {
    var view: ViewMetadata
    var identity: IdentityMetadata?
}

struct ItemContext<T:Codable>: Context {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var item: T
}

struct ItemsContext<T:Codable>: Context {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var items: [T]
}

struct EmployeesPageIndexViewContext: Context {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var shift: ShiftModel.Output?
}

struct RestockProduceItemContext: Context {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var items: [String]
    var activityType: ItemActivityModel.ActivityType
    var shift: ShiftModel.Output?
}

struct CreditUserContext: Context {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var items: [String]
    var amount: Int
    var shift: ShiftModel.Output?
}

struct IndexContext<T:Codable>: Context, Codable {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var items: [T]
}

struct ShowContext<T:Codable>: Context, Codable {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var item: T
}

struct CreateContext: Context, Codable {
    var view: ViewMetadata
    var identity: IdentityMetadata?
}

struct EditContext<T:Codable>: Context, Codable {
    var view: ViewMetadata
    var identity: IdentityMetadata?
    var item: T
}
