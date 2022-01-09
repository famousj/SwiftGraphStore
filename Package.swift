// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGraphStore",
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftGraphStore",
            targets: ["SwiftGraphStore"]),
        .library(
            name: "SwiftGraphStoreTests",
            targets: ["SwiftGraphStoreTests"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
        .package(url: "https://github.com/famousj/UrsusHTTP", .upToNextMajor(from: "1.10.0")),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftGraphStore",
            dependencies: ["Alamofire", "UrsusHTTP"]),
        .testTarget(
            name: "SwiftGraphStoreTests",
            dependencies: ["SwiftGraphStore"],
            resources: [.process("Resources")]),
    ]
)
