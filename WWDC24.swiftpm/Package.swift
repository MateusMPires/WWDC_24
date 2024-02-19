// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "WWDC24",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "WWDC24",
            targets: ["AppModule"],
            bundleIdentifier: "Mateus.SSC24",
            teamIdentifier: "GTH77F75XH",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .images),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .landscapeRight,
                .landscapeLeft
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)