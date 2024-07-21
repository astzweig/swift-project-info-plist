import Foundation
import ArgumentParser

@main
struct CreateProjectPlist: AsyncParsableCommand {
	static var configuration = CommandConfiguration(abstract: "Generate a Info.plist using project and git informations.")

	enum Error: Swift.Error {
		case noPackageManifestFound
	}

	@Option(
		help: "The path to the local SwiftPM project.",
		transform: Self.argToDirectoryURL
	)
	var projectDirectory: URL

	@Option(help: "The name of the target if it shall be included.")
	var target = "TestDrive"

	@Option(
		help: ArgumentHelp(
			"The directory path where the Info.plist file shall be written to.",
			discussion: "An existing Info.plist file will be merged."
		),
		transform: Self.argToDirectoryURL
	)
	var outputDirectory: URL

	mutating func run() async {
		self.updateProjectDirectory()
	}

	func getProjectBundleId() async -> String {
		guard let packageInfo = try? await PackageInfo.fromSwiftPackage(at: self.projectDirectory) else {
			fatalError("Could not evaluate package informations.")
		}
		let projectName = packageInfo.getProjectName()
		let hostname = Host.current().name?.split(separator: ".").reversed().joined(separator: ".") ?? "Unknown"
		return "\(hostname).swiftpm.\(projectName).\(self.target)"
	}

	mutating func updateProjectDirectory() {
		var projectDirectory = self.projectDirectory
		while true {
			let manifest = projectDirectory.appending(path: "Package.swift")
			if FileManager.default.fileExists(atPath: manifest.path()) {
				break
			}
			guard projectDirectory.pathComponents.count > 1 else {
				fatalError("No Package.swift found in project or any parent folder \(self.projectDirectory)")
			}
			projectDirectory.deleteLastPathComponent()
		}
		self.projectDirectory = projectDirectory
	}

	static func argToDirectoryURL(_ path: String) -> URL {
		return URL.init(filePath: path, directoryHint: .isDirectory)
	}
}