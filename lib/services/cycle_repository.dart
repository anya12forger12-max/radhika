import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/services/cycle_data_source.dart';
import 'package:radhika/services/storage_service.dart';

abstract class CycleRepository {
  List<CycleEntry> getCycleEntries(String userId);
  Future<void> toggleFavorite(String entryId);
}

class HiveCycleRepository implements CycleRepository {
  final CycleDataSource _dataSource;

  HiveCycleRepository(this._dataSource);

  @override
  List<CycleEntry> getCycleEntries(String userId) =>
      _dataSource.getCycleEntries(userId);

  @override
  Future<void> toggleFavorite(String entryId) =>
      _dataSource.toggleFavorite(entryId);
}

final cycleDataSourceProvider = Provider<CycleDataSource>((ref) {
  final storage = ref.read(storageServiceProvider);
  return HiveCycleDataSource(storage);
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  final dataSource = ref.read(cycleDataSourceProvider);
  return HiveCycleRepository(dataSource);
});
