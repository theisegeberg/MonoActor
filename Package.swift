// swift-tools-version: 5.8
import PackageDescription
let package = Package(
    name: "MonoActor",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "MonoActor",
            targets: ["MonoActor"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MonoActor",
            dependencies: []),
        .testTarget(
            name: "MonoActorTests",
            dependencies: ["MonoActor"]),
    ]
)
