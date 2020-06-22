// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyNavigationBar",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "SwiftyNavigationBar", targets: ["SwiftyNavigationBar"]),
    ],
    targets: [
        .target(name: "SwiftyNavigationBar", path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
