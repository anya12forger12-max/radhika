# Radhika — Intellectual Property and Licensing

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## A. Ownership Overview

### Repository Ownership
- **GitHub account**: anya12forger12-max
- **Repository**: https://github.com/anya12forger12-max/radhika.git
- **License**: MIT License (Copyright (c) 2026 Radhika)
- **Contributors**: anya (125 commits), "Your Name" (27 commits), anya12forger12-max (6 commits), dependabot[bot] (5 commits), opencode (1 commit)

### Original Work
- All application source code in `lib/` appears to be original work
- Educational content in `lib/screens/education/` is original (no external source URLs)
- UI design and theme system is original
- No evidence of copied or adapted third-party code beyond standard SDK usage

### Third-Party Contributions
- dependabot[bot]: Automated dependency update PRs
- "Your Name <you@example.com>": 27 commits (likely parallel session work)
- opencode: 1 commit (likely tooling)

### Ownership Questions
- The "Your Name" committer identity suggests multiple developers or automated tooling
- No contributor agreements or IP assignment documents exist
- No evidence of contractor or agency work

---

## B. Intellectual Property Inventory

| Asset | Location | Creator | Ownership Evidence | Third-Party Deps | License |
|---|---|---|---|---|---|
| Application source code | `lib/` | Original (anya) | Git commit history | Flutter SDK, Firebase, etc. | MIT (project) |
| Educational content | `lib/screens/education/` | Original | Git commit history | None | MIT (project) |
| UI theme/design | `lib/core/theme/` | Original | Git commit history | Material Design (Google) | MIT (project) |
| Documentation | `docs/`, `*.md` | Original | Git commit history | None | MIT (project) |
| Logo/branding | None found | N/A | No logo assets in repo | N/A | N/A |
| Database schema | Hive adapters in `lib/models/` | Original | Git commit history | Hive (Apache 2.0) | MIT (project) |
| Build scripts | `bin/`, `.github/workflows/` | Original | Git commit history | GitHub Actions | MIT (project) |
| Tests | `test/`, `integration_test/` | Original | Git commit history | flutter_test (SDK) | MIT (project) |

### No Logo or Brand Assets
- No image files (PNG, SVG, etc.) in `assets/` (directory is empty)
- App uses Material Icons (bundled with Flutter SDK)
- No custom logo or brand identity files found

---

## C. License Audit

### Project License
- **MIT License** (Copyright (c) 2026 Radhika)
- Permits: use, copy, modify, merge, publish, distribute, sublicense, sell
- Condition: include copyright notice and permission notice in all copies
- No copyleft or source-disclosure requirements

### Key Dependencies and Their Licenses

| Dependency | Version | License | Commercial Use | Notes |
|---|---|---|---|---|
| Flutter SDK | 3.47.x | BSD-3-Clause | ✅ Yes | Google |
| Firebase Auth | ^5.5.1 | Apache 2.0 | ✅ Yes | Google |
| Firebase Crashlytics | ^4.3.10 | Apache 2.0 | ✅ Yes | Google |
| Hive | ^2.2.3 | Apache 2.0 | ✅ Yes | Isar |
| flutter_secure_storage | ^9.2.4 | MIT | ✅ Yes | — |
| google_mobile_ads | ^9.1.0 | Apache 2.0 | ✅ Yes | Google (AdMob terms apply) |
| google_sign_in | ^6.3.0 | Apache 2.0 | ✅ Yes | Google |
| Riverpod | ^2.6.1 | MIT | ✅ Yes | Remi Rousselet |
| fl_chart | ^0.70.2 | MIT | ✅ Yes | — |
| intl | ^0.20.2 | BSD-3-Clause | ✅ Yes | Dart team |
| path_provider | ^2.1.5 | BSD-3-Clause | ✅ Yes | Flutter team |
| flutter_local_notifications | ^18.0.1 | BSD-3-Clause | ✅ Yes | — |
| share_plus | ^10.1.4 | BSD-3-Clause | ✅ Yes | — |
| timezone | ^0.10.1 | BSD-3-Clause | ✅ Yes | — |
| table_calendar | ^3.2.1 | Apache 2.0 | ✅ Yes | — |
| flutter_animate | ^4.5.2 | MIT | ✅ Yes | — |
| package_info_plus | ^9.0.1 | BSD-3-Clause | ✅ Yes | — |

### License Compatibility
- **No conflicting licenses identified**: All dependencies use permissive licenses (MIT, Apache 2.0, BSD-3-Clause)
- **No copyleft licenses** (GPL, LGPL, AGPL) in the dependency tree
- **No source-disclosure requirements** from any dependency
- **AdMob SDK**: Subject to Google AdMob terms of service (separate from Apache 2.0 license)

