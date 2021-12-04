// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "combineer",
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
