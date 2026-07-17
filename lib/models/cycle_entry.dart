import 'package:hive/hive.dart';

part 'cycle_entry.g.dart';

@HiveType(typeId: 1)
class CycleEntry extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  DateTime? endDate;
  @HiveField(4)
  FlowIntensity flowIntensity;
  @HiveField(5)
  bool spotting;
  @HiveField(6)
  int painLevel;
  @HiveField(7)
  Mood mood;
  @HiveField(8)
  int energyLevel;
  @HiveField(9)
  int sleepHours;
  @HiveField(10)
  bool exercise;
  @HiveField(11)
  int waterIntake;
  @HiveField(12)
  List<Symptom> symptoms;
  @HiveField(13)
  String notes;
  @HiveField(14)
  DateTime createdAt;
  @HiveField(15)
  DateTime updatedAt;

  CycleEntry({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.flowIntensity = FlowIntensity.medium,
    this.spotting = false,
    this.painLevel = 0,
    this.mood = Mood.neutral,
    this.energyLevel = 3,
    this.sleepHours = 7,
    this.exercise = false,
    this.waterIntake = 4,
    this.symptoms = const [],
    this.notes = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  int get duration {
    if (endDate == null) return 0;
    return endDate!.difference(startDate).days + 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'flowIntensity': flowIntensity.index,
      'spotting': spotting,
      'painLevel': painLevel,
      'mood': mood.index,
      'energyLevel': energyLevel,
      'sleepHours': sleepHours,
      'exercise': exercise,
      'waterIntake': waterIntake,
      'symptoms': symptoms.map((s) => s.index).toList(),
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CycleEntry.fromMap(Map<String, dynamic> map, String id) {
    return CycleEntry(
      id: id,
      userId: map['userId'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'])
          : null,
      flowIntensity: FlowIntensity.values[map['flowIntensity'] ?? 1],
      spotting: map['spotting'] ?? false,
      painLevel: map['painLevel'] ?? 0,
      mood: Mood.values[map['mood'] ?? 2],
      energyLevel: map['energyLevel'] ?? 3,
      sleepHours: map['sleepHours'] ?? 7,
      exercise: map['exercise'] ?? false,
      waterIntake: map['waterIntake'] ?? 4,
      symptoms:
          (map['symptoms'] as List?)?.map((s) => Symptom.values[s]).toList() ??
              [],
      notes: map['notes'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  CycleEntry copyWith({
    DateTime? startDate,
    DateTime? endDate,
    FlowIntensity? flowIntensity,
    bool? spotting,
    int? painLevel,
    Mood? mood,
    int? energyLevel,
    int? sleepHours,
    bool? exercise,
    int? waterIntake,
    List<Symptom>? symptoms,
    String? notes,
  }) {
    return CycleEntry(
      id: id,
      userId: userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      spotting: spotting ?? this.spotting,
      painLevel: painLevel ?? this.painLevel,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      sleepHours: sleepHours ?? this.sleepHours,
      exercise: exercise ?? this.exercise,
      waterIntake: waterIntake ?? this.waterIntake,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

@HiveType(typeId: 2)
enum FlowIntensity {
  @HiveField(0)
  veryLight,
  @HiveField(1)
  light,
  @HiveField(2)
  medium,
  @HiveField(3)
  heavy,
  @HiveField(4)
  veryHeavy,
}

@HiveType(typeId: 3)
enum Mood {
  @HiveField(0)
  veryBad,
  @HiveField(1)
  bad,
  @HiveField(2)
  neutral,
  @HiveField(3)
  good,
  @HiveField(4)
  veryGood,
}

@HiveType(typeId: 4)
enum Symptom {
  @HiveField(0)
  headache,
  @HiveField(1)
  nausea,
  @HiveField(2)
  acne,
  @HiveField(3)
  moodSwings,
  @HiveField(4)
  anxiety,
  @HiveField(5)
  depression,
  @HiveField(6)
  fatigue,
  @HiveField(7)
  breastTenderness,
  @HiveField(8)
  backPain,
  @HiveField(9)
  cramps,
  @HiveField(10)
  bloating,
}
