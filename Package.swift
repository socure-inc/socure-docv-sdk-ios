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
            url: "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-4.0.1.zip",
            checksum: "5a5f3ceec55b2725b525e2249695f2dc4369f80c88c526dabf01e4bf2012d635"
        )
    ]
)
