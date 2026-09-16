import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:radhika/models/reminder.dart';
import 'package:radhika/models/user_profile.dart';

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService.instance);

class ReminderPreferences {
  final bool remind3DaysBefore;
  final bool remind2DaysBefore;
  final bool remindDayOf;

  const ReminderPreferences({
    this.remind3DaysBefore = false,
    this.remind2DaysBefore = false,
    this.remindDayOf = false,
  });

  bool get anyEnabled => remind3DaysBefore || remind2DaysBefore || remindDayOf;

  ReminderPreferences copyWith({
    bool? remind3DaysBefore,
    bool? remind2DaysBefore,
    bool? remindDayOf,
  }) {
    return ReminderPreferences(
      remind3DaysBefore: remind3DaysBefore ?? this.remind3DaysBefore,
      remind2DaysBefore: remind2DaysBefore ?? this.remind2DaysBefore,
      remindDayOf: remindDayOf ?? this.remindDayOf,
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
  static const String _reminderDayOfKey = 'reminder_day_of';

  static StorageService? _instance;
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  StorageService._();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(CycleEntryAdapter());
    Hive.registerAdapter(FlowIntensityAdapter());
    Hive.registerAdapter(MoodAdapter());
    Hive.registerAdapter(SymptomAdapter());
    Hive.registerAdapter(CyclePredictionAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(ReminderTypeAdapter());

    await _openBoxSafely<UserProfile>(_profileBox);
    await _openBoxSafely<CycleEntry>(_cyclesBox);
    await _openBoxSafely<CyclePrediction>(_predictionsBox);
    await _openBoxSafely<Reminder>(_remindersBox);
    await _openBoxSafely<String>(_settingsBox);
  }

  Future<Box<T>> _openBoxSafely<T>(String name) async {
    try {
      return await Hive.openBox<T>(name);
    } catch (e) {
      debugPrint('Failed to open Hive box "$name": $e');
      try {
        await Hive.deleteBoxFromDisk(name);
      } catch (deleteError) {
        debugPrint('Failed to delete corrupt Hive box "$name": $deleteError');
      }
      try {
        return await Hive.openBox<T>(name);
      } catch (retryError) {
        debugPrint(
            'Failed to reopen Hive box "$name" after recovery: $retryError');
        return Hive.openBox<T>(name, bytes: Uint8List(0));
      }
    }
  }

  Box<UserProfile> get _profile => Hive.box<UserProfile>(_profileBox);
  Box<CycleEntry> get _cycles => Hive.box<CycleEntry>(_cyclesBox);
  Box<CyclePrediction> get _predictions =>
      Hive.box<CyclePrediction>(_predictionsBox);
  Box<Reminder> get _reminders => Hive.box<Reminder>(_remindersBox);
  Box<String> get _settings => Hive.box<String>(_settingsBox);

  Future<void> saveProfile(UserProfile profile) async {
    await _profile.put(profile.id, profile);
  }

  UserProfile? getProfile(String userId) {
    return _profile.get(userId);
  }

  Future<void> deleteProfile(String userId) async {
    await _profile.delete(userId);
  }

  Future<void> saveCycleEntry(CycleEntry entry) async {
    await _cycles.put(entry.id, entry);
  }

  List<CycleEntry> getCycleEntries(String userId) {
    return _cycles.values
        .where((e) => e.userId == userId)
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Future<void> deleteCycleEntry(String entryId) async {
    await _cycles.delete(entryId);
  }

  Future<void> savePrediction(CyclePrediction prediction) async {
    await _predictions.put(prediction.id, prediction);
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
    await _predictions.delete(predictionId);
  }

  Future<void> saveReminder(Reminder reminder) async {
    await _reminders.put(reminder.id, reminder);
  }

  List<Reminder> getReminders(String userId) {
    return _reminders.values.where((r) => r.userId == userId).toList();
  }

  Future<void> deleteReminder(String reminderId) async {
    await _reminders.delete(reminderId);
  }

  Future<void> saveSetting(String key, String value) async {
    await _settings.put(key, value);
  }

  String? getSetting(String key) {
    return _settings.get(key);
  }

  Future<void> saveReminderPreferences(ReminderPreferences prefs) async {
    await _settings.put(_reminder3DaysKey, '${prefs.remind3DaysBefore}');
    await _settings.put(_reminder2DaysKey, '${prefs.remind2DaysBefore}');
    await _settings.put(_reminderDayOfKey, '${prefs.remindDayOf}');
  }

  ReminderPreferences getReminderPreferences() {
    bool readBool(String key) {
      final value = _settings.get(key);
      return value == 'true';
    }

    return ReminderPreferences(
      remind3DaysBefore: readBool(_reminder3DaysKey),
      remind2DaysBefore: readBool(_reminder2DaysKey),
      remindDayOf: readBool(_reminderDayOfKey),
    );
  }

  Future<void> clearUserData(String userId) async {
    final cycles = _cycles.values.where((c) => c.userId == userId).toList();
    for (final cycle in cycles) {
      await _cycles.delete(cycle.id);
    }
    final predictions =
        _predictions.values.where((p) => p.userId == userId).toList();
    for (final prediction in predictions) {
      await _predictions.delete(prediction.id);
    }
    final reminders =
        _reminders.values.where((r) => r.userId == userId).toList();
    for (final reminder in reminders) {
      await _reminders.delete(reminder.id);
    }
    await _profile.delete(userId);
  }

  Future<String> exportData(String userId) async {
    final profile = getProfile(userId);
    final cycles = getCycleEntries(userId);
    final data = {
      'profile': profile?.toMap(),
      'cycles': cycles.map((c) => c.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> importData(String userId, String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        debugPrint(
            'Failed to import data: unexpected top-level type ${decoded.runtimeType}');
        return;
      }
      final data = decoded;

      final profileData = data['profile'];
      if (profileData is Map<String, dynamic>) {
        try {
          final profile = UserProfile.fromMap(profileData, userId);
          await saveProfile(profile);
        } catch (e) {
          debugPrint('Failed to import profile: $e');
        }
      }

      final cyclesData = data['cycles'];
      if (cyclesData is List) {
        for (final cycleMap in cyclesData) {
          if (cycleMap is! Map<String, dynamic>) {
            debugPrint(
                'Skipping cycle entry with unexpected type ${cycleMap.runtimeType}');
            continue;
          }
          try {
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
          } catch (e) {
            debugPrint('Failed to import cycle entry: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to import data: $e');
    }
  }

  Future<void> clearAll() async {
    await _profile.clear();
    await _cycles.clear();
    await _predictions.clear();
    await _reminders.clear();
    await _settings.clear();
  }
}
