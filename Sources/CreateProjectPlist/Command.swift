import Foundation
import ArgumentParser
import ProjectPlist

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

	@Option(help: "The name of the target to be included in the bundle Id.")
	var target = "TestDrive"

	@Option(
		help: ArgumentHelp(
			"The directory path where the Info.plist file shall be written to.",
			discussion: "An existing Info.plist file will be merged."
		),
		transform: Self.argToDirectoryURL
	)
	var outputDirectory: URL

	@Argument(help: "Further key:value pairs to be added to the Info.plist.")
	var pairs: [String] = []

	mutating func run() async {
		let pairs = self.getPairsAsDictionary()
		self.updateProjectDirectory()
		try? await ProjectPlist.createOrUpdateInfoPlist(for: self.projectDirectory, at: self.outputDirectory, for: self.target, with: pairs)
	}

	func getPairsAsDictionary() -> [String : String] {
		let listPairs = self.pairs.map { $0.components(separatedBy: ":") }
		let tuplePairs = listPairs.compactMap(Self.arrayPairToTuple)
		let dictPairs = Dictionary(tuplePairs, uniquingKeysWith: { _,latest in latest })
		return dictPairs
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

	static func arrayPairToTuple(_ element: [String]) -> (String, String)? {
		guard element.count > 1 else { return nil }
		return (element[0], element[1])
	}

	static func argToDirectoryURL(_ path: String) -> URL {
		return URL.init(filePath: path, directoryHint: .isDirectory)
	}
}
