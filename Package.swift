// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftyNotifications",
    products: [
        .library(name: "SwiftyNotifications", targets: ["SwiftyNotifications"])
    ],
    targets: [
        .target(name: "SwiftyNotifications", path: "SwiftyNotifications"),
    ],
    swiftLanguageModes: [.v6]
)
