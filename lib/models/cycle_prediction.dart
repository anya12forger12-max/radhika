import 'package:hive/hive.dart';

part 'cycle_prediction.g.dart';

@HiveType(typeId: 5)
class CyclePrediction extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final DateTime predictedStartDate;
  @HiveField(3)
  final DateTime predictedEndDate;
  @HiveField(4)
  final DateTime? ovulationDate;
  @HiveField(5)
  final DateTime? fertileWindowStart;
  @HiveField(6)
  final DateTime? fertileWindowEnd;
  @HiveField(7)
  final double confidence;
  @HiveField(8)
  final int predictedCycleLength;
  @HiveField(9)
  final bool isDelayed;
  @HiveField(10)
  final DateTime createdAt;

  CyclePrediction({
    required this.id,
    required this.userId,
    required this.predictedStartDate,
    required this.predictedEndDate,
    this.ovulationDate,
    this.fertileWindowStart,
    this.fertileWindowEnd,
    this.confidence = 0.5,
    this.predictedCycleLength = 28,
    this.isDelayed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'predictedStartDate': predictedStartDate.millisecondsSinceEpoch,
      'predictedEndDate': predictedEndDate.millisecondsSinceEpoch,
      'ovulationDate': ovulationDate?.millisecondsSinceEpoch,
      'fertileWindowStart': fertileWindowStart?.millisecondsSinceEpoch,
      'fertileWindowEnd': fertileWindowEnd?.millisecondsSinceEpoch,
      'confidence': confidence,
      'predictedCycleLength': predictedCycleLength,
      'isDelayed': isDelayed,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CyclePrediction.fromMap(Map<String, dynamic> map, String id) {
    return CyclePrediction(
      id: id,
      userId: map['userId'] ?? '',
      predictedStartDate:
          DateTime.fromMillisecondsSinceEpoch(map['predictedStartDate']),
      predictedEndDate:
          DateTime.fromMillisecondsSinceEpoch(map['predictedEndDate']),
      ovulationDate: map['ovulationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ovulationDate'])
          : null,
      fertileWindowStart: map['fertileWindowStart'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fertileWindowStart'])
          : null,
      fertileWindowEnd: map['fertileWindowEnd'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fertileWindowEnd'])
          : null,
      confidence: (map['confidence'] ?? 0.5).toDouble(),
      predictedCycleLength: map['predictedCycleLength'] ?? 28,
      isDelayed: map['isDelayed'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }
}
