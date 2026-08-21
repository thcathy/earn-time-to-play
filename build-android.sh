#!/bin/bash

# Build / release Earn Time To Play for Google Play
# Usage:
#   ./build-android.sh           # build AAB only
#   ./build-android.sh beta      # internal testing upload
#   ./build-android.sh release   # promote internal → production and submit for review
#   PLAY_UPLOAD_AAB=true ./build-android.sh release  # build + upload new AAB to production
#   ./build-android.sh metadata  # listing only
#   ./build-android.sh validate  # dry-run upload validation

set -euo pipefail

# Prefer Homebrew Ruby. macOS /usr/bin/ruby is 2.6 and cannot load Bundler 4.
if [[ -x /opt/homebrew/opt/ruby/bin/bundle ]]; then
  export PATH="/opt/homebrew/opt/ruby/bin:${PATH}"
fi

LANE="${1:-build}"

echo "Building Earn Time To Play for Android (lane: ${LANE})"
echo "======================================================"

if [[ ! -f "android/key.properties" ]]; then
  echo ""
  echo "android/key.properties not found."
  echo "1. Generate keystore:"
  echo "   keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload"
  echo "2. Copy template:"
  echo "   cp android/key.properties.template android/key.properties"
  echo ""
  exit 1
fi

if [[ ! -f "fastlane/play-store-key.json" && -f "fastlane/play-store-key.json.example" && "${LANE}" != "build" ]]; then
  echo ""
  echo "fastlane/play-store-key.json not found (required for upload lanes)."
  echo "See fastlane/play-store-key.json.example and fastlane/env.example"
  echo ""
  exit 1
fi

if [[ ! -f "fastlane/.env" && -f "fastlane/env.example" ]]; then
  echo "Tip: cp fastlane/env.example fastlane/.env to configure PLAY_TRACK / PLAY_RELEASE_STATUS."
fi

if command -v bundle >/dev/null 2>&1 && [[ -f "Gemfile" ]]; then
  bundle check >/dev/null 2>&1 || bundle install
  bundle exec fastlane android "${LANE}"
else
  echo "bundle/Gemfile not available — falling back to flutter build appbundle"
  flutter pub get
  flutter build appbundle --release
  echo "Output: build/app/outputs/bundle/release/app-release.aab"
  echo "Upload with: bundle exec fastlane android beta"
fi
