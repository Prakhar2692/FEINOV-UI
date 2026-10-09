import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/di/app_providers.dart';
import 'package:feinov_ui/features/cart/domain/repositories/cart_repository.dart';
import 'package:feinov_ui/features/cart/presentation/controllers/cart_controller.dart';
import 'package:feinov_ui/features/home/domain/models/product.dart';

class _FakeCartRepository implements CartRepository {
  final List<Map<String, dynamic>> _items = [];

  @override
  Future<List<Map<String, dynamic>>> getCartItems() async => _items;

  @override
  Future<Map<String, dynamic>> addItem({
    required String productId,
    int quantity = 1,
  }) async {
    _items.add({
      'id': 'item_$productId',
      'product': {
        'id': productId,
        'name': 'Serum',
        'description': 'Hydrating serum',
        'price': 42.0,
        'imageUrl': 'https://example.com/serum.jpg',
      },
      'quantity': quantity,
    });

    return _items.last;
  }

  @override
  Future<Map<String, dynamic>> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    final index = _items.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      _items[index]['quantity'] = quantity;
      return _items[index];
    }
    return {};
  }

  @override
  Future<void> removeItem(String itemId) async {
    _items.removeWhere((item) => item['id'] == itemId);
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
  }
}

void main() {
  test(
    'cart controller calculates subtotal and total for selected products',
    () async {
      final container = ProviderContainer(
        overrides: [
          cartRepositoryProvider.overrideWithValue(_FakeCartRepository()),
        ],
      );

      final controller = container.read(cartControllerProvider.notifier);
      final product = Product(
        id: 'p_1',
        name: 'Vitamin C Serum',
        description: 'Brightening serum',
        price: 42.0,
        imageUrl: 'https://example.com/vitamin-c.jpg',
        isAvailable: true,
      );

      await controller.addItem(product);
      await controller.updateProductQuantity(product, 2);

      expect(container.read(cartControllerProvider).valueOrNull, isNotEmpty);
      expect(controller.getProductQuantity(product.id), 2);
      expect(controller.subtotal, 84.0);
      expect(controller.total, 89.0);
    },
  );

  test('cart controller removes items when quantity reaches zero', () async {
    final container = ProviderContainer(
      overrides: [
        cartRepositoryProvider.overrideWithValue(_FakeCartRepository()),
      ],
    );

    final controller = container.read(cartControllerProvider.notifier);
    final product = Product(
      id: 'p_2',
      name: 'Hydra Cream',
      description: 'Moisturizer',
      price: 39.0,
      imageUrl: 'https://example.com/hydra-cream.jpg',
      isAvailable: true,
    );

    await controller.addItem(product);
    final item =
        (container.read(cartControllerProvider).valueOrNull ?? []).first;
    await controller.updateQuantity(item.id, 0);

    expect(controller.state.valueOrNull, isEmpty);
    expect(controller.subtotal, 0.0);
  });
}
