import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Fallback user-facing message used when an error has no more specific,
/// safe mapping. Internal error details never reach the UI from this layer.
const String errorDefaultUserMessage = 'Something went wrong. Please try again.';

/// Central error-handling facade for the app: authorized diagnostics reporting
/// (debug log + Crashlytics) and safe user-facing message mapping.
class ErrorHandler {
  /// Reports an internal error for authorized diagnostics only: a debug log
  /// line plus Crashlytics capture. Never throws and never masks the original
  /// failure it wraps.
  void reportError(
    Object error, {
    String? context,
    StackTrace? stackTrace,
  }) {
    try {
      if (kDebugMode) {
        debugPrint(
            'AppError${context != null && context.isNotEmpty ? ' ($context)' : ''}: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      // Structured breadcrumb for authorized diagnostics before capture.
      FirebaseCrashlytics.instance.log(
        'AppError${context != null && context.isNotEmpty ? ' ($context)' : ''}: $error',
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    } catch (_) {
      // Diagnostic reporting must never mask the original failure.
    }
  }

  /// Maps an internal error to a safe user-facing message.
  ///
  /// Auth flows map Firebase error codes to user-safe copy via
  /// `mapAuthErrorCode` (see `lib/providers/auth_provider.dart`); this utility
  /// supplies the consistent fallback mapping for all other failure classes so
  /// no raw internal/technical error text reaches the UI.
  String userMessage(Object error, {String? fallback}) {
    return fallback ?? errorDefaultUserMessage;
  }
}

final errorHandler = ErrorHandler();
