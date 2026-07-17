import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:uuid/uuid.dart';

class CyclePredictionService {
  final _uuid = const Uuid();

  CyclePrediction predictNextCycle({
    required String userId,
    required List<CycleEntry> cycleHistory,
    required int averageCycleLength,
    required int averagePeriodLength,
    required DateTime? lastPeriodStart,
  }) {
    if (lastPeriodStart == null) {
      return CyclePrediction(
        id: _uuid.v4(),
        userId: userId,
        predictedStartDate: DateTime.now(),
        predictedEndDate:
            DateTime.now().add(Duration(days: averagePeriodLength)),
        predictedCycleLength: averageCycleLength,
        createdAt: DateTime.now(),
      );
    }

    final predictedStart =
        lastPeriodStart.add(Duration(days: averageCycleLength));
    final predictedEnd =
        predictedStart.add(Duration(days: averagePeriodLength));
    final ovulationDate =
        predictedStart.subtract(Duration(days: AppConstants.ovulationDayOffset));
    final fertileStart =
        predictedStart.subtract(Duration(days: AppConstants.fertileWindowStart));
    final fertileEnd =
        predictedStart.subtract(Duration(days: AppConstants.fertileWindowEnd));

    final confidence = _calculateConfidence(cycleHistory, averageCycleLength);
    final isDelayed = predictedStart.isBefore(DateTime.now()) &&
        !_hasActivePeriod(cycleHistory);

    return CyclePrediction(
      id: _uuid.v4(),
      userId: userId,
      predictedStartDate: predictedStart,
      predictedEndDate: predictedEnd,
      ovulationDate: ovulationDate,
      fertileWindowStart: fertileStart,
      fertileWindowEnd: fertileEnd,
      confidence: confidence,
      predictedCycleLength: averageCycleLength,
      isDelayed: isDelayed,
      createdAt: DateTime.now(),
    );
  }

  double _calculateConfidence(
      List<CycleEntry> history, int averageCycleLength) {
    if (history.length < 2) return 0.3;
    if (history.length < 4) return 0.5;
    if (history.length < 6) return 0.7;

    double variance = 0;
    for (int i = 1; i < history.length; i++) {
      final diff = history[i - 1]
              .startDate
              .difference(history[i].startDate)
              .abs()
              .inDays -
          averageCycleLength;
      variance += diff * diff;
    }
    variance /= history.length - 1;
    final stdDev = variance;

    if (stdDev <= 2) return 0.9;
    if (stdDev <= 4) return 0.8;
    if (stdDev <= 6) return 0.7;
    return 0.6;
  }

  bool _hasActivePeriod(List<CycleEntry> cycleHistory) {
    final now = DateTime.now();
    return cycleHistory.any((entry) {
      if (entry.endDate == null) return false;
      return entry.startDate.isBefore(now) && entry.endDate!.isAfter(now);
    });
  }

  int calculateAverageCycleLength(List<CycleEntry> cycleHistory) {
    if (cycleHistory.length < 2) return AppConstants.defaultCycleLength;

    final sorted = List<CycleEntry>.from(cycleHistory)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    int totalDays = 0;
    int count = 0;
    for (int i = 1; i < sorted.length; i++) {
      final days = sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
      if (days >= AppConstants.minCycleLength &&
          days <= AppConstants.maxCycleLength) {
        totalDays += days;
        count++;
      }
    }

    if (count == 0) return AppConstants.defaultCycleLength;
    return (totalDays / count).round();
  }

  int calculateAveragePeriodLength(List<CycleEntry> cycleHistory) {
    final completed = cycleHistory.where((e) => e.endDate != null).toList();
    if (completed.isEmpty) return AppConstants.defaultPeriodLength;

    int total = 0;
    for (final entry in completed) {
      total += entry.duration;
    }
    return (total / completed.length).round();
  }

  List<Map<String, dynamic>> getCycleStatistics(
      List<CycleEntry> cycleHistory) {
    final completed = cycleHistory.where((e) => e.endDate != null).toList();
    if (completed.isEmpty) return [];

    final sorted = List<CycleEntry>.from(completed)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final cycleLengths = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      cycleLengths
          .add(sorted[i].startDate.difference(sorted[i - 1].startDate).inDays);
    }

    final avgCycle = cycleLengths.isNotEmpty
        ? cycleLengths.reduce((a, b) => a + b) ~/ cycleLengths.length
        : AppConstants.defaultCycleLength;

    final avgPeriod =
        completed.map((e) => e.duration).reduce((a, b) => a + b) ~/
            completed.length;

    final avgPain = completed
            .map((e) => e.painLevel)
            .reduce((a, b) => a + b) ~/
        completed.length;

    return [
      {'label': 'Average Cycle', 'value': '$avgCycle days'},
      {'label': 'Average Period', 'value': '$avgPeriod days'},
      {'label': 'Cycles Logged', 'value': '${completed.length}'},
      {'label': 'Avg Pain Level', 'value': '$avgPain/5'},
    ];
  }

  Map<String, int> getSymptomFrequency(List<CycleEntry> cycleHistory) {
    final frequency = <String, int>{};
    for (final entry in cycleHistory) {
      for (final symptom in entry.symptoms) {
        final name = symptom.name;
        frequency[name] = (frequency[name] ?? 0) + 1;
      }
    }
    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final e in sorted) e.key: e.value};
  }

  List<String> generateDelayAnalysis(List<CycleEntry> recentEntries) {
    final suggestions = <String>[];
    final recent = recentEntries.take(3).toList();

    if (recent.isNotEmpty) {
      final avgSleep =
          recent.map((e) => e.sleepHours).reduce((a, b) => a + b) ~/
              recent.length;
      if (avgSleep < 6) {
        suggestions.add(
            'Your logged sleep averages $avgSleep hours. Prioritize 7-9 hours of quality sleep.');
      }

      final exerciseDays = recent.where((e) => e.exercise).length;
      if (exerciseDays == 0) {
        suggestions.add(
            'Regular moderate exercise may help regulate your cycle. Consider gentle activities like walking or yoga.');
      }

      final avgWater =
          recent.map((e) => e.waterIntake).reduce((a, b) => a + b) ~/
              recent.length;
      if (avgWater < 4) {
        suggestions.add(
            'Stay hydrated. Aim for 6-8 glasses of water daily.');
      }

      final avgPain =
          recent.map((e) => e.painLevel).reduce((a, b) => a + b) ~/
              recent.length;
      if (avgPain > 3) {
        suggestions.add(
            'You\'ve been logging elevated pain levels. Consider heat therapy, gentle stretching, or consulting a healthcare provider.');
      }
    }

    suggestions.addAll([
      'Manage stress through relaxation techniques, meditation, or deep breathing.',
      'Maintain a balanced diet rich in iron, vitamins, and minerals.',
      'Avoid over-exercising, which can sometimes affect cycle regularity.',
      'Monitor your next few cycles to see if this pattern continues.',
    ]);

    return suggestions;
  }
}
