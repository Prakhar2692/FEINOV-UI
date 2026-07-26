import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    // Mock: return false for now to show login
    return false;
  }

  @override
  Future<void> logout() async {
    // Implement logout
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl();
}
