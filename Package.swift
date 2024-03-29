// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CarManagementCore",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CarManagementCore",
            targets: ["CarManagementCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/Defaults.git", exact: "6.3.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "5.0.0"),
        .package(name: "RealmSwift", url: "https://github.com/realm/realm-swift.git", from: "10.39.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CarManagementCore",
            dependencies: [
                "Defaults",
                "Swinject",
                "SwiftDate",
                "RealmSwift",
            ]),
        .testTarget(
            name: "CarManagementCoreTests",
            dependencies: ["CarManagementCore"]),
    ]
)
