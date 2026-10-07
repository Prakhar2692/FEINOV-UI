import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/models/order.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Order>> getOrders({int page = 1}) async {
    final response = await dio.get(
      AppEndpoints.orders,
      queryParameters: {'page': page},
    );

    final items = (response.data['items'] as List? ?? const [])
        .map((item) => Order.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return items;
  }

  @override
  Future<Order> createOrder({required Map<String, dynamic> payload}) async {
    final response = await dio.post(AppEndpoints.orders, data: payload);
    final data = response.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return Order.fromJson(data);
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    final response = await dio.get('${AppEndpoints.orders}/$orderId');
    final data = response.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return Order.fromJson(data);
  }
}
