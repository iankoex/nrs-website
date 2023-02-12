import HTMLKit
import HTMLKitComponents

enum LoginPage {
    
    struct LoginView: View {

        var context: EmptyContext

        public var body: Content {
            AreaPageContainer {
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "email") {
                                            "Email"
                                        }
                                        TextField(name: "email")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "password") {
                                            "Password"
                                        }
                                        SecureField(name: "password")
                                    }
                                    StackColumn(size: .twelve) {
                                        Button(role: .submit) {
                                            "Sign in"
                                        }
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                        .buttonSize(.full)
                                    }
                                }
                                HStack {
                                    StackColumn(size: .six) {
                                        LinkButton(destination: "/login/register") {
                                            "Sign up"
                                        }
                                        .buttonSize(.full)
                                        .buttonStyle(.secondary)
                                        .borderShape(.smallrounded)
                                    }
                                    StackColumn(size: .six) {
                                        LinkButton(destination: "/login/reset") {
                                            "Reset password"
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
                .id("login-section")
                
            }
        }
    }
    
    struct RegisterView: View {

        var context: CreateContext

        public var body: Content {
            AreaPageContainer {
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "email") {
                                            "Email"
                                        }
                                        TextField(name: "email")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "password") {
                                            "Password"
                                        }
                                        SecureField(name: "password")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "confirmation") {
                                            "Confirmation"
                                        }
                                        SecureField(name: "confirmation")
                                    }
                                }
                                HStack {
                                    StackColumn(size: .four) {
                                        LinkButton(destination: "/login/login") {
                                            "Back"
                                        }
                                        .buttonSize(.full)
                                        .buttonStyle(.secondary)
                                        .borderShape(.smallrounded)
                                    }
                                    StackColumn(size: .eight) {
                                        Button(role: .submit) {
                                            "Submit"
                                        }
                                        .buttonSize(.full)
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                    }
                                }
                            }
                        }
                    }
                    .contentSpace(.around)
                }
                .id("login-section")
            }
        }
    }
    
    struct ResetView: View {

        var context: CreateContext

        public var body: Content {
            AreaPageContainer {
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                HStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "email") {
                                            "Email"
                                        }
                                        TextField(name: "email")
                                    }
                                }
                                HStack {
                                    StackColumn(size: .four) {
                                        LinkButton(destination: "/login/login") {
                                            "Back"
                                        }
                                        .buttonSize(.full)
                                        .buttonStyle(.secondary)
                                        .borderShape(.smallrounded)
                                    }
                                    StackColumn(size: .eight) {
                                        Button(role: .submit) {
                                            "Submit"
                                        }
                                        .buttonSize(.full)
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                    }
                                }
                            }
                        }
                    }
                    .contentSpace(.around)
                }
                .id("login-section")
            }
        }
    }
    
    
    struct AdminLoginView: View {
        
        var context: EmptyContext
        
        public var body: Content {
            AreaPageContainer {
                Section {
                    HStack {
                        Card {
                            Form(method: .post) {
                                VStack {
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "email") {
                                            "Admin Email"
                                        }
                                        TextField(name: "email")
                                    }
                                    StackColumn(size: .twelve) {
                                        FieldLabel(for: "password") {
                                            "Password"
                                        }
                                        SecureField(name: "password")
                                    }
                                    StackColumn(size: .twelve) {
                                        Button(role: .submit) {
                                            "Sign in"
                                        }
                                        .buttonStyle(.primary)
                                        .borderShape(.smallrounded)
                                        .buttonSize(.full)
                                    }
                                }
                                HStack {
                                    StackColumn(size: .twelve) {
                                        LinkButton(destination: "/login/reset") {
                                            "Reset password"
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
                .id("login-section")
                
            }
        }
    }
}

