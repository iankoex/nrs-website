import HTMLKit
import Foundation
import HTMLKitComponents

enum EmployeesPage {
    
    struct IndexView: View {

        var context: EmployeesPageIndexViewContext

        public var body: Content {
            ViewContainer(context, context.shift) {
                Header {  }
                Section {
                    Text {
                        "You are Here"
                    }
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
    
    struct StartShiftView: View {
        
        var context: EmptyContext
        
        public var body: Content {
            ViewContainer(context) {
                Header { }
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "startingBalance") {
                                            "Starting Balance"
                                        }
                                        TextField(name: "startingBalance")
                                    }
                                    StackColumn(size: .twelve) {
                                        Button(role: .submit) {
                                            "Start Shift"
                                        }
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                        .buttonSize(.full)
                                    }
                                }
                                HStack {
                                    StackColumn(size: .twelve) {
                                        LinkButton(destination: "/employees") {
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
    
    struct RestockProduceItemView: View {
        
        var context: RestockProduceItemContext
        
        var submitLabel: String {
            switch context.activityType {
                case .production: return "Produce"
                case .sale: return "Sell"
                case .stocking: return "Restock"
            }
        }
        
        public var body: Content {
            ViewContainer(context, context.shift) {
                Header { }
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "itemTitle") {
                                            "Item"
                                        }
                                        SelectField(name: "itemTitle") {
                                            for itemTitle in context.items {
                                                Option {
                                                    itemTitle
                                                }
                                            }
                                        }
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "portions") {
                                            "Portions"
                                        }
                                        TextField(name: "portions")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "value") {
                                            "Value"
                                        }
                                        TextField(name: "value")
                                    }
                                    if context.activityType != .production {
                                        StackColumn(size: .twelve) {
                                            FieldLabel(for: "paymentMethodStr") {
                                                "Payment Method"
                                            }
                                            SelectField(name: "paymentMethodStr") {
                                                for method in ItemActivityModel.PaymentMethod.allCases {
                                                    Option {
                                                        method.rawValue
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    StackColumn(size: .twelve) {
                                        Button(role: .submit) {
                                            submitLabel
                                        }
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                        .buttonSize(.full)
                                    }
                                }
                                HStack {
                                    StackColumn(size: .twelve) {
                                        LinkButton(destination: "/employees") {
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
    
    struct CreditUserView: View {
        
        var context: CreditUserContext
        
        public var body: Content {
            ViewContainer(context, context.shift) {
                Header { }
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "username") {
                                            "Customer"
                                        }
                                        SelectField(name: "username") {
                                            for username in context.items {
                                                Option {
                                                    username
                                                }
                                            }
                                        }
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "amount") {
                                            "Amount"
                                        }
                                        TextField(name: "amount", value: "\(context.amount)")
                                    }
                                    StackColumn(size: .twelve) {
                                        Button(role: .submit) {
                                            "Save"
                                        }
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                        .buttonSize(.full)
                                    }
                                }
                                HStack {
                                    StackColumn(size: .twelve) {
                                        LinkButton(destination: "/employees") {
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
