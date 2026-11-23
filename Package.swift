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
            .upToNextMinor(from: "4.11.1")
        )
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocV",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.7.3.zip",
            checksum: "869a596147dd74b5cd0147cc1304f58b295e6615b616829027b3d963781c7e3c"
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
