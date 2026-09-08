// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 6;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as ReminderType,
      enabled: fields[3] as bool,
      hoursBefore: fields[4] as int,
      hour: fields[5] as int?,
      minute: fields[6] as int?,
      daysOfWeek: (fields[7] as List).cast<int>(),
      createdAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.enabled)
      ..writeByte(4)
      ..write(obj.hoursBefore)
      ..writeByte(5)
      ..write(obj.hour)
      ..writeByte(6)
      ..write(obj.minute)
      ..writeByte(7)
      ..write(obj.daysOfWeek)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 7;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.periodReminder3Days;
      case 1:
        return ReminderType.periodReminder2Days;
      case 2:
        return ReminderType.periodReminder1Day;
      case 3:
        return ReminderType.periodReminderToday;
      case 4:
        return ReminderType.medication;
      case 5:
        return ReminderType.symptomLog;
      default:
        return ReminderType.periodReminder3Days;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.periodReminder3Days:
        writer.writeByte(0);
        break;
      case ReminderType.periodReminder2Days:
        writer.writeByte(1);
        break;
      case ReminderType.periodReminder1Day:
        writer.writeByte(2);
        break;
      case ReminderType.periodReminderToday:
        writer.writeByte(3);
        break;
      case ReminderType.medication:
        writer.writeByte(4);
        break;
      case ReminderType.symptomLog:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
