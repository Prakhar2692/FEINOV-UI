import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final response = await dio.get(AppEndpoints.cart);
    final items = response.data['items'] as List? ?? const [];
    return items.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<Map<String, dynamic>> addItem({
    required String productId,
    int quantity = 1,
  }) async {
    final response = await dio.post(
      AppEndpoints.cartItems,
      data: {
        'userId': 'current-user',
        'variantId': productId,
        'quantity': quantity,
      },
    );
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await dio.put(
      AppEndpoints.cartItemQuantity.replaceFirst('{cartItemId}', itemId),
      data: {'userId': 'current-user', 'quantity': quantity},
    );
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<void> removeItem(String itemId) async {
    await dio.delete(
      AppEndpoints.cartItemQuantity.replaceFirst('{cartItemId}', itemId),
    );
  }

  @override
  Future<void> clearCart() async {
    await dio.delete(AppEndpoints.cart);
  }
}
