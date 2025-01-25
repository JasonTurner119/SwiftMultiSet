// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftMultiSet",
    products: [
        .library(
            name: "SwiftMultiSet",
            targets: ["SwiftMultiSet"]
		),
    ],
    targets: [
        .target(
            name: "SwiftMultiSet"
		),
        .testTarget(
            name: "SwiftMultiSetTests",
            dependencies: ["SwiftMultiSet"]
        ),
    ]
)
