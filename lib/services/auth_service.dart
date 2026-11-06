import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:radhika/models/user_profile.dart';

class AuthService {
  // Resolved lazily: on the web build Firebase is only initialized when a
  // web app configuration is supplied at build time (see main.dart). Eagerly
  // touching FirebaseAuth.instance here would throw during provider
  // construction and take the whole app down before the login screen can
  // render.
  FirebaseAuth get _auth => FirebaseAuth.instance;

  // The web google_sign_in implementation asserts that a client ID is
  // configured as soon as the plugin is constructed. Build the plugin on
  // first use, and only when web has a client ID, so a plain web deployment
  // boots without an uncaught plugin error.
  static const String _webClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  bool get _googleSignInSupported => !kIsWeb || _webClientId.isNotEmpty;

  GoogleSignIn? _googleSignInInstance;

  GoogleSignIn get _googleSignIn => _googleSignInInstance ??=
      kIsWeb ? GoogleSignIn(clientId: _webClientId) : GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(
      String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // The account exists from this point on. A verification-email failure
    // (too-many-requests / network-request-failed) must not abort signup:
    // the app has no emailVerified gate, so retrying after this throw would
    // surface "email already in use" for an account the user just created.
    try {
      await credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint(
            'Verification email not sent after signup (code: ${e.code}); '
            'account ${credential.user?.uid} was created and is usable.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            'Verification email not sent after signup ($e); '
            'account ${credential.user?.uid} was created and is usable.');
      }
    }
    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!_googleSignInSupported) {
      throw UnsupportedError(
          'Google sign-in is not configured for this web deployment.');
    }
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    if (_googleSignInSupported) {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        // Clearing the Firebase session must not depend on a Google session
        // being present (for example on web, where Google sign-in may not be
        // configured).
        if (kDebugMode) debugPrint('Google sign-out skipped: $e');
      }
    }
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  bool isEmailVerified() {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  Future<void> refreshUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  UserProfile createProfileFromAuth(User user) {
    return UserProfile(
      id: user.uid,
      name: user.displayName ?? '',
      age: 25,
      averageCycleLength: 28,
      averagePeriodLength: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
