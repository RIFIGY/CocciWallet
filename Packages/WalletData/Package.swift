// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WalletData",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WalletData",
            targets: ["WalletData"]),
    ],
    dependencies: [
        .package(name: "ChainKit", path: "../ChainKit"),
        .package(name: "Web3Kit", path: "../Web3Kit"),
        .package(name: "OffChainKit", path: "../OffChainKit"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "WalletData",
            dependencies: [
                "ChainKit",
                "Web3Kit",
                "OffChainKit",
                .product(name: "BigInt", package: "BigInt"),
            ]
        ),
        .testTarget(
            name: "WalletDataTests",
            dependencies: ["WalletData"]),
    ]
)
