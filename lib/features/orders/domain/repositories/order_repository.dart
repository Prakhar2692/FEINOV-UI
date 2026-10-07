import '../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({int page = 1});
  Future<Order> createOrder({required Map<String, dynamic> payload});
  Future<Order> getOrderById(String orderId);
}
