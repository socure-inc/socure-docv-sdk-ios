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
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.4.2.zip",
            checksum: "cbcda072c115884dcd22ce1649ff0a359f4f85b65c8b14210ae34f05aed3a583"
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
