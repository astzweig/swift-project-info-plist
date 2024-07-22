import Foundation

public struct ProjectPlist {
	typealias ProjectInformation = (bundleId: String, version: String, smallVersion: String)

	public static func createOrUpdateInfoPlist(
		for projectDirectory: URL,
		at outputDirectory: URL,
		for target: String,
		with pairs: [String: String] = [:]
	) async throws {
		let informations = await Self.getInformations(for: projectDirectory, target: target)

		let plist = InfoPlist.at(directory: outputDirectory)
		plist.set(id: informations.bundleId)
		plist.set(name: target)
		plist.set(version: informations.version)
		plist.set(smallVersion: informations.smallVersion)
		pairs.forEach { key, value in
			plist.setValue(value, forKey: key)
		}

		try plist.save()
	}

	private static func getInformations(for projectDirectory: URL, target: String) async -> ProjectInformation {
		async let bundleId = PackageInfo.getProjectBundleId(for: projectDirectory, target: target)
		async let version = Git.getEnhancedVersion()
		async let smallVersion = Git.getTotalCommitCount()

		return await (bundleId, version, smallVersion)
	}
}
