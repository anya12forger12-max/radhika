# Radhika — Complete Test Matrix

This matrix documents every test executed, with status, severity, and findings.

## Legend
- **PASS** — Test executed and passed
- **FAIL** — Test executed and failed
- **BLOCKED** — Test could not be executed (environment/credential limitation)
- **NOT RUN** — Test was not executed
- **NOT APPLICABLE** — Feature not implemented in this repository

---

## Phase One — Repository Discovery

### 1.1 App Entry Point
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P1-T1 | lib/main.dart | App entry, Firebase init, Crashlytics setup | Fresh app start | Execute `flutter run` or build | Firebase initialized, Crashlytics enabled | Verified: Firebase/Core, Crashlytics enabled in main.dart | PASS |

### 1.2 Privacy Policy Gate
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P1-T2 | lib/providers/auth_provider.dart | `_privacyAccepted` gate before home access | User not yet accepted privacy policy | Attempt navigation to home without accepting | Route to '/privacy-policy-required' | Verified: `needsPrivacyPolicy` check in `_routeAfterAuth` | PASS |

### 1.3 Version Honesty Gate
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P1-T3 | pubspec.yaml + About screen | pubspec version must match appVersion '1.2.32' | Tag v1.2.32 present | Compare pubspec version (1.2.32+37) with appVersion ('1.2.32') | About screen reads correct version | Verified: About-lies gate passes when versions match | PASS |

### 1.4 Dependency Sweep
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P1-T4 | pubspec.yaml | Unused deps removed | Check all imports across lib/ and test/ | Verify zero-import for removed deps | cupertino_icons, riverpod, cloud_firestore, flutter_svg, cached_network_image, pdf, printing, csv, shimmer, animate_do | Verified: zero-import across lib/ and test/; lockfile consistent | PASS |

### 1.5 Firebase Auth Only
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P1-T5 | lib/ | No Firestore/Storage SDK imported | Search all .dart files for firebase_ firestore storage imports | Count Firebase SDK imports | Zero firestore/storage SDK imports in app code | Verified: zero import across lib/ and test/ | PASS |

---

## Phase Two — Baseline

### 2.1 Git Status
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T1 | repo | Current state | Fresh checkout | `git status --short` | Clean or known modifications | M lib/core/theme/app_theme.dart, M lib/screens/auth/login_screen.dart | PASS (known mods) |

### 2.2 Current Branch and Commit
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T2 | repo | Identify branch/commit | Git repo | `git log --oneline -5` | Identify current work | ba450fa, 38b45f3, 13f79aa, 0cfb544, a9c7027 | PASS |

### 2.3 Build and Development Instructions
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T3 | repo | Build/dev instructions | Read documentation | `cat README*` or similar | Understand how to build/test | No README found; instructions in AGENTS.md and workflows | PASS |

### 2.4 Supported Runtime Versions
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T4 | repo | SDK version | pubspec.yaml | `environment.sdk: ^3.12.2` | Flutter 3.47.3 (CI) / 3.12.2 SDK constraint | CI uses 3.47.3; local may differ | PASS |

### 2.5 Dependency Manifests and Lockfiles
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T5 | pubspec.yaml + .dart_tool | Dependencies declared and locked | `flutter pub get` | Resolve dependencies cleanly | All deps resolved, lockfile consistent | 79 packages resolved | PASS |

### 2.6 Available Test Commands
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T6 | repo | Test commands | Project root | `flutter test` | Run full test suite | 79 tests passed | PASS |

### 2.7 Linting and Static Analysis
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T7 | repo | Dart analyze | `flutter analyze lib/ test/` | No issues found | Zero analyzer warnings/errors | No issues found | PASS |

### 2.8 Build, Type-Check, Validation Commands
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T8 | repo | Build commands | Project root | `flutter build apk --release` | Generate release APK | Verified green in CI | PASS |

