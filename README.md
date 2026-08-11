# Earn Time To Play

A Flutter app that helps gamers balance productivity with entertainment by tracking focus time vs play time.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

Earn Time To Play uses a simple concept: **earn time by focusing, spend time by playing**. 

- Focus on productive activities (studying, working, learning) to deposit time into your "bank"
- Withdraw from your balance when you want to play games
- Play is only allowed when your balance is positive (configurable)

## Features

- **Tracking**: quick-add entries + stopwatch for real-time Focus/Play tracking
- **History**: browse, edit, and delete past entries
- **Analytics**: charts and stats (weekly focus vs play, balance trend, distribution)
- **Rules**: warning threshold, optional max play/day, allow overdraft toggle
- **Export**: export all entries to CSV (share sheet)
- **Local-first**: data stored locally on-device

## Tech Stack

- **Flutter 3.x** with Dart
- **Riverpod** for state management
- **Hive** for local storage (structured data)
- **SharedPreferences** for settings
- **go_router** for navigation
- **fl_chart** for analytics charts
- **Lucide Icons** for iconography
- **Google Fonts** (Inter) for typography

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/thcathy/earn-time-to-play.git
   cd earn-time-to-play
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Build

```bash
# Android App Bundle
flutter build appbundle --release

# iOS IPA
flutter build ipa --release

# Web
flutter build web --release --no-wasm-dry-run
```

## Deploy (Web)

This repo includes a Cloudflare Pages deploy script:

```bash
./deploy-web.sh
```

It builds `build/web`, copies `privacy-policy.html`, then deploys via Wrangler.

## Release (Mobile)

### Android — Google Play (full pipeline)

Fastlane can build a signed AAB, upload listing metadata, changelogs, and push to a Play track.

**One-time setup**

1. Create the app in [Google Play Console](https://play.google.com/console) with package `com.thcathy.earntimetoplay`.
2. **Signing:** generate an upload keystore and `android/key.properties`:
   ```bash
   keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   cp android/key.properties.template android/key.properties
   ```
3. **Play API access:** Google Cloud → create service account → grant Play Console access (Release manager) → download JSON key as `fastlane/play-store-key.json` (see `fastlane/play-store-key.json.example`).
4. Configure release env:
   ```bash
   cp fastlane/env.example fastlane/.env
   bundle install
   ```
5. **Store assets:** first submission needs screenshots + feature graphic in Play Console, or under `fastlane/metadata/android/.../images/` with `SKIP_UPLOAD_SCREENSHOTS=false` (see `fastlane/metadata/android/images/README.md`).

**Commands**

```bash
# Build AAB only
./build-android.sh
bundle exec fastlane android build

# Internal testing (default PLAY_TRACK=internal, PLAY_RELEASE_STATUS=draft)
./build-android.sh beta
bundle exec fastlane android beta

# Production upload + metadata
./build-android.sh release
bundle exec fastlane android release

# Listing / changelogs only
bundle exec fastlane android metadata

# Dry-run validation (no upload)
PLAY_VALIDATE_ONLY=true bundle exec fastlane android validate

# Promote internal build → production (no rebuild)
bundle exec fastlane android promote
```

Useful `.env` knobs: `PLAY_TRACK`, `PLAY_RELEASE_STATUS` (`draft` while the Play app is still a Draft app), `PLAY_ROLLOUT`, `SKIP_UPLOAD_*`.

Listing copy: `fastlane/metadata/android/` (en-US, zh-CN, zh-TW).

### iOS — App Store

See [PR #2](https://github.com/thcathy/earn-time-to-play/pull/2) for the full App Store Connect pipeline (metadata, submit for review, API key, match).

Basic lanes today:

```bash
fastlane ios build
fastlane ios beta
fastlane ios release
```

## Secrets / signing (do not commit)

These are intentionally gitignored:
- `android/key.properties`
- `android/*.jks` (e.g. `android/upload-keystore.jks`)
- `fastlane/play-store-key.json`
- `fastlane/.env`
- `*.p12`, `*.mobileprovision`, `*.cer`, `*.certSigningRequest`

See `android/key.properties.template`, `fastlane/env.example`, and `fastlane/play-store-key.json.example`.

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App widget & routing
├── core/
│   ├── theme/
│   │   ├── app_theme.dart    # Light/dark themes
│   │   └── colors.dart       # Color palette
│   └── constants.dart        # App constants
├── models/
│   ├── day_entry.dart        # Daily time entry model
│   └── settings.dart         # App settings model
├── providers/
│   ├── time_bank_provider.dart   # Main state management
│   └── theme_provider.dart       # Theme state
├── services/
│   └── storage_service.dart  # Persistence layer
├── screens/
│   ├── today/                # Main screen
│   ├── history/              # History list
│   ├── settings/             # App settings
│   └── analytics/            # Charts & stats
├── widgets/
│   ├── app_icon.dart         # Custom app icon
│   ├── balance_display.dart  # Balance with status
│   ├── stopwatch_timer.dart  # Real-time timer
│   └── ...                   # Other components
└── utils/
    └── time_utils.dart       # Time formatting helpers
```

## Design

The app features a clean, peaceful UI with:

- **Light and Dark mode** support with system preference detection
- **Emerald green** for Focus activities (productive, calming)
- **Violet purple** for Play activities (fun, playful)
- **Material 3** design language
- **Smooth animations** and transitions
- **Custom hourglass icon** representing time flow

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Author

**Timmy Wong**
- Email: thcathy@gmail.com
- GitHub: [@thcathy](https://github.com/thcathy)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Riverpod](https://riverpod.dev/) - State management
- [Lucide Icons](https://lucide.dev/) - Beautiful icons
- [fl_chart](https://pub.dev/packages/fl_chart) - Charts library
