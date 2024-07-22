#  Project Info Plist
An executable to generate or update a `Info.plist` for your Swift Package
Manager projects.

## Usage
Once installed the can be run as follows:
```zsh
$> create-project-plist --project-directory <path> --output-directory <path>
```

The two required options are:

1. `--project-directory`: The directory path of your Swift Package, for which
  the `Info.plist` shall be generated or updated.
2. `--output-directory`: The directory path, where the `Info.plist` shall be
  written to. If a `Info.plist` exists already there, it will be merged.
  
Run the executable with `--help` to see all options.

### Swift Run
Alternativly, if you do not want to build and install the command on your
system, you can use `swift run` inside your local copy of this repository:

```zsh
$> swift run -- create-project-plist --project-directory <path> --output-directory <path>
```

## Install
You can install `create-project-plist` using Homebrew:

```sh
> brew tap astzweig/formulae
> brew install create-project-plist
```

You can also just download the precompiled release version on the
[release page](https://github.com/astzweig/swift-project-info-plist/releases).
Alternativly you can just download this repository and build the executable
yourself using `swift build`.

## Changelog
This project keeps a [changelog](CHANGELOG.md) that adheres to
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
