#!/usr/bin/env bash
# Unified Production Build Script for Radhika App
# This script performs a clean build process including tests and APK/Web builds

set -e  # Exit immediately if any individual pipeline command throws an error state

echo "🌸 Starting Unified Radhika Production Compilation Loop..."

# 1. Fetch framework dependencies securely
echo "📥 Resolving third-party project packages..."
flutter pub get

# 2. Run tests
echo "🧪 Executing tests..."
flutter test test/widget_test.dart

# 3. Compile the production-ready native Android APK asset package
echo "🤖 Building optimized, release-signed Android mobile binary..."
flutter build apk --release

# 4. Compile the frictionless browser PWA alternative target layout
echo "🌐 Building web engine configuration with offline-first PWA caching..."
flutter build web --release --pwa-strategy=offline-first

echo "✨ All production pipelines completed successfully!"
echo "📱 APK: build/app/outputs/flutter-apk/app-release.apk"
echo "🌐 Web: build/web/"
