// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "resend-kit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ResendKit",
            targets: ["ResendKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.10.4"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.11.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.4.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.32.0")
    ],
    targets: [
        .target(
            name: "ResendKit",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
