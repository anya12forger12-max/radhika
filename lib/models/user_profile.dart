import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int age;
  @HiveField(3)
  double? height;
  @HiveField(4)
  double? weight;
  @HiveField(5)
  int averageCycleLength;
  @HiveField(6)
  int averagePeriodLength;
  @HiveField(7)
  DateTime? lastPeriodStart;
  @HiveField(8)
  bool isPregnant;
  @HiveField(9)
  bool isMenopause;
  @HiveField(10)
  List<String> medicalConditions;
  @HiveField(11)
  List<String> medications;
  @HiveField(12)
  DateTime createdAt;
  @HiveField(13)
  DateTime updatedAt;
  @HiveField(14)
  bool privacyPolicyAccepted;
  @HiveField(15)
  String? privacyPolicyAcceptedVersion;
  @HiveField(16)
  DateTime? privacyPolicyAcceptedDate;
  @HiveField(17)
  String email;

  UserProfile({
    required this.id,
    this.name = '',
    this.age = 25,
    this.height,
    this.weight,
    this.averageCycleLength = 28,
    this.averagePeriodLength = 5,
    this.lastPeriodStart,
    this.isPregnant = false,
    this.isMenopause = false,
    this.medicalConditions = const [],
    this.medications = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.privacyPolicyAccepted = false,
    this.privacyPolicyAcceptedVersion,
    this.privacyPolicyAcceptedDate,
    this.email = '',
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
      'lastPeriodStart': lastPeriodStart?.millisecondsSinceEpoch,
      'isPregnant': isPregnant,
      'isMenopause': isMenopause,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'privacyPolicyAccepted': privacyPolicyAccepted,
      'privacyPolicyAcceptedVersion': privacyPolicyAcceptedVersion,
      'privacyPolicyAcceptedDate':
          privacyPolicyAcceptedDate?.millisecondsSinceEpoch,
      'email': email,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      age: map['age'] ?? 25,
      height: map['height'],
      weight: map['weight'],
      averageCycleLength: map['averageCycleLength'] ?? 28,
      averagePeriodLength: map['averagePeriodLength'] ?? 5,
      lastPeriodStart: map['lastPeriodStart'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastPeriodStart'])
          : null,
      isPregnant: map['isPregnant'] ?? false,
      isMenopause: map['isMenopause'] ?? false,
      medicalConditions: List<String>.from(map['medicalConditions'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
      privacyPolicyAccepted: map['privacyPolicyAccepted'] ?? false,
      privacyPolicyAcceptedVersion: map['privacyPolicyAcceptedVersion'],
      privacyPolicyAcceptedDate: map['privacyPolicyAcceptedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['privacyPolicyAcceptedDate'])
          : null,
      email: map['email'] ?? '',
    );
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? height,
    double? weight,
    int? averageCycleLength,
    int? averagePeriodLength,
    DateTime? lastPeriodStart,
    bool? isPregnant,
    bool? isMenopause,
    List<String>? medicalConditions,
    List<String>? medications,
    bool? privacyPolicyAccepted,
    String? privacyPolicyAcceptedVersion,
    DateTime? privacyPolicyAcceptedDate,
    String? email,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      averagePeriodLength: averagePeriodLength ?? this.averagePeriodLength,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
      isPregnant: isPregnant ?? this.isPregnant,
      isMenopause: isMenopause ?? this.isMenopause,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      medications: medications ?? this.medications,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      privacyPolicyAccepted:
          privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      privacyPolicyAcceptedVersion:
          privacyPolicyAcceptedVersion ?? this.privacyPolicyAcceptedVersion,
      privacyPolicyAcceptedDate:
          privacyPolicyAcceptedDate ?? this.privacyPolicyAcceptedDate,
      email: email ?? this.email,
    );
  }
}
