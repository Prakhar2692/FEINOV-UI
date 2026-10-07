abstract class StorageService {
  Future<void> writeString(String key, String value);
  Future<String?> readString(String key);
  Future<void> delete(String key);
  Future<bool> contains(String key);
}

class InMemoryStorageService implements StorageService {
  final Map<String, String> _store = {};

  @override
  Future<void> writeString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> readString(String key) async {
    return _store[key];
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<bool> contains(String key) async {
    return _store.containsKey(key);
  }
}
