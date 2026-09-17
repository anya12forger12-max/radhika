import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Gatekeeping ads behind Google UMP (GDPR) consent.
///
/// Runs the consent flow once, deduplicates concurrent callers, and reuses
/// the cached result for all subsequent calls.
class AdConsentService {
  AdConsentService._();

  static final AdConsentService instance = AdConsentService._();

  Completer<bool>? _pending;
  bool _finished = false;
  bool _cachedResult = false;

  /// Ensures consent has been collected. Never throws.
  Future<bool> ensureConsent() async {
    if (_finished) {
      return _cachedResult;
    }
    final pending = _pending;
    if (pending != null) {
      return pending.future;
    }
    final completer = Completer<bool>();
    _pending = completer;
    try {
      final result = await _ensureConsent();
      _finished = true;
      _cachedResult = result;
      completer.complete(result);
    } catch (e, st) {
      debugPrint('AdConsentService: consent flow failed: $e\n$st');
      _finished = true;
      _cachedResult = true;
      completer.complete(true);
    } finally {
      _pending = null;
    }
    return completer.future;
  }

  Future<bool> _ensureConsent() async {
    if (kIsWeb) {
      return true;
    }
    if (!Platform.isAndroid && !Platform.isIOS) {
      return true;
    }

    await _updateConsentInfo();
    final status = await ConsentInformation.instance.getConsentStatus();
    if (status == ConsentStatus.required &&
        await ConsentInformation.instance.isConsentFormAvailable()) {
      final form = await _loadConsentForm();
      await _showConsentForm(form);
    }
    return ConsentInformation.instance.canRequestAds();
  }

  Future<void> _updateConsentInfo() async {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      completer.completeError,
    );
    return completer.future;
  }

  Future<ConsentForm> _loadConsentForm() async {
    final completer = Completer<ConsentForm>();
    ConsentForm.loadConsentForm(
      completer.complete,
      completer.completeError,
    );
    return completer.future;
  }

  Future<void> _showConsentForm(ConsentForm form) async {
    final completer = Completer<void>();
    form.show(
      (_) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );
    return completer.future;
  }
}