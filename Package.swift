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
                0, 29, 0,
                prereleaseIdentifiers: [],
                buildMetadataIdentifiers: ["20210102", "9c8096a"]
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
