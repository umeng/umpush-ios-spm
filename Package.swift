// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "UMPush",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "UMPush", targets: ["UMPush", "UMPushResources"]),
    ],
    dependencies: [
        .package(url: "https://github.com/umeng/umcommon-ios-spm.git", exact: "7.7.0"),
    ],
    targets: [
        .binaryTarget(
            name: "UMPush",
            path: "UMPush.xcframework"
        ),
        // UMPush.framework is a static framework that loads ad/interstitial
        // images via `[NSBundle bundleForClass:]` -> mainBundle, so
        // UMPushResource.bundle has to be copied into the app bundle. This
        // shim target also carries the SwiftPM-level dependency on UMCommon,
        // which binary targets are not allowed to declare directly.
        .target(
            name: "UMPushResources",
            dependencies: [
                "UMPush",
                .product(name: "UMCommon", package: "umcommon-ios-spm"),
            ],
            path: "Sources/UMPushResources",
            resources: [
                .copy("UMPushResource.bundle"),
            ]
        ),
    ]
)
