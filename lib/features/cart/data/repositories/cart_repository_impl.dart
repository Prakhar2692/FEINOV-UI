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
      AppEndpoints.cart,
      data: {'productId': productId, 'quantity': quantity},
    );
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await dio.patch(
      '${AppEndpoints.cart}/$itemId',
      data: {'quantity': quantity},
    );
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<void> removeItem(String itemId) async {
    await dio.delete('${AppEndpoints.cart}/$itemId');
  }

  @override
  Future<void> clearCart() async {
    await dio.delete(AppEndpoints.cart);
  }
}
