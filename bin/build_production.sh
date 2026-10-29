#!/usr/bin/env bash
# Unified Production Build Script for Radhika App
# This script performs a clean build process including tests and APK/Web builds

set -e  # Exit immediately if any individual pipeline command throws an error state

echo "🌸 Starting Unified Radhika Production Compilation Loop..."

# 1. Fetch framework dependencies securely
echo "📥 Resolving third-party project packages..."
flutter pub get

# 2. Run the comprehensive cryptographic database, Firebase, and Stress test checks
echo "🧪 Executing secure integration, runtime, and volumetric stress test suites..."
flutter test

# 3. Compile the production-ready native Android APK asset package
echo "🤖 Building optimized, release-signed Android mobile binary..."
flutter build apk --release

# 4. Compile the frictionless browser PWA alternative target layout
echo "🌐 Building web engine configuration with offline-first PWA caching..."
flutter build web --release --pwa-strategy=offline-first

# 5. Automatically deploy the compiled PWA engine assets to Firebase Hosting logs
echo "🚀 Transmitting production Web PWA builds directly to Firebase Hosting servers..."
if command -v firebase &> /dev/null; then
  firebase deploy --only hosting:radhika-pwa
  echo "✅ Web Application is live at: https://web.app"
else
  echo "⚠️ Firebase CLI engine not found locally. Skipping remote hosting sync."
fi

echo "✨ All production pipelines completed successfully!"
echo "📱 APK: build/app/outputs/flutter-apk/app-release.apk"
echo "🌐 Web: build/web/"