#!/bin/bash

# Build / release Earn Time To Play for iOS App Store
# Usage:
#   ./build-ios.sh           # build IPA only (via Fastlane)
#   ./build-ios.sh beta      # TestFlight
#   ./build-ios.sh release   # App Store upload (+ submit if SUBMIT_FOR_REVIEW=true)
#   ./build-ios.sh submit    # submit latest build for review (no rebuild)

set -euo pipefail

LANE="${1:-build}"

echo "Building Earn Time To Play for iOS (lane: ${LANE})"
echo "=================================================="

if [[ ! -f "fastlane/.env" && -f "fastlane/env.example" ]]; then
  echo "Tip: copy fastlane/env.example → fastlane/.env and fill ASC API key / match settings."
fi

if command -v bundle >/dev/null 2>&1 && [[ -f "Gemfile" ]]; then
  bundle check >/dev/null 2>&1 || bundle install
  bundle exec fastlane ios "${LANE}"
else
  echo "bundle/Gemfile not available — falling back to flutter build ipa"
  flutter pub get
  (cd ios && pod install)
  flutter build ipa --release
  echo "Output: build/ios/ipa/*.ipa"
  echo "Upload with Transporter or: bundle exec fastlane ios beta"
fi
