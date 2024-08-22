// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "SwiftyNotifications",
    products: [
        .library(name: "SwiftyNotifications", targets: ["SwiftyNotifications"])
    ],
    targets: [
        .target(name: "SwiftyNotifications", path: "SwiftyNotifications"),
    ],
    swiftLanguageVersions: [.v5]
)
