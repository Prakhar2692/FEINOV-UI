abstract class CheckoutRepository {
  Future<Map<String, dynamic>> createCheckoutSession({
    required Map<String, dynamic> payload,
  });

  Future<Map<String, dynamic>> placeOrder({
    required Map<String, dynamic> payload,
  });

  Future<Map<String, dynamic>> getShippingMethods();
}
