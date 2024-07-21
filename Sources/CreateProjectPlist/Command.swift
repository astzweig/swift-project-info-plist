import Foundation
import ArgumentParser

@main
struct CreateProjectPlist: ParsableCommand {
	static var configuration = CommandConfiguration(abstract: "Generate a Info.plist using project and git informations.")

	@Option(
		help: "The path to the local SwiftPM project.",
		transform: Self.argToDirectoryURL
	)
	var projectDirectory: URL

	@Option(
		help: ArgumentHelp(
			"The directory path where the Info.plist file shall be written to.",
			discussion: "An existing Info.plist file will be merged."
		),
		transform: Self.argToDirectoryURL
	)
	var outputDirectory: URL

	mutating func run() throws {
	}

	static func argToDirectoryURL(_ path: String) -> URL {
		return URL.init(filePath: path, directoryHint: .isDirectory)
	}
}
