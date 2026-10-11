import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/constants/app_routes.dart';

void main() {
  group('AppRoutes auth redirect helpers', () {
    test('builds auth route with a redirect target', () {
      expect(
        AppRoutes.authWithRedirect('/products'),
        '/auth?redirect=%2Fproducts',
      );
      expect(
        AppRoutes.authWithRedirect(
          '/products',
          message: 'Please sign in to continue',
        ),
        '/auth?redirect=%2Fproducts&message=Please%20sign%20in%20to%20continue',
      );
    });

    test('resolves the last screen after a successful login', () {
      expect(
        AppRoutes.resolveRedirectAfterAuth('/product-details/abc'),
        '/product-details/abc',
      );
      expect(AppRoutes.resolveRedirectAfterAuth(null), '/home');
    });

    test('keeps public home and product routes accessible to guests', () {
      expect(AppRoutes.isProtectedRoute('/home'), isFalse);
      expect(AppRoutes.isProtectedRoute('/categories'), isFalse);
      expect(AppRoutes.isProtectedRoute('/products'), isFalse);
      expect(AppRoutes.isProtectedRoute('/product-details/123'), isFalse);
      expect(AppRoutes.isProtectedRoute('/cart'), isTrue);
      expect(AppRoutes.isProtectedRoute('/checkout'), isTrue);
      expect(AppRoutes.isProtectedRoute('/wishlist'), isTrue);
    });
  });
}
