// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swift-project-info-plist",
	platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v16), .watchOS(.v9)],
    products: [
		.library(name: "ProjectPlist", targets: ["ProjectPlist"]),
        .executable(
            name: "create-project-plist",
            targets: ["CreateProjectPlist"]),
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
		.package(url: "https://github.com/apple/swift-package-manager", revision: "swift-5.10.1-RELEASE"),
	],
    targets: [
		.target(
			name: "ProjectPlist",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "SwiftPM-auto", package: "swift-package-manager")
			]
		),
		.executableTarget(name: "CreateProjectPlist", dependencies: ["ProjectPlist"])
    ]
)
