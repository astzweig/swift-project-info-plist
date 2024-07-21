import Foundation
import ArgumentParser

@main
struct CreateProjectPlist: AsyncParsableCommand {
	typealias ProjectInformation = (bundleId: String, version: String, smallVersion: String)
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
		await self.createOrUpdateInfoPlist()
	}

	func createOrUpdateInfoPlist() async {
		let informations = await self.getProjectInformations()

		let plist = InfoPlist.at(directory: self.outputDirectory)
		plist.set(id: informations.bundleId)
		plist.set(name: self.target)
		plist.set(version: informations.version)
		plist.set(smallVersion: informations.smallVersion)

		try? plist.save()
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

	func getProjectInformations() async -> ProjectInformation {
		let projectDirectory = self.projectDirectory
		let target = self.target

		async let bundleId = PackageInfo.getProjectBundleId(for: projectDirectory, target: target)
		async let version = Git.getEnhancedVersion()
		async let smallVersion = Git.getTotalCommitCount()

		return await (bundleId, version, smallVersion)
	}

	static func argToDirectoryURL(_ path: String) -> URL {
		return URL.init(filePath: path, directoryHint: .isDirectory)
	}
}
