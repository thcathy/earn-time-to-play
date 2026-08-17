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

- **Onboarding**: first-run walkthrough of the earn → spend loop
- **Tracking**: quick-add entries + stopwatch for real-time Focus/Play tracking
- **Streaks**: daily tracking streak on the Today screen to build habit
- **Share progress**: invite friends with balance, totals, and streak
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

### iOS App Store (full pipeline)

Fastlane can build, upload metadata, push the binary, and submit for review.

**One-time setup (Mac with Xcode)**

1. Create the app in [App Store Connect](https://appstoreconnect.apple.com) with bundle ID `com.thcathy.earntimetoplay` (if it does not exist yet).
2. Create an **App Store Connect API key** (Users and Access → Integrations → App Store Connect API) with App Manager access. Download the `.p8` file.
3. Copy env template and fill secrets:
   ```bash
   cp fastlane/env.example fastlane/.env
   # set APP_STORE_CONNECT_API_KEY_ID / ISSUER_ID / KEY_PATH
   ```
4. Install Ruby deps:
   ```bash
   bundle install
   ```
5. **Signing (pick one)**
   - *Automatic (default):* leave `MATCH_GIT_URL` empty; Xcode manages profiles (`-allowProvisioningUpdates`).
   - *Match (recommended for CI):* create a private certs repo, set `MATCH_GIT_URL` + `MATCH_PASSWORD`, then:
     ```bash
     bundle exec fastlane ios sync_certs
     ```
6. **Screenshots:** first submission needs screenshots in App Store Connect, or under `fastlane/screenshots/` with `SKIP_SCREENSHOTS=false`. See `fastlane/screenshots/README.md`.
7. Update `fastlane/metadata/review_information/phone_number.txt` with a real contact number.

**Commands**

```bash
# Build IPA only
bundle exec fastlane ios build
# or
./build-ios.sh

# TestFlight
bundle exec fastlane ios beta
./build-ios.sh beta

# App Store: upload binary + metadata and submit for review
bundle exec fastlane ios release
./build-ios.sh release

# Submit latest uploaded build (no rebuild)
bundle exec fastlane ios submit

# Metadata only
bundle exec fastlane ios metadata
```

Useful `.env` knobs: `SUBMIT_FOR_REVIEW`, `AUTOMATIC_RELEASE`, `PHASED_RELEASE`, `SKIP_SCREENSHOTS`, `SKIP_METADATA`.

Store listing copy lives in `fastlane/metadata/` (en-US, zh-Hant, zh-Hans).

### Android

```bash
bundle exec fastlane android beta     # Play internal (draft)
bundle exec fastlane android release  # Play production (draft)
```

While the Play app is still a **Draft app**, uploads use `release_status: "draft"` (already configured).

## Secrets / signing (do not commit)

These are intentionally gitignored:
- `android/key.properties`
- `android/*.jks` (e.g. `android/upload-keystore.jks`)
- `fastlane/play-store-key.json`
- `fastlane/.env`
- `*.p8`, `*.p12`, `*.mobileprovision`, `*.cer`, `*.certSigningRequest`

See `android/key.properties.template` and `fastlane/env.example` for the expected format.

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
