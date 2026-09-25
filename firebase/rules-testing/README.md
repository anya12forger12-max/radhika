# Radhika Firebase Security Rules Tests

Runs the Firestore + Storage security rules against the **Firebase Emulator**
proving the authorization model before any release:

| # | Case | Expected |
|---|------|----------|
| 1 | Unauthenticated user | denied |
| 2 | User A -> User B data | denied |
| 3 | User A -> User A data | allowed |
| 4 | User A -> change own role to admin | denied |
| 4b | Server-issued `admin` custom claim | allowed (positive control) |
| 5 | Normal user -> admin-only Storage op | denied |
| 6 | User A -> modify User B predictions | denied |
| 7 | User A -> modify own prediction fields | denied |
| - | Storage per-user isolation | denied cross-user |
| - | Admin claim -> admin/public Storage | allowed |

## Why this model

- Admin authorization is granted **only** via Firebase Authentication custom
  claims (`request.auth.token.admin == true`), which the client cannot write.
- The `role` field on a user document is **rejected by the rules** even for the
  owner, so a normal user can never escalate.
- Prediction documents are **read-only** for the client; results must come from
  trusted application logic.

## Running

```bash
cd firebase/rules-testing
npm install
npm test
```

`npm test` starts the emulators (`firestore` + `storage`) via
`firebase emulators:exec` and runs the suite against them.

## Notes

- The suite targets the emulators only; no real Firebase project data is
  touched. A dummy `GCLOUD_PROJECT` is used for the test environment.
- Storage rules cannot currently be live-deployed (the project has no Storage
  bucket) but are kept hardened and exercised by the emulator.