// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      height: fields[3] as double?,
      weight: fields[4] as double?,
      averageCycleLength: fields[5] as int,
      averagePeriodLength: fields[6] as int,
      lastPeriodStart: fields[7] as DateTime?,
      isPregnant: fields[8] as bool,
      isMenopause: fields[9] as bool,
      medicalConditions: (fields[10] as List).cast<String>(),
      medications: (fields[11] as List).cast<String>(),
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
      privacyPolicyAccepted: (fields[14] as bool?) ?? false,
      privacyPolicyAcceptedVersion: fields[15] as String?,
      privacyPolicyAcceptedDate: fields[16] as DateTime?,
      email: (fields[17] as String?) ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.averageCycleLength)
      ..writeByte(6)
      ..write(obj.averagePeriodLength)
      ..writeByte(7)
      ..write(obj.lastPeriodStart)
      ..writeByte(8)
      ..write(obj.isPregnant)
      ..writeByte(9)
      ..write(obj.isMenopause)
      ..writeByte(10)
      ..write(obj.medicalConditions)
      ..writeByte(11)
      ..write(obj.medications)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.privacyPolicyAccepted)
      ..writeByte(15)
      ..write(obj.privacyPolicyAcceptedVersion)
      ..writeByte(16)
      ..write(obj.privacyPolicyAcceptedDate)
      ..writeByte(17)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
