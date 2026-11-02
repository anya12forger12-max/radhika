# Radhika — Onboarding Audit

## A. Existing Onboarding Architecture

### Screen Sequence
1. **SplashScreen** (`/`) — Shows app name "Radhika" + tagline "Your Health Companion" with fade animation. Minimum 1.5s display. Routes based on auth state:
   - Authenticated + needs privacy policy → `/privacy-policy-required`
   - Authenticated + privacy accepted → `/home`
   - Not authenticated → `/login`

2. **LoginScreen** (`/login`) — Email/password + Google Sign-In. Requires privacy policy acceptance checkbox before sign-in. Links to Register and Forgot Password.

3. **RegisterScreen** (`/register`) — Email/password/confirm + privacy policy acceptance. Auto-navigates to privacy gate on success.

4. **PrivacyPolicyScreen** (`/privacy-policy-required`) — Mandatory privacy policy acceptance gate. Blocks home access until accepted.

5. **HomeScreen** (`/home`) — Main dashboard with quick actions.

### Stored Onboarding Preferences
- `onboarding_complete` (bool) — not currently used in splash routing
- `privacy_policy_accepted` (bool) — enforced via auth provider
- Theme mode, font size — persisted in settings box

### Authentication Dependencies
- Firebase Auth (email/password + Google Sign-In)
- Privacy policy acceptance required before home access
- Session persistence via Firebase Auth (auto sign-in on app restart)

### Permission Dependencies
- Notifications (requested when user enables reminders in Settings)
- No camera/storage permissions at onboarding (requested contextually)

### Existing Defects
- None identified in current onboarding flow

### Missing Functionality
- No dedicated welcome/introduction screens
- No feature tutorials or guided tours
- No language selection during onboarding
- No onboarding progress tracking (beyond privacy acceptance)
- No skip controls for optional steps (no optional steps exist)
- No first-use tooltips

### Accessibility Support
- Splash screen has Semantics labels (logo, app name, tagline)
- Login/register have semantic labels
- Touch targets: 48dp minimum on buttons
- Screen reader compatible (verified in round 32)

### Test Coverage
- `widget_test.dart` — basic widget smoke test
- `auth_error_mapping_test.dart` — 13 auth error mapping tests
- No dedicated onboarding tests

## B. Onboarding Screen Inventory

| Screen | Purpose | Status |
|---|---|---|
| SplashScreen | App identity + auth-based routing | ✅ Implemented |
| LoginScreen | Email/password + Google sign-in | ✅ Implemented |
| RegisterScreen | Account creation | ✅ Implemented |
| ForgotPasswordScreen | Password reset | ✅ Implemented |
| PrivacyPolicyScreen | Mandatory consent gate | ✅ Implemented |

## C. User Experience Findings

1. **No welcome screen**: Users go directly from splash to login. No introduction to app features.
2. **No feature discovery**: No guided tour or feature highlights on first launch.
3. **Educational content gated behind auth**: Users cannot browse education without an account. This is a design decision (health data privacy) but may reduce initial engagement.
4. **No skip option**: No optional onboarding steps to skip (because none exist).
5. **Privacy policy is mandatory**: This is correct for a health app — users must consent before accessing features.

## D. Privacy Findings

- Privacy policy acceptance is mandatory before home access ✅
- No sensitive health data collected during onboarding ✅
- No menstrual history required for account creation ✅
- Consent is persisted and checked on every app launch ✅

## E. Permission Findings

| Permission | When Requested | Justified? |
|---|---|---|
| Notifications | When user enables reminders in Settings | ✅ Yes — only when feature is used |
| No camera at onboarding | Requested contextually (QR scanner) | ✅ Yes — only when feature is used |
| No storage at onboarding | Not requested | ✅ Correct — local storage only |

## F. Persistence Findings

- Auth state persists via Firebase Auth (auto sign-in on restart) ✅
- Privacy acceptance persists via Hive settings box ✅
- Theme/font preferences persist via Hive ✅
- No onboarding completion flag used in routing (privacy acceptance serves this role)

## G. Files Changed This Session

No onboarding code changes made. This is an audit-only document.

## H. Testing Evidence

- `flutter analyze lib/ test/` → 0 issues
- `flutter test` → 91/91 passed
- No dedicated onboarding tests (gap documented)

## I. Remaining Limitations

1. No welcome/introduction screens (by design — minimal friction)
2. No feature tours or tooltips
3. No language selection (English only)
4. No onboarding progress tracking beyond privacy acceptance
5. Educational content requires authentication (design decision)

## J. Final Readiness Decision

**READY WITH DOCUMENTED LIMITATIONS**

The onboarding flow is minimal but functional. Users can sign up, accept privacy policy, and reach the home screen. The flow is accessible (Semantics labels, 48dp touch targets) and handles auth state correctly. The main gap is the absence of feature introductions and guided tours, which are UX enhancements rather than blockers.
