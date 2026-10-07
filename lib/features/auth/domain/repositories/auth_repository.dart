abstract class AuthRepository {
  Future<bool> isAuthenticated();
  Future<void> login({required String email, required String password});
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String countryCode,
  });
  Future<void> sendOtp({
    required String mobileNumber,
    String countryCode = '+91',
  });
  Future<void> verifyOtp({required String mobileNumber, required String otp});
  Future<void> logout();
}
