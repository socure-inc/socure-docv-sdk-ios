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
            targets: ["SocureDocV"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/socure-inc/socure-sigmadevice-sdk-ios", "4.5.2"..<"4.6.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocVBinary",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.2.5.zip",
            checksum: "a6cb1064e467a4ac75eabaf7600bc549e4dbed7eb0519c00ac25db67b1050c4e"
        ),
        .target(
            name: "SocureDocV",
            dependencies: [
                "SocureDocVBinary",
                .product(name: "DeviceRisk", package: "socure-sigmadevice-sdk-ios")
            ],
            path: "Sources/SocureDocV",
            publicHeadersPath: "."
        )
    ]
)
