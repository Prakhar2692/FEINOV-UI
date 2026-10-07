import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/di/app_providers.dart';
import 'package:feinov_ui/features/cart/domain/repositories/cart_repository.dart';
import 'package:feinov_ui/features/cart/presentation/pages/cart_page.dart';

class _FakeCartRepository implements CartRepository {
  @override
  Future<List<Map<String, dynamic>>> getCartItems() async => const [];

  @override
  Future<Map<String, dynamic>> addItem({
    required String productId,
    int quantity = 1,
  }) async => {'id': productId};

  @override
  Future<Map<String, dynamic>> updateItem({
    required String itemId,
    required int quantity,
  }) async => {'id': itemId, 'quantity': quantity};

  @override
  Future<void> removeItem(String itemId) async {}

  @override
  Future<void> clearCart() async {}
}

void main() {
  testWidgets('CartPage renders empty state for an empty cart', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartRepositoryProvider.overrideWithValue(_FakeCartRepository()),
        ],
        child: const MaterialApp(home: CartPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Shop Now'), findsOneWidget);
  });
}
