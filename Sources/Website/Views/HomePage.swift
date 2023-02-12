import HTMLKit
import HTMLKitComponents

enum HomePage {
    
    struct IndexView: View {
        
        var context: EmptyContext

        public var body: Content {
            ViewContainer(context) {
                Header { }
                Section {
                    HStack {
                        StackColumn(size: .twelve, alignment: .center) {
                            List(direction: .vertical) {
                                ListRow {
                                    LinkButton(destination: "/employees") {
                                        HTMLKitComponents.Group {
                                            // Symbol(system: "folder")
                                            Text { "Employees" }
                                        }
                                        .fontSize(.medium)
                                        .foregroundColor(.primary)
                                    }
                                    .buttonStyle(.primary)
                                    .borderShape(.largerounded)
                                    .buttonSize(.full)
                                }
                                ListRow {
                                    LinkButton(destination: "/admin") {
                                        HTMLKitComponents.Group {
                                            // Symbol(system: "folder")
                                            Text { "Admin" }
                                        }
                                        .fontSize(.medium)
                                        .foregroundColor(.primary)
                                    }
                                    .buttonStyle(.primary)
                                    .borderShape(.largerounded)
                                    .buttonSize(.full)
                                }
                            }
                        }
                    }
                }
                Footer { }
            }
        }
    }
}
