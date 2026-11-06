import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/core/utils/error_handler.dart';
import 'package:radhika/data/models/secure_model_factory.dart';
import 'package:radhika/models/app_preferences.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:radhika/models/reminder.dart';
import 'package:radhika/models/user_profile.dart';

import 'package:radhika/providers/theme_provider.dart';

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService.instance);

class ReminderPreferences {
  final bool remind3DaysBefore;
  final bool remind2DaysBefore;
  final bool remind1DayBefore;
  final bool remindDayOf;
  final int hour;
  final int minute;

  const ReminderPreferences({
    this.remind3DaysBefore = false,
    this.remind2DaysBefore = false,
    this.remind1DayBefore = false,
    this.remindDayOf = false,
    this.hour = 9,
    this.minute = 0,
  });

  bool get anyEnabled =>
      remind3DaysBefore || remind2DaysBefore || remind1DayBefore || remindDayOf;

  ReminderPreferences copyWith({
    bool? remind3DaysBefore,
    bool? remind2DaysBefore,
    bool? remind1DayBefore,
    bool? remindDayOf,
    int? hour,
    int? minute,
  }) {
    return ReminderPreferences(
      remind3DaysBefore: remind3DaysBefore ?? this.remind3DaysBefore,
      remind2DaysBefore: remind2DaysBefore ?? this.remind2DaysBefore,
      remind1DayBefore: remind1DayBefore ?? this.remind1DayBefore,
      remindDayOf: remindDayOf ?? this.remindDayOf,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

class StorageService {
  static const String _profileBox = 'profile_box';
  static const String _cyclesBox = 'cycles_box';
  static const String _predictionsBox = 'predictions_box';
  static const String _remindersBox = 'reminders_box';
  static const String _settingsBox = 'settings_box';
  static const String _reminder3DaysKey = 'reminder_3_days_before';
  static const String _reminder2DaysKey = 'reminder_2_days_before';
  static const String _reminder1DayKey = 'reminder_1_day_before';
  static const String _reminderDayOfKey = 'reminder_day_of';
  static const String _reminderHourKey = 'reminder_hour';
  static const String _reminderMinuteKey = 'reminder_minute';

  // Encryption key material lives in the platform keystore, never in Hive.
  static const String _secureKeyName = 'hive_encryption_key';
  static const String _migrationFlagPrefix = 'hive_migrated_';
  static const String _encryptedSuffix = '_enc';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  HiveAesCipher? _cipher;

  static String _encryptedName(String base) => '$base$_encryptedSuffix';

  static StorageService? _instance;
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  StorageService._();

  Future<void> init() async {
    if (kIsWeb) {
      // path_provider has no web implementation. hive_flutter's web backend
      // stores boxes in IndexedDB and does not take a filesystem path.
      await Hive.initFlutter();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
    }

    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(CycleEntryAdapter());
    Hive.registerAdapter(FlowIntensityAdapter());
    Hive.registerAdapter(MoodAdapter());
    Hive.registerAdapter(SymptomAdapter());
    Hive.registerAdapter(CyclePredictionAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(ReminderTypeAdapter());

    final cipher = await _getOrCreateCipher();
    // The five boxes are independent once the cipher is available, so open
    // them concurrently rather than serially. This cuts startup I/O latency
    // proportionally to the slowest single box open instead of the sum.
    await Future.wait([
      _openBoxSafely<UserProfile>(_profileBox, cipher),
      _openBoxSafely<CycleEntry>(_cyclesBox, cipher),
      _openBoxSafely<CyclePrediction>(_predictionsBox, cipher),
      _openBoxSafely<Reminder>(_remindersBox, cipher),
      _openBoxSafely<String>(_settingsBox, cipher),
    ]);
  }

  Future<Box<T>> _openBoxSafely<T>(String base, HiveAesCipher cipher) async {
    final name = _encryptedName(base);
    try {
      await _migrateToEncrypted<T>(base, name, cipher);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to migrate plaintext box "$base": $e');
      }
    }

    return await Hive.openBox<T>(name, encryptionCipher: cipher);
  }

  Future<HiveAesCipher> _getOrCreateCipher() async {
    if (_cipher != null) return _cipher!;

    String? storedKey;
    try {
      storedKey = await _secureStorage.read(key: _secureKeyName);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to read Hive encryption key: $e');
      }
      rethrow;
    }

    Uint8List keyBytes;
    if (storedKey == null || storedKey.isEmpty) {
      keyBytes = Uint8List.fromList(Hive.generateSecureKey());
      final encoded = base64Encode(keyBytes);
      try {
        await _secureStorage.write(key: _secureKeyName, value: encoded);
        final verify = await _secureStorage.read(key: _secureKeyName);
        if (verify != encoded) {
          throw StateError(
              'Hive encryption key write could not be verified');
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Failed to persist Hive encryption key: $e');
        rethrow;
      }
      _cipher = HiveAesCipher(keyBytes);
      return _cipher!;
    }

    final decoded = base64Decode(storedKey);
    if (decoded.length != 32) {
      throw StateError(
          'Stored Hive encryption key has invalid length ${decoded.length}');
    }
    keyBytes = decoded;

    _cipher = HiveAesCipher(keyBytes);
    return _cipher!;
  }

  /// One-time migration of a legacy plaintext box to its encrypted
  /// counterpart. The migration marker prevents stale plaintext from being
  /// re-copied over newer encrypted data on subsequent launches.
  Future<void> _migrateToEncrypted<T>(
      String base, String encName, HiveAesCipher cipher) async {
    final flagKey = '$_migrationFlagPrefix$base';

    String? flag;
    try {
      flag = await _secureStorage.read(key: flagKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to read migration marker for "$base": $e');
      }
    }

    if (flag == '1') {
      await _deletePlaintextIfPresent(base);
      return;
    }

    if (!await Hive.boxExists(base)) {
      await _writeMigrationFlag(flagKey);
      return;
    }

    Box<T>? legacy;
    try {
      legacy = await Hive.openBox<T>(base);
      final entries = <dynamic, T>{};
      for (final key in legacy.keys) {
        final value = legacy.get(key);
        if (value != null) {
          entries[key] = value;
        }
      }
      await legacy.close();
      legacy = null;

      final target = await Hive.openBox<T>(encName, encryptionCipher: cipher);
      await target.putAll(entries);
      await target.flush();

      await _writeMigrationFlag(flagKey);
      await _deletePlaintextIfPresent(base);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to migrate Hive box "$base" to encrypted storage: $e');
      }
      if (legacy != null && legacy.isOpen) {
        await legacy.close();
      }
    }
  }

  Future<void> _deletePlaintextIfPresent(String base) async {
    try {
      if (await Hive.boxExists(base)) {
        await Hive.deleteBoxFromDisk(base);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to delete plaintext Hive box "$base": $e');
      }
    }
  }

  Future<void> _writeMigrationFlag(String flagKey) async {
    try {
      await _secureStorage.write(key: flagKey, value: '1');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to persist migration marker "$flagKey": $e');
      }
    }
  }

  Box<UserProfile> get _profile =>
      Hive.box<UserProfile>(_encryptedName(_profileBox));
  Box<CycleEntry> get _cycles =>
      Hive.box<CycleEntry>(_encryptedName(_cyclesBox));
  Box<CyclePrediction> get _predictions =>
      Hive.box<CyclePrediction>(_encryptedName(_predictionsBox));
  Box<Reminder> get _reminders =>
      Hive.box<Reminder>(_encryptedName(_remindersBox));
  Box<String> get _settings => Hive.box<String>(_encryptedName(_settingsBox));

  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _profile.put(profile.id, profile);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-save-profile');
      rethrow;
    }
  }

  UserProfile? getProfile(String userId) {
    return _profile.get(userId);
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _profile.delete(userId);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-delete-profile');
      rethrow;
    }
  }

  Future<void> saveCycleEntry(CycleEntry entry) async {
    try {
      await _cycles.put(entry.id, entry);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-save-cycle');
      rethrow;
    }
  }

  List<CycleEntry> getCycleEntries(String userId) {
    return _cycles.values
        .where((e) => e.userId == userId)
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Future<void> deleteCycleEntry(String entryId) async {
    try {
      await _cycles.delete(entryId);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-delete-cycle');
      rethrow;
    }
  }

  /// Reads a single cycle entry by id without requiring a user id.
  CycleEntry? getCycleEntry(String entryId) => _cycles.get(entryId);

  /// Toggles the favorite flag on an existing entry, persisting the result.
  Future<void> toggleFavorite(String entryId) async {
    final entry = _cycles.get(entryId);
    if (entry == null) return;
    try {
      await _cycles.put(entryId, entry.copyWith(isFavorite: !entry.isFavorite));
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-toggle-favorite');
      rethrow;
    }
  }

  Future<void> savePrediction(CyclePrediction prediction) async {
    try {
      await _predictions.put(prediction.id, prediction);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-save-prediction');
      rethrow;
    }
  }

  CyclePrediction? getLatestPrediction(String userId) {
    final predictions = _predictions.values
        .where((p) => p.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return predictions.isNotEmpty ? predictions.first : null;
  }

  List<CyclePrediction> getPredictions(String userId) {
    return _predictions.values
        .where((p) => p.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deletePrediction(String predictionId) async {
    try {
      await _predictions.delete(predictionId);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-delete-prediction');
      rethrow;
    }
  }

  Future<void> saveReminder(Reminder reminder) async {
    try {
      await _reminders.put(reminder.id, reminder);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-save-reminder');
      rethrow;
    }
  }

  List<Reminder> getReminders(String userId) {
    return _reminders.values.where((r) => r.userId == userId).toList();
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _reminders.delete(reminderId);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-delete-reminder');
      rethrow;
    }
  }

  Future<void> saveSetting(String key, String value) async {
    try {
      await _settings.put(key, value);
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-save-setting');
      rethrow;
    }
  }

  String? getSetting(String key) {
    return _settings.get(key);
  }

  /// Optional, user-scoped personalization preferences (enabled flag +
  /// voluntarily selected interests). Stored as a JSON string in the settings
  /// box; absent value means "enabled with no explicit interests" (defaults).
  Future<void> savePersonalizationPreferences(
    String userId, {
    required bool enabled,
    required List<String> interests,
  }) async {
    // Privacy: persist only normalized, allowlisted interests (data
    // minimization). Unrecognized values are dropped before storage.
    final normalized = interests
        .map((i) => i.trim().toLowerCase())
        .where((i) => i.isNotEmpty)
        .where((i) =>
            AppConstants.allowedPersonalizationInterests
                .any((token) => i.contains(token)))
        .toSet()
        .toList();
    await _settings.put(
      '${userId}_personalization',
      jsonEncode({
        'enabled': enabled,
        'interests': normalized,
      }),
    );
  }

  Map<String, dynamic>? getPersonalizationPreferences(String userId) {
    final raw = _settings.get('${userId}_personalization');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        errorHandler.reportError(
          StateError(
              'Unexpected personalization payload type ${decoded.runtimeType}'),
          context: 'storage-personalization-read',
        );
        return null;
      }
      final interests = ((decoded['interests'] as List?) ?? const [])
          .whereType<String>()
          .map((i) => i.trim().toLowerCase())
          .where((i) => i.isNotEmpty)
          .where((i) =>
              AppConstants.allowedPersonalizationInterests
                  .any((token) => i.contains(token)))
          .toSet()
          .toList();
      return {
        'enabled': decoded['enabled'] == true,
        'interests': interests,
      };
    } catch (e) {
      errorHandler.reportError(e, context: 'storage-personalization-read');
      return null;
    }
  }

  Future<void> clearPersonalizationPreferences(String userId) async {
    await _settings.delete('${userId}_personalization');
  }

  /// Reminder preferences are scoped per account (`userId`) so that two users
  /// sharing a device never inherit each other's reminder settings.
  Future<void> saveReminderPreferences(
      String userId, ReminderPreferences prefs) async {
    await _settings.put('${userId}_$_reminder3DaysKey',
        '${prefs.remind3DaysBefore}');
    await _settings.put('${userId}_$_reminder2DaysKey',
        '${prefs.remind2DaysBefore}');
    await _settings.put('${userId}_$_reminder1DayKey',
        '${prefs.remind1DayBefore}');
    await _settings.put('${userId}_$_reminderDayOfKey',
        '${prefs.remindDayOf}');
    await _settings.put('${userId}_$_reminderHourKey', '${prefs.hour}');
    await _settings.put('${userId}_$_reminderMinuteKey', '${prefs.minute}');
  }

  ReminderPreferences getReminderPreferences(String userId) {
    bool readBool(String key) {
      final value = _settings.get('${userId}_$key');
      return value == 'true';
    }

    final hourStr = _settings.get('${userId}_$_reminderHourKey');
    final minuteStr = _settings.get('${userId}_$_reminderMinuteKey');
    return ReminderPreferences(
      remind3DaysBefore: readBool(_reminder3DaysKey),
      remind2DaysBefore: readBool(_reminder2DaysKey),
      remind1DayBefore: readBool(_reminder1DayKey),
      remindDayOf: readBool(_reminderDayOfKey),
      hour: hourStr != null ? int.tryParse(hourStr) ?? 9 : 9,
      minute: minuteStr != null ? int.tryParse(minuteStr) ?? 0 : 0,
    );
  }

  /// User preference management
  AppPreferences getAppPreferences(String userId) {
    final box = Hive.box<AppPreferences>('app_preferences_encrypted');
    return box.get(userId) ?? AppPreferences(id: userId);
  }

  /// User preference management
  Future<void> saveAppPreferences(String userId, AppPreferences preferences) async {
    final box = Hive.box<AppPreferences>('app_preferences_encrypted');
    await box.put(userId, preferences);
  }

  Future<void> clearUserData(String userId) async {
    await _profile.delete(userId);
    await _settings.delete('${userId}_personalization');
  }

  Future<String> exportData(String userId) async {
    final profile = getProfile(userId);
    final cycles = getCycleEntries(userId);
    final predictions = getPredictions(userId);
    final reminders = getReminders(userId);
    final data = {
      'profile': profile?.toMap(),
      'cycles': cycles.map((c) => c.toMap()).toList(),
      'predictions': predictions.map((p) => p.toMap()).toList(),
      'reminders': reminders.map((r) => r.toMap()).toList(),
      'reminderPreferences': {
        'remind3DaysBefore': getReminderPreferences(userId).remind3DaysBefore,
        'remind2DaysBefore': getReminderPreferences(userId).remind2DaysBefore,
        'remind1DayBefore': getReminderPreferences(userId).remind1DayBefore,
        'remindDayOf': getReminderPreferences(userId).remindDayOf,
      },
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': AppConstants.appVersion,
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> importData(String userId, String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        if (kDebugMode) {
          debugPrint(
              'Failed to import data: unexpected top-level type ${decoded.runtimeType}');
        }
        return;
      }
      final data = decoded;

      // Critical deserialization boundary: validate any type indicator present
      // in the payload against the strict allowlist before constructing models.
      // Unknown markers are rejected (logged + DeserializationSecurityException)
      // rather than silently defaulted.
      final topLevelType = data['type'] ?? data['type_indicator'];
      if (topLevelType != null) {
        try {
          validateAndResolveType(topLevelType as String?);
        } catch (e) {
          if (kDebugMode) debugPrint('Failed to import data: $e');
          return;
        }
      }

      final profileData = data['profile'];
      if (profileData is Map<String, dynamic>) {
        try {
          final profileType = profileData['type'] ?? profileData['type_indicator'];
          if (profileType != null) {
            final resolved = validateAndResolveType(profileType as String?);
            if (resolved != AuthorizedModelType.userProfile) {
              throw const DeserializationSecurityException(
                  'Unexpected model type for profile payload');
            }
          }
          final profile = UserProfile.fromMap(profileData, userId);
          await saveProfile(profile);
        } on DeserializationSecurityException catch (e) {
          if (kDebugMode) {
            debugPrint('Security violation importing profile: $e');
          }
        } catch (e) {
          if (kDebugMode) debugPrint('Failed to import profile: $e');
        }
      }

      final cyclesData = data['cycles'];
      if (cyclesData is List) {
        for (final cycleMap in cyclesData) {
          if (cycleMap is! Map<String, dynamic>) {
            if (kDebugMode) {
              debugPrint(
                  'Skipping cycle entry with unexpected type ${cycleMap.runtimeType}');
            }
            continue;
          }
          try {
            final cycleType = cycleMap['type'] ?? cycleMap['type_indicator'];
            if (cycleType != null) {
              final resolved = validateAndResolveType(cycleType as String?);
              if (resolved != AuthorizedModelType.cycleEntry) {
                throw const DeserializationSecurityException(
                    'Unexpected model type for cycle payload');
              }
            }
            // fromMap already applies bounds-checked enum resolution
            // (flowIntensity, mood, symptoms) which fails closed on tampered
            // indices.
            final cycle = CycleEntry.fromMap(cycleMap, '');
            final importCycle = CycleEntry(
              id: cycle.id,
              userId: userId,
              startDate: cycle.startDate,
              endDate: cycle.endDate,
              flowIntensity: cycle.flowIntensity,
              spotting: cycle.spotting,
              painLevel: cycle.painLevel,
              mood: cycle.mood,
              energyLevel: cycle.energyLevel,
              sleepHours: cycle.sleepHours,
              exercise: cycle.exercise,
              waterIntake: cycle.waterIntake,
              symptoms: cycle.symptoms,
              notes: cycle.notes,
              isSymptomOnly: cycle.isSymptomOnly,
              createdAt: cycle.createdAt,
              updatedAt: cycle.updatedAt,
            );
            await saveCycleEntry(importCycle);
          } on DeserializationSecurityException catch (e) {
            if (kDebugMode) {
              debugPrint('Security violation importing cycle entry: $e');
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Failed to import cycle entry: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to import data: $e');
    }
  }
}

class AppPreferencesConfig {
  final ThemeModeSetting themeMode;
  final double fontSize;

  const AppPreferencesConfig({
    required this.themeMode,
    required this.fontSize,
  });
}
