class AppEndpoints {
  const AppEndpoints._();

  static const String baseUrl = 'https://api.skincare.com/v1';
  static const String mockBaseUrl = 'https://api.mock.skincare.test/v1';

  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String payments = '/payments';
  static const String health = '/health';
}
