// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftCommonMark",
    products: [
        .library(
            name: "cmark",
            targets: ["cmark"]
        ),
        .library(
            name: "CommonMark",
            targets: ["CommonMark"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "cmark",
            exclude: [
                "entities.inc",
                "case_fold_switch.inc",
                "cmark_version.h.in",
                "config.h.in",
                "libcmark.pc.in",
                "CMakeLists.txt",
                "scanners.re",
                "cmarkConfig.cmake.in",
                "main.c",
            ]
        ),
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
