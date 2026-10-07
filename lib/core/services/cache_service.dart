import 'storage_service.dart';

class CacheService {
  CacheService(this.storage);

  final StorageService storage;

  Future<void> putString(String key, String value) =>
      storage.writeString(key, value);

  Future<String?> getString(String key) => storage.readString(key);

  Future<void> remove(String key) => storage.delete(key);
}
