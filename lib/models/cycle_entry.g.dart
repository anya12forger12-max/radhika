// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CycleEntryAdapter extends TypeAdapter<CycleEntry> {
  @override
  final int typeId = 1;

  @override
  CycleEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CycleEntry(
      id: fields[0] as String,
      userId: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime?,
      flowIntensity: fields[4] as FlowIntensity,
      spotting: fields[5] as bool,
      painLevel: fields[6] as int,
      mood: fields[7] as Mood,
      energyLevel: fields[8] as int,
      sleepHours: fields[9] as int,
      exercise: fields[10] as bool,
      waterIntake: fields[11] as int,
      symptoms: (fields[12] as List).cast<Symptom>(),
      notes: fields[13] as String,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CycleEntry obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.flowIntensity)
      ..writeByte(5)
      ..write(obj.spotting)
      ..writeByte(6)
      ..write(obj.painLevel)
      ..writeByte(7)
      ..write(obj.mood)
      ..writeByte(8)
      ..write(obj.energyLevel)
      ..writeByte(9)
      ..write(obj.sleepHours)
      ..writeByte(10)
      ..write(obj.exercise)
      ..writeByte(11)
      ..write(obj.waterIntake)
      ..writeByte(12)
      ..write(obj.symptoms)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlowIntensityAdapter extends TypeAdapter<FlowIntensity> {
  @override
  final int typeId = 2;

  @override
  FlowIntensity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FlowIntensity.veryLight;
      case 1:
        return FlowIntensity.light;
      case 2:
        return FlowIntensity.medium;
      case 3:
        return FlowIntensity.heavy;
      case 4:
        return FlowIntensity.veryHeavy;
      default:
        return FlowIntensity.veryLight;
    }
  }

  @override
  void write(BinaryWriter writer, FlowIntensity obj) {
    switch (obj) {
      case FlowIntensity.veryLight:
        writer.writeByte(0);
        break;
      case FlowIntensity.light:
        writer.writeByte(1);
        break;
      case FlowIntensity.medium:
        writer.writeByte(2);
        break;
      case FlowIntensity.heavy:
        writer.writeByte(3);
        break;
      case FlowIntensity.veryHeavy:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowIntensityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodAdapter extends TypeAdapter<Mood> {
  @override
  final int typeId = 3;

  @override
  Mood read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mood.veryBad;
      case 1:
        return Mood.bad;
      case 2:
        return Mood.neutral;
      case 3:
        return Mood.good;
      case 4:
        return Mood.veryGood;
      default:
        return Mood.veryBad;
    }
  }

  @override
  void write(BinaryWriter writer, Mood obj) {
    switch (obj) {
      case Mood.veryBad:
        writer.writeByte(0);
        break;
      case Mood.bad:
        writer.writeByte(1);
        break;
      case Mood.neutral:
        writer.writeByte(2);
        break;
      case Mood.good:
        writer.writeByte(3);
        break;
      case Mood.veryGood:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SymptomAdapter extends TypeAdapter<Symptom> {
  @override
  final int typeId = 4;

  @override
  Symptom read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Symptom.headache;
      case 1:
        return Symptom.nausea;
      case 2:
        return Symptom.acne;
      case 3:
        return Symptom.moodSwings;
      case 4:
        return Symptom.anxiety;
      case 5:
        return Symptom.depression;
      case 6:
        return Symptom.fatigue;
      case 7:
        return Symptom.breastTenderness;
      case 8:
        return Symptom.backPain;
      case 9:
        return Symptom.cramps;
      case 10:
        return Symptom.bloating;
      default:
        return Symptom.headache;
    }
  }

  @override
  void write(BinaryWriter writer, Symptom obj) {
    switch (obj) {
      case Symptom.headache:
        writer.writeByte(0);
        break;
      case Symptom.nausea:
        writer.writeByte(1);
        break;
      case Symptom.acne:
        writer.writeByte(2);
        break;
      case Symptom.moodSwings:
        writer.writeByte(3);
        break;
      case Symptom.anxiety:
        writer.writeByte(4);
        break;
      case Symptom.depression:
        writer.writeByte(5);
        break;
      case Symptom.fatigue:
        writer.writeByte(6);
        break;
      case Symptom.breastTenderness:
        writer.writeByte(7);
        break;
      case Symptom.backPain:
        writer.writeByte(8);
        break;
      case Symptom.cramps:
        writer.writeByte(9);
        break;
      case Symptom.bloating:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
