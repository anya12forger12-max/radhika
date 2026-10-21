import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/services/storage_service.dart';

abstract class CycleDataSource {
  List<CycleEntry> getCycleEntries(String userId);
  CycleEntry? getCycleEntry(String entryId);
  Future<void> saveCycleEntry(CycleEntry entry);
  Future<void> deleteCycleEntry(String entryId);
  Future<void> toggleFavorite(String entryId);
}

class HiveCycleDataSource implements CycleDataSource {
  final StorageService _storage;

  HiveCycleDataSource(this._storage);

  @override
  List<CycleEntry> getCycleEntries(String userId) =>
      _storage.getCycleEntries(userId);

  @override
  CycleEntry? getCycleEntry(String entryId) => _storage.getCycleEntry(entryId);

  @override
  Future<void> saveCycleEntry(CycleEntry entry) =>
      _storage.saveCycleEntry(entry);

  @override
  Future<void> deleteCycleEntry(String entryId) =>
      _storage.deleteCycleEntry(entryId);

  @override
  Future<void> toggleFavorite(String entryId) =>
      _storage.toggleFavorite(entryId);
}