### Potential Concerns
1. **AdMob terms**: Using AdMob requires compliance with Google's advertising policies, including consent management (UMP) which is implemented.
2. **Firebase terms**: Firebase services are subject to Google Cloud terms of service and Firebase terms.
3. **No third-party assets**: No images, fonts, or media files are bundled (only Material Icons from Flutter SDK).

---

## D. Branding Findings

### Brand Name: "Radhika"
- Used consistently across the application (app name, package name `com.radhika.app`, GitHub repo)
- No trademark registration evidence found
- No domain name registration found in repository
- No logo or brand identity files in repository (uses Material Icons)

### Tagline: "Your Health Companion"
- Used in splash screen
- No trademark claim

### Brand Colors
- Primary: Rose (0xFFE91E63) — M3 seed color
- Secondary: Purple (0xFF9C27B0)
- Tertiary: Orange (0xFFFF9800)
- No registered trademark on color scheme

### Trademark Status
- **NOT VERIFIED**: No trademark search or registration has been performed
- **Recommendation**: Conduct a trademark search in relevant jurisdictions before commercial distribution
- **Risk**: "Radhika" is a common Indian name; potential for existing trademark conflicts

---

## E. Contributor Findings

### Contributors
| Name | Commits | Identity |
|---|---|---|
| anya | 125 | Primary developer |
| "Your Name" | 27 | Likely parallel session or automated tooling |
| anya12forger12-max | 6 | GitHub account owner |
| dependabot[bot] | 5 | Automated dependency updates |
| opencode | 1 | Tooling |

### Missing Agreements
- No contributor license agreements (CLAs)
- No IP assignment agreements
- No confidentiality agreements
- No contractor work agreements
- No content contribution agreements

### Risk
- Contributors other than the primary developer may retain copyright to their contributions
- "Your Name" commits (27) have an unidentified author
- dependabot[bot] commits are automated and don't require IP assignment

---

## F. Commercial Distribution Findings

### APK Distribution
- **License**: MIT permits unrestricted distribution
- **Firebase Auth**: Subject to Firebase terms (free tier available)
- **AdMob**: Subject to AdMob terms (revenue sharing)
- **No restrictions** on APK distribution from license perspective

### Commercial Use Considerations
1. **MIT License**: Allows commercial use, modification, distribution, and sublicensing
2. **AdMob**: Revenue-generating; must comply with Google's advertising policies
3. **Firebase**: Free tier available; paid tier for high usage
4. **No subscription/paywall**: App is free with ads

### Restrictions
- None identified from open-source licenses
- AdMob and Firebase terms must be reviewed for commercial deployment
- No healthcare regulatory compliance (FDA, HIPAA, etc.) — app is educational only

---

## G. Files Created

| File | Purpose |
|---|---|
| `docs/IP_AND_LICENSING.md` | This document — IP inventory, license audit, branding, contributor findings, commercial distribution |

---

## H. Risk Register

| # | Risk | Severity | Evidence | Recommendation |
|---|---|---|---|---|
| 1 | No trademark search/registration | MEDIUM | No trademark files in repo | Conduct trademark search before commercial distribution |
| 2 | Unidentified contributor ("Your Name") | MEDIUM | 27 commits from unknown identity | Identify contributor; obtain IP assignment if needed |
| 3 | No contributor agreements | MEDIUM | No CLA or IP assignment docs | Prepare contributor agreement templates |
| 4 | No logo/brand assets | LOW | No image files in assets/ | Create brand identity if commercializing |
| 5 | AdMob terms compliance | LOW | AdMob SDK integrated | Review AdMob publisher policies |
| 6 | No healthcare regulatory review | MEDIUM | App provides health education | Consult legal counsel for health app regulations |

---

## I. Professional Legal-Review Requirements

1. **Trademark**: Conduct formal trademark search for "Radhika" in relevant jurisdictions
2. **Copyright**: Clarify ownership of "Your Name" contributor's 27 commits
3. **Healthcare regulations**: Determine if app requires FDA/CE marking or health authority registration
4. **Privacy**: Verify GDPR/CCPA compliance for health data handling (app is local-only, but analytics may apply)
5. **AdMob**: Review Google's advertising policies for health-related content
6. **Contributor agreements**: Prepare and execute CLAs for all contributors

---

## J. Final Readiness Decision

**DOCUMENTATION COMPLETE WITH LEGAL REVIEW REQUIRED**

The project's licensing is clean (MIT + permissive dependencies). No blocking licensing issues identified. However, trademark verification, contributor IP clarification, and healthcare regulatory review are required before commercial distribution.

Supporting evidence:
- MIT License present and valid
- All dependencies use permissive licenses (MIT, Apache 2.0, BSD-3-Clause)
- No copyleft or source-disclosure requirements
- No third-party assets requiring attribution
- No hardcoded secrets or proprietary code
- Clean dependency audit (0 vulnerabilities in app code)
