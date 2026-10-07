abstract class OrderRepository {
  Future<List<Map<String, dynamic>>> getOrders({int page = 1});
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> payload,
  });
  Future<Map<String, dynamic>> getOrderById(String orderId);
}
