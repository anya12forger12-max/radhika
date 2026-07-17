import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/models/user_profile.dart';
import 'package:radhika/services/auth_service.dart';
import 'package:radhika/services/storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService.instance);

class AuthState {
  final AsyncValue<User?> user;
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user = const AsyncData(null),
    this.profile,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AsyncValue<User?>? user,
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user.hasValue && user.value != null;
  bool get needsPrivacyPolicy =>
      isAuthenticated &&
      (profile == null || !profile!.privacyPolicyAccepted);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final StorageService _storageService;

  AuthNotifier(this._authService, this._storageService)
      : super(const AuthState()) {
    _authService.authStateChanges.listen(_onAuthChange);
  }

  void _onAuthChange(User? user) {
    if (user != null) {
      final profile = _storageService.getProfile(user.uid);
      state = AuthState(
        user: AsyncData(user),
        profile: profile,
      );
    } else {
      state = const AuthState();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signInWithEmail(email, password);
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapFirebaseError(e.code),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> registerWithEmail(String email, String password,
      {String name = '', int age = 25}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential =
          await _authService.registerWithEmail(email, password);
      final user = credential.user!;
      final profile = UserProfile(
        id: user.uid,
        name: name,
        age: age,
        email: email,
      );
      await _storageService.saveProfile(profile);
      state = state.copyWith(isLoading: false, profile: profile);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapFirebaseError(e.code),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _authService.signInWithGoogle();
      final user = credential.user!;
      var profile = _storageService.getProfile(user.uid);
      if (profile == null) {
        profile = UserProfile(
          id: user.uid,
          name: user.displayName ?? '',
          age: 25,
          email: user.email ?? '',
        );
        await _storageService.saveProfile(profile);
      }
      state = state.copyWith(isLoading: false, profile: profile);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapFirebaseError(e.code),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapFirebaseError(e.code),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> acceptPrivacyPolicy() async {
    final user = _authService.currentUser;
    if (user == null) return;

    var profile = state.profile ?? UserProfile(id: user.uid);
    profile = profile.copyWith(
      privacyPolicyAccepted: true,
      privacyPolicyAcceptedVersion: '1.0.0',
      privacyPolicyAcceptedDate: DateTime.now(),
    );
    await _storageService.saveProfile(profile);
    state = state.copyWith(profile: profile);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthState();
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _storageService.clearUserData(user.uid);
        await _authService.deleteAccount();
      }
      state = const AuthState(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete account',
      );
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _storageService.saveProfile(profile);
    state = state.copyWith(profile: profile);
  }

  Future<void> refreshProfile() async {
    final user = _authService.currentUser;
    if (user != null) {
      final profile = _storageService.getProfile(user.uid);
      state = state.copyWith(profile: profile);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'weak-password':
        return 'Password is too weak';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return AuthNotifier(authService, storageService);
});
