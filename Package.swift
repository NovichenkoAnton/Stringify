// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Stringify",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "Stringify",
            targets: ["Stringify"]
        ),
    ],
    targets: [
        .target(
            name: "Stringify",
            path: "Sources"
        ),
    ]
)
