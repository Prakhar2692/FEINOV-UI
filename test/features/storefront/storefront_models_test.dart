import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/features/orders/domain/models/order.dart';
import 'package:feinov_ui/features/payment/domain/models/payment_method.dart';
import 'package:feinov_ui/features/profile/domain/models/profile.dart';
import 'package:feinov_ui/features/search/domain/models/search_result.dart';
import 'package:feinov_ui/features/wishlist/domain/models/wishlist_item.dart';

void main() {
  group('Storefront domain models', () {
    test('PaymentMethod masks card details without exposing raw digits', () {
      const method = PaymentMethod(
        id: 'pm_1',
        type: PaymentMethodType.card,
        title: 'Visa ending in 4242',
        isDefault: true,
        last4: '4242',
      );

      expect(method.maskedDisplay, 'Visa •••• 4242');
      expect(method.isCard, isTrue);
    });

    test('OrderStatus parses API response values safely', () {
      expect(OrderStatus.fromApiValue('shipped'), OrderStatus.shipped);
      expect(OrderStatus.fromApiValue('UNKNOWN'), OrderStatus.pending);
    });

    test('UserProfile.fromJson builds profile data from API payload', () {
      final profile = UserProfile.fromJson({
        'id': 'u_1',
        'firstName': 'Aditi',
        'lastName': 'Sharma',
        'email': 'aditi@example.com',
        'phone': '+91 98765 43210',
        'addresses': [
          {'id': 'a_1', 'label': 'Home', 'city': 'Bengaluru'}
        ],
      });

      expect(profile.fullName, 'Aditi Sharma');
      expect(profile.addresses.first.label, 'Home');
    });

    test('SearchResult.fromJson maps product hits and highlights', () {
      final result = SearchResult.fromJson({
        'id': 'p_1',
        'name': 'Vitamin C Serum',
        'price': 49.0,
        'imageUrl': 'https://example.com/vitamin.jpg',
      });

      expect(result.name, 'Vitamin C Serum');
      expect(result.price, 49.0);
    });

    test('WishlistItem models favorite products with add-to-cart state', () {
      final item = WishlistItem.fromJson({
        'id': 'w_1',
        'productId': 'p_2',
        'name': 'Hydra Mist',
        'price': 38.5,
      });

      expect(item.productId, 'p_2');
      expect(item.name, 'Hydra Mist');
      expect(item.isSaved, isTrue);
    });
  });
}
