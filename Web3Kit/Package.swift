// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Web3Kit",
    platforms: [
        .iOS("15.0"),
        .macOS("14.0"),
        .watchOS("9.0"),
        .tvOS("15.0"),
        .visionOS("1.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Web3Kit",
            targets: ["Web3Kit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/argentlabs/web3.swift", from: "1.6.1"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0")
    ],
    targets: [
        .target(
            name: "Web3Kit",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "web3.swift", package: "web3.swift"),
            ],
            resources: [
                .process("Resources"),
                .process("Assets.xcassets"),
            ]
        ),
        .testTarget(
            name: "Web3KitTests",
            dependencies: [
                "Web3Kit",
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "web3.swift", package: "web3.swift"),
            ]
        ),
    ]
)
