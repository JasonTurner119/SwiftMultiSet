// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftMultiSet",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6),
	],
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
