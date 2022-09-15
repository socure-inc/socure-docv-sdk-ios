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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(
            name: "SocureDocV",
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-3.0.2.zip",
            checksum: "52e3461b35061a10851045be4bb525b4187d9c624a6e69968a8069f0527f2682"
        )
    ]
)
