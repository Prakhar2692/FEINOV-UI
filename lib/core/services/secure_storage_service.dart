import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_service.dart';

class SecureStorageService implements StorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> writeString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> readString(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<bool> contains(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }
}
