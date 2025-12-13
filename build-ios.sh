#!/bin/bash

# Build Time Bank for Play for iOS App Store
# Usage: ./build-ios.sh

set -e  # Exit on any error

echo "🍎 Building Time Bank for Play for iOS"
echo "======================================="

# Step 1: Clean
echo ""
echo "🧹 Cleaning previous build..."
flutter clean

# Step 2: Get dependencies
echo ""
echo "📦 Getting dependencies..."
flutter pub get

# Step 3: Install pods
echo ""
echo "🫛 Installing CocoaPods..."
cd ios && pod install && cd ..

# Step 4: Build IPA
echo ""
echo "🔨 Building iOS release..."
flutter build ipa --release

echo ""
echo "✅ iOS build complete!"
echo ""
echo "📦 Output: build/ios/ipa/time_bank_for_play.ipa"
echo ""
echo "Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Product → Archive (or use Transporter app)"
echo "3. Upload to App Store Connect"
echo "4. Submit for review in App Store Connect"
