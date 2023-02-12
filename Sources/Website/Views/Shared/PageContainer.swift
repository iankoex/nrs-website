import HTMLKit
import HTMLKitComponents

struct PageContainer: View {
    
    let context: Context?
    var content: [BodyElement]
    
    init(
        _ context: Context? = nil,
        @ContentBuilder<BodyElement> content: () -> [BodyElement]
    ) {
        self.context = context
        self.content = content()
    }

    var body: Content {
        Document(.html5)
        Html {
            Head {
                Meta()
                    .charset(.utf8)
                Meta()
                    .name(.viewport)
                    .content("width=device-width, initial-scale=1.0")
                Title {
                    "NRS • \(context?.view.title ?? "")"
                }
                Link()
                    .relationship(.stylesheet)
                    .reference("/htmlkit/all.css")
                Link()
                    .relationship(.stylesheet)
                    .reference("/css/page.css")
                Script {
                }
                .source("/htmlkit/all.js")
            }
            Body {
                content
            }
        }
    }
}
