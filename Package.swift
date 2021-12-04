// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "combineer",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "combineer",
            targets: ["Combineer"]
        ),
    ],
    targets: [
        .target(
            name: "Combineer",
            dependencies: []),
        .testTarget(
            name: "CombineerTests",
            dependencies: ["Combineer"]),
    ]
)
