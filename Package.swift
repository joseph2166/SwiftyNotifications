// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftyNotifications",
    platforms: [.macOS(.v10_10),
                .iOS(.v9),
                .tvOS(.v9),
                .watchOS(.v2)],
    products: [
        .library(name: "SwiftyNotifications", targets: ["SwiftyNotifications"])
    ],
    targets: [
        .target(name: "SwiftyNotifications", path: "SwiftyNotifications"),
    ],
    swiftLanguageVersions: [.v5]
)
