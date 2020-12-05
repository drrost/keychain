// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Keychain",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Keychain",
            targets: ["Keychain"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Keychain",
            dependencies: []),
        .testTarget(
            name: "KeychainTests",
            dependencies: ["Keychain"]),
    ]
)
