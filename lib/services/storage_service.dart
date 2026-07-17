import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:radhika/models/reminder.dart';
import 'package:radhika/models/user_profile.dart';

class StorageService {
  static const String _profileBox = 'profile_box';
  static const String _cyclesBox = 'cycles_box';
  static const String _predictionsBox = 'predictions_box';
  static const String _remindersBox = 'reminders_box';
  static const String _settingsBox = 'settings_box';

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

    await Hive.openBox<UserProfile>(_profileBox);
    await Hive.openBox<CycleEntry>(_cyclesBox);
    await Hive.openBox<CyclePrediction>(_predictionsBox);
    await Hive.openBox<Reminder>(_remindersBox);
    await Hive.openBox<String>(_settingsBox);
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
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    if (data['profile'] != null) {
      final profile = UserProfile.fromMap(
          data['profile'] as Map<String, dynamic>, userId);
      await saveProfile(profile);
    }
    if (data['cycles'] != null) {
      for (final cycleMap in data['cycles'] as List) {
        final cycle =
            CycleEntry.fromMap(cycleMap as Map<String, dynamic>, '');
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
          createdAt: cycle.createdAt,
          updatedAt: cycle.updatedAt,
        );
        await saveCycleEntry(importCycle);
      }
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
