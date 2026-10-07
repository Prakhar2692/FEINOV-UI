import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Map<String, dynamic>>> getOrders({int page = 1}) async {
    final response = await dio.get(
      AppEndpoints.orders,
      queryParameters: {'page': page},
    );

    final items = response.data['items'] as List? ?? const [];
    return items.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> payload,
  }) async {
    final response = await dio.post(AppEndpoints.orders, data: payload);
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    final response = await dio.get('${AppEndpoints.orders}/$orderId');
    return Map<String, dynamic>.from(response.data);
  }
}
