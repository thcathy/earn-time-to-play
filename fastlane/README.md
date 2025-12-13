fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_all

```sh
[bundle exec] fastlane build_all
```

Build all platforms

----


## iOS

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload to App Store Connect (TestFlight)

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and upload to App Store (Production)

### ios build

```sh
[bundle exec] fastlane ios build
```

Build iOS app only (no upload)

----


## Android

### android beta

```sh
[bundle exec] fastlane android beta
```

Build and upload to Google Play (Internal Testing)

### android release

```sh
[bundle exec] fastlane android release
```

Build and upload to Google Play (Production)

### android build

```sh
[bundle exec] fastlane android build
```

Build Android app only (no upload)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
