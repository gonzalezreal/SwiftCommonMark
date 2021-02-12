// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftCommonMark",
    products: [
        .library(
            name: "CommonMark",
            targets: ["CommonMark"]
        ),
    ],
    dependencies: [
        .package(
            name: "cmark",
            url: "https://github.com/SwiftDocOrg/swift-cmark.git",
            from: Version(
                0, 28, 3,
                prereleaseIdentifiers: [],
                buildMetadataIdentifiers: ["20200207", "1168665"]
            )
        ),
    ],
    targets: [
        .target(
            name: "CommonMark",
            dependencies: ["cmark"]
        ),
        .testTarget(
            name: "CommonMarkTests",
            dependencies: ["CommonMark"]
        ),
    ]
)
