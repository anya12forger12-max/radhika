#!/bin/bash
set -e

flutter pub get
flutter test test/widget_test.dart
flutter build apk --release
flutter build web --release --pwa-strategy=offline-first
