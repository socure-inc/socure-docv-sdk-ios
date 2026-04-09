// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocureDocV",
    platforms: [
        .iOS(.v13)
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
            .upToNextMinor(from: "4.8.1")
        )
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocV",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.4.1.zip",
            checksum: "d8f6dc2ee9b90647cbc0525a5f4b5a714ca11b8193030f64de192f340623f79a"
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
