import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:radhika/services/cycle_prediction_service.dart';
import 'package:radhika/services/storage_service.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

final cyclePredictionServiceProvider =
    Provider<CyclePredictionService>((ref) => CyclePredictionService());

class CycleState {
  final List<CycleEntry> cycleHistory;
  final CyclePrediction? currentPrediction;
  final bool isLoading;
  final String? error;
  final List<String> delaySuggestions;

  const CycleState({
    this.cycleHistory = const [],
    this.currentPrediction,
    this.isLoading = false,
    this.error,
    this.delaySuggestions = const [],
  });

  CycleState copyWith({
    List<CycleEntry>? cycleHistory,
    CyclePrediction? currentPrediction,
    bool? isLoading,
    String? error,
    List<String>? delaySuggestions,
  }) {
    return CycleState(
      cycleHistory: cycleHistory ?? this.cycleHistory,
      currentPrediction: currentPrediction ?? this.currentPrediction,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      delaySuggestions: delaySuggestions ?? this.delaySuggestions,
    );
  }
}

class CycleNotifier extends StateNotifier<CycleState> {
  final StorageService _storageService;
  final CyclePredictionService _predictionService;
  String? _userId;

  CycleNotifier(this._storageService, this._predictionService)
      : super(const CycleState());

  void setUserId(String userId) {
    _userId = userId;
    _loadCycles();
  }

  void _loadCycles() {
    if (_userId == null) return;
    final history = _storageService.getCycleEntries(_userId!);
    final prediction = _storageService.getLatestPrediction(_userId!);
    state = state.copyWith(
      cycleHistory: history,
      currentPrediction: prediction,
    );
  }

  Future<void> addCycleEntry({
    required DateTime startDate,
    DateTime? endDate,
    FlowIntensity flowIntensity = FlowIntensity.medium,
    bool spotting = false,
    int painLevel = 0,
    Mood mood = Mood.neutral,
    int energyLevel = 3,
    int sleepHours = 7,
    bool exercise = false,
    int waterIntake = 4,
    List<Symptom> symptoms = const [],
    String notes = '',
  }) async {
    if (_userId == null) return;

    final entry = CycleEntry(
      id: const Uuid().v4(),
      userId: _userId!,
      startDate: startDate,
      endDate: endDate,
      flowIntensity: flowIntensity,
      spotting: spotting,
      painLevel: painLevel,
      mood: mood,
      energyLevel: energyLevel,
      sleepHours: sleepHours,
      exercise: exercise,
      waterIntake: waterIntake,
      symptoms: symptoms,
      notes: notes,
    );

    await _storageService.saveCycleEntry(entry);
    _loadCycles();
    _updatePrediction();
  }

  Future<void> updateCycleEntry(String entryId, CycleEntry updatedEntry) async {
    await _storageService.saveCycleEntry(updatedEntry);
    _loadCycles();
    _updatePrediction();
  }

  Future<void> deleteCycleEntry(String entryId) async {
    await _storageService.deleteCycleEntry(entryId);
    _loadCycles();
    _updatePrediction();
  }

  Future<void> _updatePrediction() async {
    if (_userId == null) return;
    final profile = _storageService.getProfile(_userId!);
    if (profile == null) return;

    final prediction = _predictionService.predictNextCycle(
      userId: _userId!,
      cycleHistory: state.cycleHistory,
      averageCycleLength: profile.averageCycleLength,
      averagePeriodLength: profile.averagePeriodLength,
      lastPeriodStart: profile.lastPeriodStart,
    );

    await _storageService.savePrediction(prediction);

    final delaySuggestions = prediction.isDelayed
        ? _predictionService.generateDelayAnalysis(
            state.cycleHistory.take(5).toList())
        : <String>[];

    state = state.copyWith(
      currentPrediction: prediction,
      delaySuggestions: delaySuggestions,
    );
  }

  void refresh() {
    _loadCycles();
  }

  List<Map<String, dynamic>> get statistics =>
      _predictionService.getCycleStatistics(state.cycleHistory);

  Map<String, int> get symptomFrequency =>
      _predictionService.getSymptomFrequency(state.cycleHistory);

  CyclePrediction? get prediction => state.currentPrediction;
}

final cycleProvider =
    StateNotifierProvider<CycleNotifier, CycleState>((ref) {
  final storageService = ref.read(storageServiceProvider);
  final predictionService = ref.read(cyclePredictionServiceProvider);

  final notifier = CycleNotifier(storageService, predictionService);

  ref.listen(authProvider, (prev, next) {
    final user = next.user.value;
    if (user != null) {
      notifier.setUserId(user.uid);
    }
  });

  return notifier;
});
