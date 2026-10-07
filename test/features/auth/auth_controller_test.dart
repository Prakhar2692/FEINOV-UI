import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/services/session_service.dart';
import 'package:feinov_ui/core/services/storage_service.dart';
import 'package:feinov_ui/features/auth/application/auth_state.dart';
import 'package:feinov_ui/features/auth/domain/entities/user.dart';
import 'package:feinov_ui/features/auth/domain/repositories/auth_repository.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    return User(
      id: 'u_1',
      email: email,
      name: 'Demo User',
      phoneNumber: '9876543210',
      isEmailVerified: true,
    );
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobileNumber,
    required String countryCode,
  }) async {
    return User(
      id: 'u_new',
      email: email,
      name: '$firstName $lastName',
      phoneNumber: mobileNumber,
      isEmailVerified: true,
    );
  }

  @override
  Future<void> sendOtp({
    required String mobileNumber,
    String countryCode = '+91',
  }) async {}

  @override
  Future<User> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    return User(
      id: 'u_otp',
      email: 'otp@feinov.com',
      name: 'OTP User',
      phoneNumber: mobileNumber,
      isEmailVerified: true,
    );
  }

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<User> verifyEmail({required String email, required String otp}) async {
    return User(
      id: 'u_email',
      email: email,
      name: 'Email Verified User',
      isEmailVerified: true,
    );
  }

  @override
  Future<User?> getCurrentUser() async {
    return User(
      id: 'u_current',
      email: 'current@feinov.com',
      name: 'Current User',
      phoneNumber: '9876543210',
      isEmailVerified: true,
    );
  }

  @override
  Future<void> logout() async {}
}

void main() {
  group('AuthController', () {
    test('initializes as authenticated when a saved token exists', () async {
      final storage = InMemoryStorageService();
      await storage.writeString('auth_token', 'saved-token');

      final controller = AuthController(
        _FakeAuthRepository(),
        SessionService(storage),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(controller.debugState.isAuthenticated, isTrue);
      expect(controller.debugState.user?.email, 'current@feinov.com');
    });

    test('signIn marks the user as authenticated', () async {
      final controller = AuthController(
        _FakeAuthRepository(),
        SessionService(InMemoryStorageService()),
      );

      await controller.signIn(
        email: 'demo@feinov.com',
        password: 'Password123',
      );

      expect(controller.debugState.isAuthenticated, isTrue);
      expect(controller.debugState.user?.email, 'demo@feinov.com');
      expect(controller.debugState.isLoading, isFalse);
    });

    test('signIn stores errorMessage when login fails', () async {
      final controller = AuthController(
        _FailingAuthRepository(),
        SessionService(InMemoryStorageService()),
      );

      await controller.signIn(email: 'demo@feinov.com', password: 'wrong-pass');

      expect(controller.debugState.isAuthenticated, isFalse);
      expect(
        controller.debugState.errorMessage,
        contains('Invalid credentials'),
      );
    });
  });
}

class _FailingAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    throw Exception('Invalid credentials');
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobileNumber,
    required String countryCode,
  }) async {
    throw Exception('Invalid credentials');
  }

  @override
  Future<void> sendOtp({
    required String mobileNumber,
    String countryCode = '+91',
  }) async {}

  @override
  Future<User> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    throw Exception('Invalid OTP');
  }

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<User> verifyEmail({required String email, required String otp}) async {
    throw Exception('Verification failed');
  }

  @override
  Future<User?> getCurrentUser() async => null;

  @override
  Future<void> logout() async {}
}
