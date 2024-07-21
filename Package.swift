// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "swift-project-info-plist",
    products: [
        .executable(
            name: "create-project-plist",
            targets: ["CreateProjectPlist"]),
    ],
    targets: [
		.executableTarget(name: "CreateProjectPlist")
    ]
)
