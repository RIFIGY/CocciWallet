// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChainKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ChainKit",
            targets: ["ChainKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/horizontalsystems/HdWalletKit.Swift.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.4.1"),


    ],
    targets: [
        .target(
            name: "ChainKit",
            dependencies: [
                .product(name: "HdWalletKit", package: "HdWalletKit.Swift"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "secp256k1", package: "secp256k1.swift"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
            ]
        ),

        .testTarget(
            name: "ChainKitTests",
            dependencies: [
                "ChainKit"
            ]
        ),
    ]
)
