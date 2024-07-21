import Basics
import PackageModel
import Workspace
import Foundation

struct PackageInfo {
	let manifest: Manifest

	func getProjectName() -> String {
		self.manifest.displayName
	}

	func hasTarget(named name: String) -> Bool {
		let matchingTargets = self.manifest.targets.filter {
			$0.name == name
		}
		return matchingTargets.count == 1
	}

	static func fromSwiftPackage(at projectDirectory: URL) async throws -> PackageInfo {
		let currentWorkingDirectory = try AbsolutePath(
			validating: FileManager.default.currentDirectoryPath
		)
		let packageDir = try AbsolutePath(
			validating: projectDirectory.relativePath,
			relativeTo: currentWorkingDirectory
		)

		let observability = ObservabilitySystem({_,_ in })
		let workspace = try Workspace(forRootPackage: packageDir)
		let manifest = try await workspace.loadRootManifest(at: packageDir, observabilityScope: observability.topScope)
		return Self.init(manifest: manifest)
	}
}
