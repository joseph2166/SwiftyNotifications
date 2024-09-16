// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftyNotifications",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        .library(name: "SwiftyNotifications", targets: ["SwiftyNotifications"])
    ],
    targets: [
        .target(name: "SwiftyNotifications", path: "SwiftyNotifications"),
    ],
    swiftLanguageModes: [.v6]
)
