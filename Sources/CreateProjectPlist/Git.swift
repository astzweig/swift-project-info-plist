import Foundation

struct Git {
	enum Error: Swift.Error {
		case noOutput
		case nonZeroExit
	}

	static func getEnhancedVersion() async -> String {
		let tag: String, commitCount: String
		if let latestTag = try? await Self.getLatestTag() {
			tag = latestTag
			commitCount = await self.getCommitCountSince(tag: tag)
		} else {
			tag = "0.0.0"
			commitCount = await self.getTotalCommitCount()
		}
		let version = "\(tag)+\(commitCount)"
		return version
	}

	static func getLatestTag() async throws -> String {
		var tags = try await Self.run(command: "tag").components(separatedBy: "\n")
		tags.removeLast()
		guard let tag = tags.last else {
			throw Self.Error.noOutput
		}
		return tag
	}

	static func getCommitCountSince(tag: String) async -> String {
		do {
			return try await self.getCommitCountSince(commit: tag)
		} catch {
			return await self.getTotalCommitCount()
		}
	}

	static func getCommitCountSince(commit: String) async throws -> String {
		let commits = try await Self.run(command: "rev-list", args: "--count", commit)
		return commits.trimmingCharacters(in: .newlines)
	}

	static func getTotalCommitCount() async -> String {
		return (try? await self.getCommitCountSince(commit: "--all")) ?? "0"
	}

	static private func run(command: String, args: String...) async throws -> String {
		var gitArgs = [command]
		gitArgs.append(contentsOf: args)

		let process = Self.getProcessFor(args: gitArgs)
		let output = try await Self.run(process: process)
		return output
	}

	static private func getProcessFor(args: [String]) -> Process {
		let process = Process()
		process.executableURL = URL(filePath: "/usr/bin/env")
		process.arguments = ["git"] + args
		return process
	}

	static private func run(process: Process) async throws -> String {
		let outputPipe = Pipe()
		process.standardOutput = outputPipe

		try process.run()
		process.waitUntilExit()

		guard process.terminationStatus == 0 else {
			throw Self.Error.nonZeroExit
		}

		guard let outputData = try outputPipe.fileHandleForReading.readToEnd() else {
			return ""
		}
		let output = String(decoding: outputData, as: UTF8.self)
		return output
	}
}
