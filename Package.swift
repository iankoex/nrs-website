// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Website",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.66.1"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.5.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor-community/HTMLKit.git", branch: "upgrade/htmlkit-3.0-2")
    ],
    targets: [
        .executableTarget(
            name: "Website",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "HTMLKit", package: "HTMLKit")
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .testTarget(name: "WebsiteTests", dependencies: [
            .target(name: "Website"),
            .product(name: "XCTVapor", package: "vapor")
        ])
    ]
)