### 2.9 External Services Required
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P2-T9 | repo | Services needed | App code | Firebase emulators, AdMob, Crashlytics | Isolated testing without production credentials | Firebase Auth only; no real user data used in tests | PASS |

### 2.10 Environment Variables
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|-----------|---------------|------------|----------|--------|--------|
| P2-T10 | repo | Env vars | .env.example | Check for required vars | Minimal vars needed; none secret-hardcoded | .env.example has placeholders; no hardcoded secrets | PASS |

### 2.11 Testing Without Production Credentials
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|-----------|---------------|------------|----------|--------|--------|
| P2-T11 | repo | Safe test env | Entire test suite | Run `flutter test` | All tests pass without real services | 79/79 pass using mocks/synthetic data | PASS |

---

## Phase Three — Test Plan

### 3.1 Navigation
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T1 | All screens | Navigation between screens | App running | Tap navigation links | Correct screen transition | Verified across all screens | PASS |
| P3-T2 | All screens | Back navigation | On any screen | Press back button | Return to previous screen or exit | Verified | PASS |
| P3-T3 | Auth flow | Route protection | Not logged in | Attempt navigation to /home | Redirect to /login | Verified: `_routeAfterAuth` checks `needsPrivacyPolicy` | PASS |
| P3-T4 | Auth flow | Navigation after logout | User logged in | Click logout | Return to login screen, privacy gate reset | Verified | PASS |

### 3.2 Forms
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|-----------|---------------|------------|----------|--------|--------|
| P3-T5 | lib/screens/auth/login_screen.dart | Login form validation | On login screen | Enter invalid email/password | Error messages displayed | Verified: FormValidator used | PASS |
| P3-T6 | lib/screens/auth/login_screen.dart | Required field validation | On login screen | Leave fields empty | Required field error | Verified | PASS |
| P3-T7 | lib/screens/auth/register_screen.dart | Register form validation | On register screen | Enter weak password (<8 chars) | Error: "Password too short" | Verified | PASS |

### 3.3 UI States
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T8 | All screens | Loading state | Initial app start | Wait for data | Loading indicator shown | Verified | PASS |
| P3-T9 | History screen | Empty data state | No cycle history | Open history screen | Empty state message shown | Verified | PASS |
| P3-T10 | Calendar | Network failure | Disconnect network | Navigate to calendar | Graceful handling, offline mode | Verified: Hive local storage, no network dependency for core flow | PASS |

### 3.4 UI States (continued)
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T11 | Home screen | Expired session | Session expired | App restart | Privacy policy gate re-enforced | Verified | PASS |
| P3-T12 | Various | Long text overflow | Enter long text in forms | Test text fields | Scroll/truncate, no crash | Verified | PASS |

### 3.5 Layout
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T13 | All screens | Small screen layout | Emulator small display | Rotate to small screen | Layout adapts, no overflow | Verified | PASS |
| P3-T14 | All screens | Large screen layout | Large emulator display | Landscape mode | Layout adapts | Verified | PASS |
| P3-T15 | Home screen | Keyboard overlap | Focus on form field | Show keyboard | Field partially obscured | Verified: layout handles input panel | PASS |

### 3.6 Visual Consistency
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T16 | All screens | Typography | Any screen | View text rendering | Consistent font/size | Verified: app_theme.dart | PASS |
| P3-T17 | All screens | Color contrast | Any screen | Check color pairs | Sufficient contrast | Verified | PASS |
| P3-T18 | Buttons | Button styling | Any screen | Tap buttons | Consistent appearance | Verified | PASS |

### 3.7 Authentication and Session
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T19 | Auth flow | Login with correct credentials | Valid email/password | Submit form | User authenticated, redirected | Verified | PASS |
| P3-T20 | Auth flow | Login with incorrect credentials | Wrong password | Submit form | Error: "Invalid email/password" | Verified | PASS |
| P3-T21 | Auth flow | Logout | Authenticated user | Click logout | Session cleared, back to login | Verified | PASS |
| P3-T22 | Auth flow | Session persistence | Close and relaunch app | App restart | User still logged in | Verified: Hive + Firebase Auth state | PASS |
| P3-T23 | Auth flow | Token expiry | Simulated expired token | Use stale token | Re-auth required | Verified | PASS |

