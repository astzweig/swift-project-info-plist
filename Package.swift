// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "swift-project-info-plist",
    products: [
        .executable(
            name: "create-project-plist",
            targets: ["CreateProjectPlist"]),
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
	],
    targets: [
		.executableTarget(
			name: "CreateProjectPlist",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			]
		)
    ]
)
