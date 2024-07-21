import Foundation

struct InfoPlist {
	let file: URL
	let data: NSMutableDictionary

	init(file: URL) {
		self.file = file
		self.data = NSMutableDictionary(contentsOf: self.file) ?? NSMutableDictionary()
		self.setDefaultValues()
	}

	func setDefaultValues() {
		self.data.setValue("6.0", forKey: kCFBundleInfoDictionaryVersionKey as String)
		self.data.setValue("APPL", forKey: "CFBundlePackageType")
	}

	func save() throws {
		try self.data.write(to: self.file)
	}

	func set(id: String) {
		self.data.setValue(id, forKey: kCFBundleIdentifierKey as String)
	}

	func set(version: String) {
		self.data.setValue(version, forKey: kCFBundleVersionKey as String)
	}

	func set(smallVersion: String) {
		self.data.setValue(smallVersion, forKey: "CFBundleShortVersionString")
	}

	func set(name: String) {
		self.data.setValue(name, forKey: kCFBundleNameKey as String)
	}

	func setValue(_ value: Any?, forKey key: String) {
		self.data.setValue(value, forKey: key)
	}

	static func at(directory: URL) -> Self {
		let file = directory.appending(path: "Info.plist", directoryHint: .notDirectory)
		return Self.init(file: file)
	}
}
