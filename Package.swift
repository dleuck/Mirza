// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mirza",
    platforms: [
        .macOS(.v13), .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Mirza",
            targets: ["Mirza"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dleuck/KiCore", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Mirza",
            dependencies: ["KiCore"]),
        .testTarget(
            name: "MirzaTests",
            dependencies: ["Mirza"]),
    ]
)
