class AppRoutes {
  const AppRoutes._();

  static const String landing = '/landing';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String otp = '/otp';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String paymentResult = '/payment-result';
  static const String orderSuccess = '/order-success';
  static const String addresses = '/addresses';
  static const String categories = '/categories';
  static const String wishlist = '/wishlist';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String products = '/products';
  static const String productDetails = '/product-details';

  static String productDetail(String productId) => '$productDetails/$productId';
}
