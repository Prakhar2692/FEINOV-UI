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

  static bool isProtectedRoute(String? route) {
    if (route == null || route.isEmpty) return false;

    final routes = <String>{
      cart,
      checkout,
      paymentResult,
      addresses,
      wishlist,
      orders,
      profile,
    };

    return routes.contains(route) ||
        routes.any((item) => route.startsWith('$item/'));
  }

  static String authWithRedirect(
    String? redirectTo, {
    String fallback = home,
    String? message,
  }) {
    final target = resolveRedirectAfterAuth(redirectTo, fallback: fallback);

    final params = <String, String>{
      'redirect': Uri.encodeComponent(target),
      if (message != null && message.trim().isNotEmpty)
        'message': Uri.encodeComponent(message.trim()),
    };

    return '$auth?${params.entries.map((entry) => '${entry.key}=${entry.value}').join('&')}';
  }

  static String resolveRedirectAfterAuth(
    String? redirectTo, {
    String fallback = home,
  }) {
    if (redirectTo == null || redirectTo.trim().isEmpty) {
      return fallback;
    }

    final cleanTarget = redirectTo.trim();
    if (cleanTarget == auth || cleanTarget == landing) {
      return fallback;
    }

    return cleanTarget.startsWith('/') ? cleanTarget : '/$cleanTarget';
  }
}
