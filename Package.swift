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
            .upToNextMinor(from: "4.10.0")
        )
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocV",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.5.1.zip",
            checksum: "29111d8e1c908887be8ae4be07641bed07e1dc67c648d038aba788207dd9d7ec"
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
