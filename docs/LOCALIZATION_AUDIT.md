# Radhika — Localization Audit

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## A. Existing Localization Architecture

### Before This Round
- **No localization infrastructure existed**
- No `.arb` files, no `l10n.yaml`, no `flutter_localizations` dependency
- All user-facing strings hardcoded in English in Dart source files
- `intl` package present (used for date formatting only)
- `flutter_timezone` used for timezone detection

### After This Round
- **`flutter_localizations`** added to dependencies
- **`l10n.yaml`** created (arb-dir: lib/l10n, template: app_en.arb)
- **`lib/l10n/app_en.arb`** created with 60+ translation keys (English template)
- **`lib/l10n/app_localizations.dart`** generated (output class: AppLocalizations)
- **`generate: true`** added to pubspec.yaml flutter section
- All generated files compile cleanly

### Current State
- **Supported languages**: English only (template language)
- **Translation coverage**: 0% (template created, no translations yet)
- **Indian languages supported**: 0 (infrastructure ready, translations needed)

## B. Localization Inventory

### Hardcoded Strings Identified
The following screens contain hardcoded English strings that would need extraction:

| Screen | Approx. Strings | Notes |
|---|---|---|
| education_screen.dart | ~30 | Medical content, topic titles |
| pad_guide_screen.dart | ~20 | Product guide sections |
| tampon_guide_screen.dart | ~20 | Product guide sections |
| cup_guide_screen.dart | ~20 | Product guide sections |
| login_screen.dart | ~10 | Form labels, buttons, errors |
| register_screen.dart | ~10 | Form labels, buttons, errors |
| home_screen.dart | ~15 | Dashboard labels, quick actions |
| settings_screen.dart | ~20 | Settings tiles, labels |
| calendar_screen.dart | ~10 | Calendar labels |
| reports_screen.dart | ~15 | Report labels, statistics |
| recommendations_screen.dart | ~10 | Tip labels |
| profile_screen.dart | ~10 | Profile fields |
| help_center_screen.dart | ~15 | Help topics |
| feedback_screen.dart | ~15 | Feedback form |
| privacy_policy_screen.dart | ~20 | Policy text |

**Total estimated**: ~200+ hardcoded strings across 15 screens

### Medical Terminology
- Menstrual cycle phases (follicular, ovulation, luteal)
- Hormone names (estrogen, progesterone, FSH, LH)
- Medical conditions (endometriosis, fibroids, PCOS, PID, adenomyosis)
- Product names (pads, tampons, cups, applicators)
- Symptom names (cramps, bloating, fatigue, etc.)

## C. Indian Language Support Status

| Language | Script | Status | Notes |
|---|---|---|---|
| English | Latin | ✅ Template created | Base language |
| Hindi | Devanagari | ❌ Not started | Infrastructure ready |
| Telugu | Telugu | ❌ Not started | Infrastructure ready |
| Tamil | Tamil | ❌ Not started | Infrastructure ready |
| Kannada | Kannada | ❌ Not started | Infrastructure ready |
| Malayalam | Malayalam | ❌ Not started | Infrastructure ready |
| Bengali | Bengali | ❌ Not started | Infrastructure ready |
| Marathi | Devanagari | ❌ Not started | Infrastructure ready |
| Gujarati | Gujarati | ❌ Not started | Infrastructure ready |
| Punjabi | Gurmukhi | ❌ Not started | Infrastructure ready |
| Odia | Odia | ❌ Not started | Infrastructure ready |
| Urdu | Arabic (RTL) | ❌ Not started | Requires RTL layout support |

## D. Infrastructure Created

### Files
- `l10n.yaml` — localization configuration
- `lib/l10n/app_en.arb` — English template (60+ keys)
- `lib/l10n/app_localizations.dart` — generated localization class
- `lib/l10n/app_localizations_en.dart` — generated English implementation

### pubspec.yaml Changes
- Added `flutter_localizations: sdk: flutter` dependency
- Added `generate: true` to flutter section

## E. Remaining Work

1. **Extract hardcoded strings** from all 15 screens into `.arb` files
2. **Create translations** for 11 Indian languages (requires native speakers + medical review)
3. **Wire up `AppLocalizations`** in `MaterialApp` (localizationsDelegates, supportedLocales)
4. **Add language selection** to settings screen
5. **Add language preference persistence** (Hive settings box)
6. **Test Indian script rendering** on Android devices
7. **Add RTL support** for Urdu
8. **Create medical terminology glossary** for translators
9. **Add localization tests** (missing translation detection, layout overflow)

## F. Medical Terminology Considerations

- Medical terms should NOT be literally translated if the result is misleading
- "Menstruation" has established translations in most Indian languages
- Product names (pads, tampons, cups) may need transliteration + explanation
- TSS (Toxic Shock Syndrome) should retain English acronym with local explanation
- Hormone names (estrogen, progesterone, FSH, LH) should retain English with local explanation

## G. Final Classification

**PARTIALLY IMPLEMENTED — INFRASTRUCTURE READY, TRANSLATIONS PENDING**

The localization infrastructure is now in place (flutter_localizations, l10n.yaml, .arb template, generated code). However, no actual translation has occurred. All user-facing strings remain hardcoded in English. Full multilingual support requires native-language translators and medical reviewers.
