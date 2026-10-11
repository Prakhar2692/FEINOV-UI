import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/constants/app_endpoints.dart';
import 'package:feinov_ui/core/models/api_models.dart';

void main() {
  group('AppEndpoints', () {
    test('contains the full set of schema-defined API endpoints', () {
      expect(AppEndpoints.adminCategories, '/api/admin/categories');
      expect(
        AppEndpoints.adminCategorySubcategories,
        '/api/admin/categories/{categoryId}/subcategories',
      );
      expect(AppEndpoints.adminProducts, '/api/admin/products');
      expect(
        AppEndpoints.adminProductVariants,
        '/api/admin/products/{productId}/variants',
      );
      expect(
        AppEndpoints.adminProductImages,
        '/api/admin/products/{productId}/images',
      );
      expect(
        AppEndpoints.adminInventoryByVariant,
        '/api/admin/inventory/{variantId}',
      );
      expect(AppEndpoints.adminInventory, '/api/admin/inventory');
      expect(AppEndpoints.adminOrders, '/api/admin/orders');
      expect(
        AppEndpoints.adminOrderStatus,
        '/api/admin/orders/{orderId}/status',
      );
      expect(AppEndpoints.authSendOtp, '/api/auth/send-otp');
      expect(AppEndpoints.authVerifyOtp, '/api/auth/verify-otp');
      expect(AppEndpoints.cartItems, '/api/cart/items');
      expect(
        AppEndpoints.cartItemQuantity,
        '/api/cart/items/{cartItemId}/quantity',
      );
      expect(AppEndpoints.cartByUser, '/api/cart/{userId}');
      expect(AppEndpoints.catalogProducts, '/api/catalog/products');
      expect(
        AppEndpoints.catalogProductDetails,
        '/api/catalog/products/{productId}',
      );
      expect(AppEndpoints.checkout, '/api/checkout');
      expect(AppEndpoints.customerAddresses, '/api/customers/addresses');
      expect(
        AppEndpoints.customerAddressByUser,
        '/api/customers/{userId}/addresses',
      );
      expect(AppEndpoints.health, '/api/health');
      expect(AppEndpoints.orders, '/api/orders');
      expect(AppEndpoints.orderHistory, '/api/orders/history');
      expect(AppEndpoints.orderDetails, '/api/orders/{orderId}');
      expect(AppEndpoints.paymentsVerify, '/api/payments/verify');
      expect(AppEndpoints.reviews, '/api/reviews');
      expect(AppEndpoints.productReviews, '/api/reviews/products/{productId}');
    });
  });

  group('Api request models', () {
    test('serialize request payloads according to schema names', () {
      const addToCart = AddToCartRequest(
        userId: '11111111-1111-4111-8111-111111111111',
        variantId: '22222222-2222-4222-8222-222222222222',
        quantity: 2,
      );
      expect(addToCart.toJson(), {
        'userId': '11111111-1111-4111-8111-111111111111',
        'variantId': '22222222-2222-4222-8222-222222222222',
        'quantity': 2,
      });

      const verifyPayment = VerifyPaymentRequest(
        razorpayOrderId: 'order_1',
        razorpayPaymentId: 'pay_1',
        razorpaySignature: 'signature_1',
      );
      expect(verifyPayment.toJson(), {
        'razorpayOrderId': 'order_1',
        'razorpayPaymentId': 'pay_1',
        'razorpaySignature': 'signature_1',
      });
    });
  });
}
