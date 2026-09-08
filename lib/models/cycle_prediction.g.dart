// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_prediction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CyclePredictionAdapter extends TypeAdapter<CyclePrediction> {
  @override
  final int typeId = 5;

  @override
  CyclePrediction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CyclePrediction(
      id: fields[0] as String,
      userId: fields[1] as String,
      predictedStartDate: fields[2] as DateTime,
      predictedEndDate: fields[3] as DateTime,
      ovulationDate: fields[4] as DateTime?,
      fertileWindowStart: fields[5] as DateTime?,
      fertileWindowEnd: fields[6] as DateTime?,
      confidence: fields[7] as double,
      predictedCycleLength: fields[8] as int,
      isDelayed: fields[9] as bool,
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CyclePrediction obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.predictedStartDate)
      ..writeByte(3)
      ..write(obj.predictedEndDate)
      ..writeByte(4)
      ..write(obj.ovulationDate)
      ..writeByte(5)
      ..write(obj.fertileWindowStart)
      ..writeByte(6)
      ..write(obj.fertileWindowEnd)
      ..writeByte(7)
      ..write(obj.confidence)
      ..writeByte(8)
      ..write(obj.predictedCycleLength)
      ..writeByte(9)
      ..write(obj.isDelayed)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CyclePredictionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
