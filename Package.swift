// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocureDocV",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SocureDocV",
            targets: ["SocureDocVWrapper"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/socure-inc/socure-sigmadevice-sdk-ios",
            .upToNextMinor(from: "4.11.0")
        )
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocV",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.7.2.zip",
            checksum: "a5958e84c57b14d44532ca0dffb9a11590b486814f75c3cb0e8d857ce3049d78"
        ),
        .target(
            name: "SocureDocVWrapper",
            dependencies: [
                "SocureDocV",
                .product(name: "DeviceRisk", package: "socure-sigmadevice-sdk-ios")
            ],
            path: "Sources/SocureDocV",
            publicHeadersPath: "."
        )
    ]
)
