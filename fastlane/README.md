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

Build iOS IPA + Android AAB (no upload)

----


## iOS

### ios sync_certs

```sh
[bundle exec] fastlane ios sync_certs
```

Create/update App Store certs & profiles via match (run once / when expired)

### ios build

```sh
[bundle exec] fastlane ios build
```

Build IPA only (no upload)

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload to TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Build, upload metadata + binary to App Store Connect, optionally submit for review

### ios submit

```sh
[bundle exec] fastlane ios submit
```

Upload + submit for review. Builds unless SKIP_BUILD=true. SKIP_BINARY_UPLOAD=true submits the latest ASC build only.

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Upload metadata only (descriptions, privacy URL, etc.)

----


## Android

### android build

```sh
[bundle exec] fastlane android build
```

Build release AAB only (no upload)

### android validate

```sh
[bundle exec] fastlane android validate
```

Validate Play Store metadata + AAB (dry run, no upload)

### android metadata

```sh
[bundle exec] fastlane android metadata
```

Upload store listing metadata only (no binary)

### android beta

```sh
[bundle exec] fastlane android beta
```

Build and upload to Google Play Internal Testing

### android release

```sh
[bundle exec] fastlane android release
```

Promote to production and submit for review (auto-publish after Google approval unless Managed publishing is on). PLAY_UPLOAD_AAB=true builds and uploads a new AAB instead.

### android promote

```sh
[bundle exec] fastlane android promote
```

Promote latest internal/closed build to production (no rebuild)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
