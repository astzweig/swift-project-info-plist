# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2024-07-24

### Fixed

- Run `git` in the actual project directory. Previously all `git` calls happend
  from the current working directory, regardless if that was the project folder
  or not.

### Changed

- Our GitHub workflow now just notifies the repository of our [Homebrew Formula]
  that at least one formula is outdated instead of updating the formula itself.

## [1.1.0] - 2024-07-22

### Added

- Add GitHub workflow step to autoupdate our new [Homebrew Formula].
- Add section to README.md to show how to install the command.
- Add possibility to add additional keys to Info.plist via the command. Just
  supply further keys using `key:value` syntax, e.g.
  `create-project-plist ... SomeKey:"Some longer value" NextKey:AnotherValue`.

## [1.0.0] - 2024-07-21

### Added

- Added README.md and CHANGELOG.md.
- Implemented library `ProjectPlist`.
- Implemented CLI tool `create-project-plist`.


[Unreleased]: https://github.com/astzweig/swift-project-info-plist/compare/1.0.0...HEAD
[Homebrew Formula]: https://github.com/astzweig/homebrew-formulae/blob/main/Formula/create-project-plist.rb
[1.0.0]: https://github.com/astzweig/swift-project-info-plist/releases/tag/1.0.0...HEAD
