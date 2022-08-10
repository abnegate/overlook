// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "overlook",
    products: [
        .executable(
            name: "overlook",
            targets: ["overlook", "Config", "Env", "Json", "Tasks", "Watch"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "overlook",
            dependencies: [
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "Rainbow", package: "Rainbow"),
                .product(name: "SwiftCLI", package: "SwiftCLI"),
                "Config",
                "Env",
                "Watch",
                "Tasks",
            ]
        ),
        .target(
            name: "Config",
            dependencies: [
                .product(name: "PathKit", package: "PathKit"),
                "Json"
            ]
        ),
        .target(
            name: "Tasks",
            dependencies: [
                .product(name: "PathKit", package: "PathKit"),
            ]
        ),
        .target(
            name: "Env",
            dependencies: [
                .product(name: "PathKit", package: "PathKit")
            ]
        ),
        .target(name: "Watch"),
        .target(name: "Json"),
    ]
)
