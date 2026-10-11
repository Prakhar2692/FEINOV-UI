import '../entities/user.dart';

class RegisterResult {
  const RegisterResult({required this.statusCode, this.user, this.message});

  final int statusCode;
  final User? user;
  final String? message;

  bool get isSuccess => statusCode == 200 && user != null;
}

abstract class AuthRepository {
  Future<bool> isAuthenticated();

  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = true,
  });

  Future<RegisterResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobileNumber,
    required String countryCode,
  });

  Future<void> sendOtp({
    required String mobileNumber,
    String countryCode = '+91',
  });

  Future<User> verifyOtp({required String mobileNumber, required String otp});

  Future<void> forgotPassword(String email);

  Future<User> verifyEmail({required String email, required String otp});

  Future<User?> getCurrentUser();

  Future<void> logout();
}
