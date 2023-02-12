import HTMLKit
import HTMLKitComponents

enum AdminPage {
    
    struct IndexView: View {
        
        var context: ItemContext<ShiftModel.OverviewReport?>
        
        public var body: Content {
            AdminViewContainer(context) {
                Header { }
                Section {
                    if let shift = context.item {
                        reportView(for: shift)
                    }
                }
                .id("body-main-section1")
                Footer { }
            }
        }
        
        func reportView(for shift: ShiftModel.OverviewReport) -> Content {
            HStack {
                Card {
                    Form(method: .get) {
                        VStack {
                            StackColumn(size: .twelve) {
                                Heading3 {
                                    "Current Shift"
                                }
                            }
                            StackColumn(size: .twelve) {
                                FieldLabel(for: "openedByName") {
                                    "Opened By"
                                }
                                ReadOnlyTextField(name: "openedByName", value: shift.openedByName)
                            }
                            
                            if let closedByName = shift.closedByName {
                                StackColumn(size: .twelve) {
                                    FieldLabel(for: "closedByName") {
                                        "Closed By"
                                    }
                                    ReadOnlyTextField(name: "closedByName", value: closedByName)
                                }
                            }
                            
                            StackColumn(size: .twelve) {
                                FieldLabel(for: "startingBalance") {
                                    "Starting Balance"
                                }
                                ReadOnlyTextField(name: "startingBalance", value: "\(shift.startingBalance)")
                            }
                            
                            if let currentBalance = shift.currentBalance {
                                StackColumn(size: .twelve) {
                                    FieldLabel(for: "currentBalance") {
                                        "Current Balance"
                                    }
                                    ReadOnlyTextField(name: "currentBalance", value: "\(currentBalance)")
                                }
                            }
                            StackColumn(size: .twelve) {
                                FieldLabel(for: "openedAt") {
                                    "Opened At"
                                }
                                ReadOnlyTextField(name: "openedAt", value: "\(shift.openedAt)")
                            }
                            
                            StackColumn(size: .twelve) {
                                FieldLabel(for: "lastModifiedAt") {
                                    "Last Updated At"
                                }
                                ReadOnlyTextField(name: "lastModifiedAt", value: "\(shift.lastModifiedAt)")
                            }
                            
                            if let closedAt = shift.closedAt {
                                StackColumn(size: .twelve) {
                                    FieldLabel(for: "closedAt") {
                                        "Closed At"
                                    }
                                    ReadOnlyTextField(name: "closedAt", value: "\(closedAt)")
                                }
                            }
                        }
                    }
                }
            }
            .contentSpace(.around)
        }
    }
    
    struct ActivityView: View {
        
        var context: ItemsContext<ItemActivityModel.Output>
        
        var body: Content {
            AdminViewContainer(context) {
                Header {
                    
                }
                Section {
                    StackColumn(size: .twelve) {
                        Division {
                            tableView
                        }
                        .class("table-wrapper")
                        .style("overflow-x:auto")
                    }
                    
                }
                .id("body-main-table")
                Footer { }
            }
        }
        
        var tableView: Content {
            Table {
                TableHead {
                    TableRow {
                        HeaderCell {
                            Text { "Item" }
                        }
                        HeaderCell {
                            Text { "Shift" }
                        }
                        HeaderCell {
                            Text { "PerfomedBy" }
                        }
                        HeaderCell {
                            Text { "Portions" }
                        }
                        HeaderCell {
                            Text { "Value" }
                        }
                        HeaderCell {
                            Text { "ActivityType" }
                        }
                        HeaderCell {
                            Text { "Payment Method" }
                        }
                    }
                }
                TableBody {
                    for activity in context.items {
                        TableRow {
                            DataCell {
                                Dropdown(content: {
                                    Text { "Show other Item Details" }
                                }, label: {
                                    Text { activity.item.title }
                                })
                            }
                            DataCell {
                                Dropdown(content: {
                                    Text { "Show Shift Details" }
                                }, label: {
                                    Text { "Shift" }
                                })
                            }
                            DataCell {
                                Text { activity.perfomedBy.email }
                            }
                            DataCell {
                                Text { "\(activity.portions)" }
                            }
                            DataCell {
                                Text { "\(activity.value)" }
                            }
                            DataCell {
                                Text { "\(activity.activityType)" }
                            }
                            DataCell {
                                Text { "\(activity.paymentMethod)" }
                            }
                        }
                    }
                }
            }
            .class("activity-table")
        }
    }
    
    struct CreateItemView: View {
        
        var context: EmptyContext
        
        public var body: Content {
            AdminViewContainer(context) {
                Header { }
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "title") {
                                            "Item Title"
                                        }
                                        TextField(name: "title")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "description") {
                                            "Item Description"
                                        }
                                        TextField(name: "description")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "portions") {
                                            "Initial Portions"
                                        }
                                        TextField(name: "portions")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "value") {
                                            "Initial Value"
                                        }
                                        TextField(name: "value")
                                    }
                                    StackColumn(size: .twelve) {
                                        Button(role: .submit) {
                                            "Create"
                                        }
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                        .buttonSize(.full)
                                    }
                                }
                                HStack {
                                    StackColumn(size: .twelve) {
                                        LinkButton(destination: "/admin") {
                                            "Cancel"
                                        }
                                        .buttonSize(.full)
                                        .buttonStyle(.secondary)
                                        .borderShape(.smallrounded)
                                    }
                                }
                            }
                        }
                    }
                    .contentSpace(.around)
                }
                .id("body-main-section1")
                Footer {
                    HStack {
                        StackColumn(size: .twelve) {
                        }
                    }
                }
            }
        }
    }
}

public struct ReadOnlyTextField: View {
    
    /// The identifier of the field.
    internal let name: String
    
    /// The content of the field.
    internal let value: String?
    
    /// The classes of the field.
    internal var classes: [String]
    
    /// The events of the field.
    internal var events: [String]?
    
    /// Creates a text field.
    public init(name: String, value: String? = nil) {
        
        self.name = name
        self.value = value
        self.classes = ["input", "type:textfield"]
    }
    
    /// Creates a text field.
    internal init(name: String, value: String?, classes: [String], events: [String]?) {
        
        self.name = name
        self.value = value
        self.classes = classes
        self.events = events
    }
    
    public var body: Content {
        Input()
            .readonly()
            .type(.text)
            .id(name)
            .name(name)
            .class(classes.joined(separator: " "))
            .modify(unwrap: value) {
                $0.value($1)
            }
    }
}
