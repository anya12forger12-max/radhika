# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | ✅ Supported       |

## Reporting a Vulnerability

Please report security vulnerabilities to the repository administrator. Do not create public issues for security vulnerabilities.

## Security Measures

- All data encrypted in transit (HTTPS/TLS)
- Firebase Authentication with email/password and Google Sign-In
- Firestore Security Rules prevent cross-user data access
- Local data encrypted using platform secure storage
- Input validation on all user inputs
- Session management with token refresh
- Crash logs do not contain sensitive user information
- Code obfuscation enabled in release builds

## Credential & Configuration Management

- The mobile app initializes Firebase with native configuration resolved from
  the platform files (`android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`)
  via the Firebase Gradle/CLI plugins — the Dart side calls `Firebase.initializeApp()`
  without inline options, so no Firebase API key lives in application source.
- Client-only public identifiers that are safe to embed by design (AdMob app/ad
  unit IDs, Firebase Android app identifiers) may appear in native config/build
  files, subject to the provider-supported restrictions applied in the Firebase
  console (package name + signing SHA-1 allowlist) and the AdMob consent flow.
- Backend/server-side secrets (none currently required by Radhika's Auth-only
  design) belong in environment/secret stores, never in source or public bundles.

## Best Practices

1. Never commit API keys or secrets to the repository
2. Use environment variables for configuration where a server-side component exists;
   for the mobile app, keep Firebase credentials in native config files supplied at
   build time (CI secret `GOOGLE_SERVICES_JSON` / platform files) rather than source
3. Keep dependencies updated
4. Follow the principle of least privilege
5. Regular security audits of Firestore rules
