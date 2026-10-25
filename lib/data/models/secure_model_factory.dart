// Centralized, allowlisted deserialization factory.
//
// This module is the single choke point for turning serialized payloads
// (backups, imports, locally stored JSON) back into domain model instances.
// It deliberately avoids any runtime reflection: every model type that may be
// instantiated is enumerated in [AuthorizedModelType] and resolved through an
// explicit [switch], and unknown type markers are rejected (logged + thrown)
// rather than silently defaulted. Index-based enum deserialization is guarded
// by [safeEnumFromIndex] / [safeEnumFromIndexOrThrow], which fail closed on
// tampered or out-of-range indices.
import 'package:flutter/foundation.dart';

import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:radhika/models/reminder.dart';
import 'package:radhika/models/user_profile.dart';

/// Thrown when a deserialization payload attempts to use an unauthorized or
/// unknown model type marker, or an out-of-range enum index.
class DeserializationSecurityException implements Exception {
  final String message;

  const DeserializationSecurityException(this.message);

  @override
  String toString() => 'DeserializationSecurityException: $message';
}

/// Allowlisted model types that may be instantiated from serialized payloads.
/// Any type not present here is, by definition, unauthorized.
enum AuthorizedModelType {
  userProfile,
  cycleEntry,
  cyclePrediction,
  reminder,
}

/// Maps a raw `type_indicator` string to an [AuthorizedModelType].
/// Only entries present in this map are permitted; everything else is a
/// security violation.
const Map<String, AuthorizedModelType> _typeAllowlist =
    <String, AuthorizedModelType>{
  'userProfile': AuthorizedModelType.userProfile,
  'cycleEntry': AuthorizedModelType.cycleEntry,
  'cyclePrediction': AuthorizedModelType.cyclePrediction,
  'reminder': AuthorizedModelType.reminder,
};

/// Validates and resolves a raw type marker into an allowlisted enum value.
///
/// Returns the resolved [AuthorizedModelType] on success. On any unknown or
/// missing marker, logs via [debugPrint] and throws
/// [DeserializationSecurityException] (fail closed). Never silently defaults.
AuthorizedModelType validateAndResolveType(String? typeIndicator) {
  if (typeIndicator == null || typeIndicator.isEmpty) {
    debugPrint('Deserialization security violation: missing type_indicator');
    throw const DeserializationSecurityException(
        'Missing type_indicator in deserialization payload');
  }
  final resolved = _typeAllowlist[typeIndicator];
  if (resolved == null) {
    debugPrint(
        'Deserialization security violation: unauthorized type_indicator '
        '"$typeIndicator"');
    throw DeserializationSecurityException(
        'Unauthorized type_indicator "$typeIndicator"');
  }
  return resolved;
}

/// Bounds-checked enum resolution.
///
/// * A `null` [index] is treated as a legitimately missing field and resolves
///   to [fallback] (default index 0) without throwing.
/// * A present but out-of-range [index] is treated as a tampered payload:
///   it is logged via [debugPrint] and rethrown as a
///   [DeserializationSecurityException] (fail closed).
T safeEnumFromIndex<T extends Enum>(
  List<T> values,
  int? index, {
  int fallback = 0,
}) {
  if (index == null) {
    if (fallback < 0 || fallback >= values.length) {
      debugPrint(
          'Deserialization security violation: invalid fallback index '
          '$fallback for enum ${T.toString()}');
      throw DeserializationSecurityException(
          'Invalid fallback index $fallback for ${T.toString()}');
    }
    return values[fallback];
  }
  if (index < 0 || index >= values.length) {
    debugPrint(
        'Deserialization security violation: out-of-range enum index '
        '$index for ${T.toString()} (valid 0..${values.length - 1})');
    throw DeserializationSecurityException(
        'Out-of-range enum index $index for ${T.toString()}');
  }
  return values[index];
}

/// Strict variant of [safeEnumFromIndex]: throws on `null` **and** on
/// out-of-range indices. Delegates to [safeEnumFromIndex] (with a fallback)
/// but any violation is still logged and thrown to fail closed.
T safeEnumFromIndexOrThrow<T extends Enum>(
  List<T> values,
  int? index,
) {
  if (index == null) {
    debugPrint(
        'Deserialization security violation: null enum index for '
        '${T.toString()}');
    throw DeserializationSecurityException(
        'Null enum index for ${T.toString()}');
  }
  return safeEnumFromIndex(values, index);
}

/// Allowlisted, reflection-free factory for deserializing domain models.
///
/// Callers must pass a `type_indicator` string; only allowlisted values
/// resolve to a constructor. Unknown markers are rejected before any model
/// is instantiated.
class SecureModelFactory {
  SecureModelFactory._();

  static Object create(
    String? typeIndicator,
    Map<String, dynamic> map,
    String id,
  ) {
    switch (validateAndResolveType(typeIndicator)) {
      case AuthorizedModelType.userProfile:
        return UserProfile.fromMap(map, id);
      case AuthorizedModelType.cycleEntry:
        return CycleEntry.fromMap(map, id);
      case AuthorizedModelType.cyclePrediction:
        return CyclePrediction.fromMap(map, id);
      case AuthorizedModelType.reminder:
        return Reminder.fromMap(map, id);
    }
  }
}