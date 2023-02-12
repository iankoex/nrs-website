import HTMLKit
import HTMLKitComponents

struct ViewContainer: View {
    
    let content: [Content]
    let context: Context?
    let shift: ShiftModel.Output?
    
    init(
        _ context: Context? = nil,
        _ shift: ShiftModel.Output? = nil,
        @ContentBuilder<Content> content: () -> [Content]
    ) {
        self.context = context
        self.shift = shift
        self.content = content()
    }
    
    var body: Content {
        PageContainer(context) {
            Header {
                HStack {
                    StackColumn(size: .twelve) {
                        headerLinkButton
                    }
                }
            }
            Main {
                asideContent
                asideToggler
                Section {
                    content
                }
                Script {
                }
                .source("/htmlkit/sidebar.js")
            }
            Footer {
                pageFooter
            }
        }
    }
    
    var headerLinkButton: Content {
        Link(destination: "/") {
            HTMLKitComponents.Group {
                Image(source: "https://user-images.githubusercontent.com/30172987/218243241-28189b4b-c2a7-4300-bedc-3b1ed0d2aaf1.png")
                    .imageScale(.medium)
                Heading3 {
                    context?.view.title ?? "Panel"
                }
            }
            .fontSize(.medium)
            .foregroundColor(.primary)
            .fontWeight(.medium)
        }
    }
    
    var asideHeaderLinkButton: Content {
        Link(destination: "/") {
            HTMLKitComponents.Group {
                Image(source: "https://user-images.githubusercontent.com/30172987/218243241-28189b4b-c2a7-4300-bedc-3b1ed0d2aaf1.png")
                    .imageScale(.medium)
                Heading1 {
                    "Dashboard"
                }
            }
            .fontSize(.medium)
            .foregroundColor(.primary)
            .fontWeight(.medium)
        }
    }
    
    var asideContent: Content {
        Aside {
            Header {
                Division {
                    asideHeaderLinkButton
                }
                .class("sidebar_content sidebar_head")
            }
            Section {
                Division {
                    Navigation {
                        asideList
                    }
                    .class("side_navlinks")
                }
                .class("sidebar_content sidebar_body")
            }
            asideFooter
        }
        .id("sidebar")
    }
    
    var asideList: Content {
        List(direction: .vertical) {
            ListItem {
                if let context = context, context.identity == nil {
                    LinkButton(destination: "/login") {
                        HTMLKitComponents.Group {
                            // Symbol(system: "folder")
                            Text { "Login" }
                        }
                        .fontSize(.medium)
                    }
                    .buttonStyle(.secondary)
                    .borderShape(.largerounded)
                    .buttonSize(.full)
                }
            }
            
            ListItem {
                if let currentShift = shift {
                    HStack {
                        StackColumn(size: .six) {
                            Text {
                                "Bal: \(currentShift.currentBalance)"
                            }
                        }
                        StackColumn(size: .six, alignment: .right) {
                            LinkButton(destination: "/employees/closeShift/\(currentShift.id)") {
                                HTMLKitComponents.Group {
                                    // Symbol(system: "folder")
                                    Text { "Close Shift" }
                                }
                                .fontSize(.medium)
                            }
                            .buttonStyle(.secondary)
                            .borderShape(.largerounded)
                            .buttonSize(.full)
                        }
                    }
                } else {
                    if let context = context, context.identity != nil {
                        ListItem {
                            LinkButton(destination: "/employees/startShift") {
                                HTMLKitComponents.Group {
                                    // Symbol(system: "folder")
                                    Text { "Start Shift" }
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
            
            ListItem {
                if currentShiftIsUnderway {
                    LinkButton(destination: "/employees/restockItem") {
                        "Restock Item"
                    }
                    .buttonSize(.full)
                    .buttonStyle(.primary)
                    .borderShape(.smallrounded)
                }
                
            }
            
            ListItem {
                if currentShiftIsUnderway {
                    LinkButton(destination: "/employees/produceItem") {
                        "Produce Item"
                    }
                    .buttonSize(.full)
                    .buttonStyle(.primary)
                    .borderShape(.smallrounded)
                }
                
            }
            
            ListItem {
                if currentShiftIsUnderway {
                    LinkButton(destination: "/employees/sellItem") {
                        "Sell Item"
                    }
                    .buttonSize(.full)
                    .buttonStyle(.primary)
                    .borderShape(.smallrounded)
                }
                
            }
        }
    }
    
    var asideFooter: Content {
        Footer {
            Division {
                if let context = context, let identity = context.identity {
                    HStack {
                        Text {
                            identity.email
                        }
                        LinkButton(destination: "/login/logout") {
                            HTMLKitComponents.Group {
                                // Symbol(system: "folder")
                                Text { "Logout" }
                            }
                            .fontSize(.medium)
                        }
                        .buttonStyle(.secondary)
                        .borderShape(.largerounded)
                        .buttonSize(.full)
                    }
                }
            }
            .class("sidebar_content sidebar_foot")
        }
    }
    
    var asideToggler: Content {
        Division {
            Span { }
            Span { }
            Span { }
        }
        .class("sidebar_toggler")
    }
    
    var pageFooter: Content {
        HStack {
            StackColumn(size: .twelve, alignment: .center) {
                Text {
                    "Made with ❤️ by IanKoex"
                }
                .font(.body)
                .italic()
            }
        }
    }
    
    var currentShiftIsUnderway: Bool {
        guard shift != nil else {
            return false
        }
        return true
    }
}
