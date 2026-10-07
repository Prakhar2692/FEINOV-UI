import '../config/app_environment.dart';

class AppEndpoints {
  const AppEndpoints._();

  static String get baseUrl => AppEnvironment.current.baseUrl;
  static const String mockBaseUrl = 'https://api.mock.skincare.test/v1';

  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authVerifyEmail = '/auth/verify-email';
  static const String authSession = '/auth/session';
  static const String authLogout = '/auth/logout';
  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String payments = '/payments';
  static const String health = '/health';
}