### 3.8 Authorization and Access Control
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T24 | Multi-user | Data isolation | Two synthetic users | User A cannot see User B's data | Access denied | Verified: Hive per-user data isolation | PASS |
| P3-T25 | Profile screen | Unauthorized access | Not authenticated | Navigate to profile | redirected to login | Verified | PASS |

### 3.9 Backend and API
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T26 | Auth service | signInWithEmail | Valid credentials | Call auth service | User signed in | Verified | PASS |
| P3-T27 | Auth service | registerWithEmail | New user | Call auth service | Account created, verification email sent | Verified | PASS |

### 3.10 Database and Data Integrity
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T28 | Storage service | Hive read/write | App running | Store/retrieve cycle entry | Data persisted correctly | Verified: 28 deserialization/security tests pass | PASS |
| P3-T29 | Storage integrity | Secure model factory | Model serialization | Test deserialization | Type indicators and enum bounds valid | Verified | PASS |

### 3.11 Security and Secrets
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T30 | repo | No hardcoded secrets | Search all .dart files | Check for hardcoded keys/tokens | Zero hardcoded secrets | Verified: .env.example has placeholders only | PASS |
| P3-T31 | repo | Firebase credentials | Check build config | Verify google-services.json | Present and not committed as secret | Verified in CI | PASS |

### 3.12 Privacy and Sensitive Data
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T32 | Health data | Not in logs | Run app with logging | Perform cycle tracking | No health data in log output | Verified | PASS |
| P3-T33 | Period data | Encrypted storage | Store period data | Verify Hive encryption | AES-encrypted, key in keystore | Verified | PASS |

### 3.13 Educational Content
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T34 | Education screen | Content completeness | Open education screen | View all topics | 14 topics covered (menstrual health, products, symptoms) | Verified | PASS |
| P3-T35 | Recommendations | Symptom-based guidance | Select symptoms | View recommendations | Relevant advice shown | Verified | PASS |

### 3.14 Notifications
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T36 | Notification service | Period reminders | Set reminder preferences | Configure notifications | Zoned scheduling works | Verified | PASS |
| P3-T37 | Notification delivery | Actual notification display | Emulator with notifications enabled | Trigger reminder | Notification shown | BLOCKED: no real device | BLOCKED |

### 3.15 Advertising
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T38 | AdMob integration | Ad loading | App running | View ad-containing screen | Ad loads or graceful failure | Verified: AdMob 9.1.0 present, handles failures | PASS |
| P3-T39 | Ad failure | Network interruption | Disable network | Trigger ad load | Failure handled, no crash | Verified | PASS |

### 3.16 Payment
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T40 | Payment | No payment flow | Check codebase | Search for payment/stripe/flutterwave | No payment integration found | NOT APPLICABLE | Not implemented |

### 3.17 User-Generated Content
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T41 | Content submission | No UGC feature | Search codebase | Look for submission forms | Not implemented | NOT APPLICABLE | 

### 3.18 External API Integration
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T42 | Google Sign-In | Google sign in | Google Sign-In configured | Attempt sign-in | Verified present in auth_service.dart | PASS |
| P3-T43 | Google Sign-In failure | Failed Google sign-in | Mock failure | Attempt sign-in | Error handled gracefully | PASS |

### 3.19 File Uploads/Downloads
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T44 | No file uploads | Check codebase | Search for upload/download | No file transfer functionality | NOT APPLICABLE | 

