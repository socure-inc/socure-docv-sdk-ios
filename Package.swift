// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "SocureDocV",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SocureDocV",
            targets: ["SocureDocV"]),
    ],
    dependencies: [
        .package(url: "https://github.com/socure-inc/socure-sigmadevice-sdk-ios", from: "4.4.0")
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocV",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.0.7.zip",
            checksum: "d5e9008cd48e45ba090e4b4373093c248019ffaff9b23b0efaea8b2f67a47641"
        )
    ]
)
