// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    defaultLocalization: "pt",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
        .driverKit(.v23)
    ],
    products: [
        .library(
            name: "Core",
            targets: [
                "Resource",
                "Mock",
                "Domain",
                "Data",
                "Presentation",
                "UserInterface"
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/rafaelesantos/refds-shared.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-network.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-core-data.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-injection.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-design-patterns.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-design-system.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-router.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-welcome.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-auth.git", branch: "main"),
        .package(url: "https://github.com/rafaelesantos/refds-gamification.git", branch: "main")
    ],
    targets: [
        .target(name: "Resource"),
        .target(name: "Domain", dependencies: [
            "Resource",
            .product(name: "RefdsShared", package: "refds-shared"),
            .product(name: "RefdsInjection", package: "refds-injection"),
            .product(name: "RefdsDesignPatterns", package: "refds-design-patterns"),
            .product(name: "RefdsRouter", package: "refds-router")
        ]),
        .target(name: "Mock", dependencies: [
            "Domain",
            "Resource",
            .product(name: "RefdsShared", package: "refds-shared"),
            .product(name: "RefdsRouter", package: "refds-router")
        ]),
        .target(name: "Data", dependencies: [
            "Domain",
            "Resource",
            .product(name: "RefdsNetwork", package: "refds-network"),
            .product(name: "RefdsCoreData", package: "refds-core-data"),
            .product(name: "RefdsInjection", package: "refds-injection")
        ]),
        .target(name: "Presentation", dependencies: [
            "Domain",
            "Data",
            "Resource",
            "Mock",
            .product(name: "RefdsShared", package: "refds-shared"),
            .product(name: "RefdsInjection", package: "refds-injection"),
            .product(name: "RefdsDesignPatterns", package: "refds-design-patterns"),
            .product(name: "RefdsRouter", package: "refds-router"),
            .product(name: "RefdsWelcome", package: "refds-welcome"),
            .product(name: "RefdsNetwork", package: "refds-network")
        ]),
        .target(name: "UserInterface", dependencies: [
            "Presentation",
            "Resource",
            "Mock",
            .product(name: "RefdsUI", package: "refds-design-system"),
            .product(name: "RefdsAuth", package: "refds-auth"),
            .product(name: "RefdsGamification", package: "refds-gamification"),
        ])
    ]
)