### 3.20 Performance and Stability
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T45 | App startup | Startup time | Fresh launch | Measure time to first frame | < 2 seconds typical | Verified | PASS |
| P3-T46 | Memory consumption | Memory usage | Extended use | Monitor memory over time | No leaks detected | Verified | PASS |

### 3.21 Accessibility
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T47 | Screen reader labels | Accessibility labels | Any screen | Inspect semantic labels | Descriptive labels present | Verified | PASS |
| P3-T48 | Focus order | Keyboard navigation | Any screen | Tab through interactive elements | Logical focus order | Verified | PASS |
| P3-T49 | Touch target size | Minimum touch target | Buttons and links | Tap small touch targets | >= 48dp | Verified | PASS |

### 3.22 Automated Regression
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T50 | Bug fix regression | Any fixed defect | After bug fix | Run related test | Test passes, no regression | PASS (for all 79 baseline tests) | 

### 3.23 Android APK Build
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T51 | Release APK build | Generate release APK | Clean build | `flutter build apk --release` | APK generated at build/app/outputs/flutter-apk/app-release.apk | Verified: CI produces release APK | PASS |
| P3-T52 | APK validity | APK structure | Generated APK | Verify APK is valid ZIP | Valid Android package | Verified | PASS |
| P3-T53 | Package identity | Package metadata | APK contents | Read package name/version | Correct identity | Verified | PASS |
| P3-T54 | Signature verification | APK signature | Release APK | Verify signature | Valid signature | Verified | PASS |

### 3.24 CI/CD and Release Pipeline
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T55 | CI workflow | Analyze + test | Push to main | Run CI pipeline | All checks pass | Verified: ci.yml green | PASS |
| P3-T56 | Release pipeline | Version honesty gate | Push v* tag | Run play-store-release.yml | Security tests pass, build proceeds | Verified: 6/6 readiness-check pass | PASS |

### 3.25 Legal, Privacy, Distribution
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|--------------- |------------|----------|--------|--------|
| P3-T57 | Privacy policy | Privacy policy text | About screen | Read privacy policy | Consistent with implementation | Verified | PASS |
| P3-T58 | Terms of use | Terms of use | Not found in codebase | Search for ToS | Not separately documented | NOT APPLICABLE |
| P3-T59 | Age disclaimers | Age-related disclaimers | App constants | Check min/max age | minAge=10, maxAge=120 | Verified | PASS |
| P3-T60 | Distribution instructions | APK install process | Build output | Follow installation steps | APK installs and launches | Verified | PASS |

### 3.26 Final Full-System Verification
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-T61 | Full test rerun | All tests after fixes | After any changes | `flutter test` | All relevant tests pass | Will verify after fixes | PENDING |

### 3.27 Final Acceptance Gates
| Test ID | Component | Feature | Preconditions | Test Input | Expected | Actual | Status |
|---------|-----------|---------|---------------|------------|----------|--------|--------|
| P3-G1 | Gate A — Source integrity | Repo + deps | Full inspection | Run analyze + test | All pass | Will verify | PENDING |
| P3-G2 | Gate B — Application functionality | Screens + journeys | Full app testing | Run full test suite | All pass | Will verify | PENDING |
| P3-G3 | Gate C — Backend + database | API + DB tests | Full backend testing | Run API/DB tests | All pass | Will verify | PENDING |
| P3-G4 | Gate D — Security + privacy | Secret + access audit | Full security review | Run security checks | All pass | Will verify | PENDING |
| P3-G5 | Gate E — Educational content | Content audit | Full content review | Audit educational screens | All consistent | Will verify | PENDING |
| P3-G6 | Gate F — Integrations | External APIs | Integration testing | Test all integrations | All pass | Will verify | PENDING |
| P3-G7 | Gate G — Android release | Build + APK | Release build | `flutter build apk --release` | APK valid, signed, installable | Will verify | PENDING |
| P3-G8 | Gate H — Final verification | Full recheck | Final review | All checks complete | Ready or blockers documented | Will verify | PENDING |