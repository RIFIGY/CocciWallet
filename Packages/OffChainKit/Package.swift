// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OffChainKit",
    platforms: [
        .iOS("15.0"),
        .macOS("14.0"),
        .watchOS("9.0"),
        .tvOS("15.0"),
        .visionOS("1.0")
    ],
    products: [
        .library(
            name: "OffChainKit",
            targets: ["OffChainKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0")
    ],
    targets: [
        .target(
            name: "OffChainKit",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
            ],
            resources: [
                .process("Resources"),
                .process("Assets.xcassets"),
            ]
        ),
        .testTarget(
            name: "OffChainKitTests",
            dependencies: [
                "OffChainKit",
                .product(name: "BigInt", package: "BigInt"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
