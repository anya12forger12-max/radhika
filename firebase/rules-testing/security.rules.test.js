/**
 * Radhika Firestore + Storage Security Rules — Firebase Emulator tests.
 *
 * Covers the required security matrix:
 *   1. Unauthenticated user -> denied
 *   2. User A -> User B's data -> denied
 *   3. User A -> User A's data -> allowed
 *   4. User A -> change own role to admin -> denied
 *   5. Normal user -> admin-only Storage operation -> denied
 *   6. User A -> modify User B's predictions -> denied
 *   7. User A -> modify protected/generated prediction fields -> denied
 * plus positive controls: a server-issued `admin` custom claim grants /admin
 * and appSettings access (claims cannot be set by the client).
 *
 * Run: npm install && npm test
 */
const { test, before, after, beforeEach } = require('node:test');
const assert = require('node:assert/strict');
const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');

const PROJECT_ID = 'radhika-rules-test';

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: { host: '127.0.0.1', port: 8080 },
    storage: { host: '127.0.0.1', port: 9199 },
  });
});

after(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.clearStorage();
});

const anon = () => testEnv.unauthenticatedContext();
const asUserA = (overrides = {}) =>
  testEnv.authenticatedContext('user-A', overrides);
const asUserB = (overrides = {}) =>
  testEnv.authenticatedContext('user-B', overrides);

// Firestore rule checks -------------------------------------------------------

test('1. Unauthenticated user is denied Firestore access', async () => {
  const db = anon().firestore();
  await assertFails(db.doc('users/user-A').get());
  await assertFails(db.doc('admin/meta').get());
});

test('2. User A cannot read or write User B data', async () => {
  await asUserB().firestore().doc('users/user-B').set({ name: 'B' });

  const a = asUserA().firestore();
  await assertFails(a.doc('users/user-B').get());
  await assertFails(a.doc('users/user-B/symptoms/s1').set({ pain: 4 }));
  await assertFails(a.doc('users/user-B/cycles/c1').set({ start: '2026-01-01' }));
});

test('3. User A can read and write their own data', async () => {
  const a = asUserA().firestore();
  await assertSucceeds(a.doc('users/user-A').set({ name: 'A' }));
  await assertSucceeds(
    a.doc('users/user-A/symptoms/s1').set({ pain: 4, symptom: 'cramps' }),
  );
  await assertSucceeds(a.doc('users/user-A').get());
});

test('4. User A cannot escalate to admin (role field write denied)', async () => {
  const a = asUserA().firestore();
  await assertFails(a.doc('users/user-A').set({ name: 'A', role: 'admin' }));
  await assertSucceeds(a.doc('users/user-A').set({ name: 'A' }));
  await assertFails(a.doc('users/user-A').update({ role: 'admin' }));
  await assertFails(a.doc('admin/meta').set({ banner: 'x' }));
  await assertFails(a.doc('appSettings/general').set({ value: 'x' }));
  await assertFails(a.doc('appSettings/general').update({ value: 'x' }));
});

test('4b. Positive control: server-issued admin custom claim is honoured', async () => {
  const adminCtx = testEnv.authenticatedContext('user-A', { admin: true });
  const db = adminCtx.firestore();
  await assertSucceeds(db.doc('users/user-A').set({ name: 'A' }));
  await assertSucceeds(db.doc('admin/meta').set({ banner: 'x' }));
  await assertSucceeds(db.doc('appSettings/general').set({ value: 'x' }));
});

test('6. User A cannot modify User B predictions', async () => {
  // Seed via a rules-bypassing context: clients cannot write predictions at
  // all (read-only), so plain owner seeding would itself be denied.
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await ctx.firestore().doc('users/user-B/predictions/p1').set({
      nextPeriod: '2026-02-01',
      confidence: 0.9,
    });
  });

  const a = asUserA().firestore();
  await assertFails(a.doc('users/user-B/predictions/p1').get());
  await assertFails(
    a.doc('users/user-B/predictions/p1').update({ nextPeriod: '2026-01-01' }),
  );
  await assertFails(a.doc('users/user-B/predictions/p2').set({ fake: true }));
});

test('7. Predictions are read-only for clients (no arbitrary client writes)', async () => {
  const a = asUserA().firestore();
  await assertFails(a.doc('users/user-A/predictions/p1').set({ guess: true }));
  await assertFails(a.doc('users/user-A/predictions/p1').update({ guess: true }));
});

// Storage rule checks ---------------------------------------------------------

test('5. Normal user cannot perform admin-only Storage operations', async () => {
  const a = asUserA();
  await assertFails(a.storage().ref('admin/secrets.txt').putString('top-secret'));
  await assertFails(a.storage().ref('public/banner.png').putString('fake-asset'));
  await assertFails(a.storage().ref('admin/secrets.txt').getDownloadURL());
});

test('Storage: users are isolated in Storage', async () => {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await ctx.storage().ref('users/user-B/photo.png').putString('me');
  });
  const a = asUserA().storage();
  await assertFails(a.ref('users/user-B/photo.png').getDownloadURL());
  await assertFails(a.ref('users/user-B/photo.png').putString('overwrite'));
});

test('Storage: admin custom claim may write admin/ and public/', async () => {
  const adminCtx = testEnv.authenticatedContext('admin', { admin: true });
  await assertSucceeds(
    adminCtx.storage().ref('admin/secrets.txt').putString('top-secret'),
  );
  await assertSucceeds(
    adminCtx.storage().ref('public/banner.png').putString('asset'),
  );
});