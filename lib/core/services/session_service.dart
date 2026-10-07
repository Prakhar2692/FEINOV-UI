import 'storage_service.dart';

class SessionService {
  SessionService(this.storage);

  final StorageService storage;

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await storage.writeString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return storage.readString(_tokenKey);
  }

  Future<void> clear() async {
    await storage.delete(_tokenKey);
  }
}
