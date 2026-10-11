import '../config/app_environment.dart';

class AppEndpoints {
  const AppEndpoints._();

  static const String baseUrl = "http://localhost:5006";
  static const String mockBaseUrl = 'http://localhost:5006';

  // Admin endpoints from the API schema.
  // static const String adminCategories = '/api/admin/categories';
  // static const String adminCategorySubcategories =
  //     '/api/admin/categories/{categoryId}/subcategories';
  // static const String adminProducts = '/api/admin/products';
  // static const String adminProductVariants =
  //     '/api/admin/products/{productId}/variants';
  // static const String adminProductImages =
  //     '/api/admin/products/{productId}/images';
  // static const String adminInventoryByVariant =
  //     '/api/admin/inventory/{variantId}';
  // static const String adminInventory = '/api/admin/inventory';
  // static const String adminOrders = '/api/admin/orders';
  // static const String adminOrderStatus = '/api/admin/orders/{orderId}/status';

  // Auth endpoints.
  static const String authSendOtp = '/api/auth/send-otp';
  static const String authVerifyOtp = '/api/auth/verify-otp';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String authVerifyOtpLegacy = '/auth/verify-otp';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authVerifyEmail = '/auth/verify-email';
  static const String authSession = '/auth/session';
  static const String authLogout = '/auth/logout';

  // Catalog, cart, and checkout endpoints.
  static const String cartItems = '/api/cart/items';
  static const String cartItemQuantity =
      '/api/cart/items/{cartItemId}/quantity';
  static const String cartByUser = '/api/cart/{userId}';
  static const String checkout = '/api/checkout';
  static const String customerAddresses = '/api/customers/addresses';
  static const String customerAddressByUser =
      '/api/customers/{userId}/addresses';
  static const String catalogProducts = '/api/catalog/products';
  static const String catalogProductDetails =
      '/api/catalog/products/{productId}';
  static const String reviews = '/api/reviews';
  static const String productReviews = '/api/reviews/products/{productId}';
  static const String paymentsVerify = '/api/payments/verify';
  static const String health = '/api/health';

  // Existing app feature endpoints retained for current project architecture.
  static const String home = '/home';
  static const String homeBanners = '/home/banners';
  static const String homeCategories = '/home/categories';
  static const String homeFeaturedProducts = '/home/products/featured';
  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String orders = '/api/orders';
  static const String orderHistory = '/api/orders/history';
  static const String orderDetails = '/api/orders/{orderId}';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String payments = '/payments';
  static const String appHealth = '/health';
}
