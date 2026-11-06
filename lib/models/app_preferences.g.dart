// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPreferencesAdapter extends TypeAdapter<AppPreferences> {
  @override
  final int typeId = 18;

  @override
  AppPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPreferences(
      id: fields[0] as String,
      languageCode: fields[1] as String,
      personalizationEnabled: fields[2] as bool,
      preferredTopics: (fields[3] as List?)?.cast<String>(),
      preferredContentFormats: (fields[4] as List?)?.cast<String>(),
      accessibilityFontSize: fields[5] as double,
      highContrastMode: fields[6] as bool,
      accessibilityFeatures: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppPreferences obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.languageCode)
      ..writeByte(2)
      ..write(obj.personalizationEnabled)
      ..writeByte(3)
      ..write(obj.preferredTopics)
      ..writeByte(4)
      ..write(obj.preferredContentFormats)
      ..writeByte(5)
      ..write(obj.accessibilityFontSize)
      ..writeByte(6)
      ..write(obj.highContrastMode)
      ..writeByte(7)
      ..write(obj.accessibilityFeatures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
