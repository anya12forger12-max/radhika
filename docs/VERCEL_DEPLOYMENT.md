# Deploying Radhika to Vercel (Flutter Web)

Radhika is a Flutter app. Vercel has no Flutter runtime, so the deployment
provisions the pinned Flutter SDK during the build and publishes the static
web bundle (`build/web`) as a normal static site.

## Files added for deployment

| File | Purpose |
| --- | --- |
| `vercel.json` | Build command, output directory, SPA fallback rewrite, cache + security headers. |
| `vercel_build.sh` | Downloads Flutter `3.47.5` (cached in `$HOME`), runs `flutter pub get` and `flutter build web --release`. Forwards Firebase web config from the Vercel project environment. |
| `.vercelignore` | Keeps mobile platform folders, tests, build output and secrets out of the upload. |

## Deploy

```bash
cd radhika
vercel login          # required once; --prod needs credentials
vercel --prod
```

The first run links the directory to a Vercel project. Framework preset can be
left as **Other** — `vercel.json` supplies everything.

A deployment made without credentials is possible with
`vercel deploy --temporary`, but it expires after 60 minutes and is served from
a `*.tmp.now` hostname rather than `*.vercel.app`.

## Web authentication (required for sign-in)

The mobile builds read `android/app/google-services.json` /
`ios/Runner/GoogleService-Info.plist`. A web build has no equivalent file, so
the web Firebase credentials must be supplied as build-time environment
variables on the Vercel project:

```
FIREBASE_API_KEY
FIREBASE_APP_ID
FIREBASE_MESSAGING_SENDER_ID
FIREBASE_PROJECT_ID
FIREBASE_AUTH_DOMAIN
FIREBASE_STORAGE_BUCKET
GOOGLE_WEB_CLIENT_ID        # optional, enables "Continue with Google"
```

`vercel_build.sh` forwards any that are set to `flutter build web` via
`--dart-define`. Without them the app still boots, but sign-in is disabled and
the login screen explains that web sign-in is not configured.

### Firebase console steps

1. **Project settings → General → Your apps → Add app → Web** in project
   `radhika-app-5d885`. Copy the generated `appId`, `apiKey`,
   `messagingSenderId`, `authDomain`, `storageBucket` into the Vercel env vars.
2. **APIs & Services → Credentials → the project API key → Application
   restrictions**: the existing key is restricted to Android apps and rejects
   browser requests (`403 Requests from this Android client application are
   blocked`). Either add an HTTP-referrer restriction for the Vercel domain or
   create a separate browser key.
3. **Authentication → Settings → Authorized domains**: add the Vercel domain.
4. **Authentication → Sign-in method**: confirm Email/Password (and Google, if
   used) are enabled.

## Local verification

```bash
flutter build web --release --no-wasm-dry-run
cd build/web && python3 -m http.server 8089
# open http://localhost:8089
```

## Notes

- `web/` (Flutter's web shell: `index.html`, `manifest.json`, icons) must be
  committed for Git-integration deploys. It is currently untracked in this
  repository.
- `build/web` is generated and must not be committed; `.vercelignore` keeps it
  out of the upload.
- Web-only limitations: local notifications, AdMob, Crashlytics and
  path-based report exports have no web implementation. Startup code catches
  the missing plugins, and ads are skipped on web.
