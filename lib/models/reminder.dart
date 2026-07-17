import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 6)
class Reminder extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  ReminderType type;
  @HiveField(3)
  bool enabled;
  @HiveField(4)
  int hoursBefore;
  @HiveField(5)
  int? hour;
  @HiveField(6)
  int? minute;
  @HiveField(7)
  List<int> daysOfWeek;
  @HiveField(8)
  DateTime createdAt;

  Reminder({
    required this.id,
    required this.userId,
    required this.type,
    this.enabled = true,
    this.hoursBefore = 24,
    this.hour,
    this.minute,
    this.daysOfWeek = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type.index,
      'enabled': enabled,
      'hoursBefore': hoursBefore,
      'hour': hour,
      'minute': minute,
      'daysOfWeek': daysOfWeek,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map, String id) {
    return Reminder(
      id: id,
      userId: map['userId'] ?? '',
      type: ReminderType.values[map['type'] ?? 0],
      enabled: map['enabled'] ?? true,
      hoursBefore: map['hoursBefore'] ?? 24,
      hour: map['hour'],
      minute: map['minute'],
      daysOfWeek: List<int>.from(map['daysOfWeek'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Reminder copyWith({
    ReminderType? type,
    bool? enabled,
    int? hoursBefore,
    int? hour,
    int? minute,
    List<int>? daysOfWeek,
  }) {
    return Reminder(
      id: id,
      userId: userId,
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      hoursBefore: hoursBefore ?? this.hoursBefore,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      createdAt: createdAt,
    );
  }
}

@HiveType(typeId: 7)
enum ReminderType {
  @HiveField(0)
  periodReminder3Days,
  @HiveField(1)
  periodReminder2Days,
  @HiveField(2)
  periodReminder1Day,
  @HiveField(3)
  periodReminderToday,
  @HiveField(4)
  medication,
  @HiveField(5)
  symptomLog,
}
