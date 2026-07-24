import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'offline_storage_service.dart';
import '../../auth/data/needs_repository.dart';

enum OfflineSyncResult { synced, noPendingNeeds, failed }

class SyncService {
  final OfflineStorageService _offlineStorage;
  final NeedsRepository _needsRepository;

  SyncService(this._offlineStorage, this._needsRepository);

  Future<OfflineSyncResult> syncOfflineNeeds() async {
    final pendingNeeds = await _offlineStorage.getPendingNeeds();

    if (pendingNeeds.isEmpty) {
      return OfflineSyncResult.noPendingNeeds;
    }

    try {
      for (var need in pendingNeeds) {
        await _needsRepository.addNeed(need);
      }

      await _offlineStorage.clearPendingNeeds();
      return OfflineSyncResult.synced;
    } catch (e) {
      return OfflineSyncResult.failed;
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final offlineStorage = ref.watch(offlineStorageProvider);
  final needsRepo = ref.watch(needsRepositoryProvider);
  return SyncService(offlineStorage, needsRepo);
});
