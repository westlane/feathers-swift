// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Feathers",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "Feathers",
            targets: ["Feathers"]),
    ],
        dependencies: [
            .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift", from: "7.0.0"),
            .package(url: "https://github.com/evgenyneu/keychain-swift", from: "20.0.0"),
            .package(url: "https://github.com/antitypical/Result", from: "5.0.0"),
        ],
    targets: [
        .target(
            name: "Feathers",
            dependencies: [
                .product(name: "ReactiveSwift", package: "ReactiveSwift"),
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Result", package: "Result"),
            ],
            path: "Feathers/Core"
        ),
        .testTarget(
            name: "FeathersTests",
            dependencies: [
                "Feathers",
            ],
            path: "Tests"
        ),
    ]
)
