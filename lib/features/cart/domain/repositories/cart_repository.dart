abstract class CartRepository {
  Future<List<Map<String, dynamic>>> getCartItems();
  Future<Map<String, dynamic>> addItem({
    required String productId,
    int quantity = 1,
  });
  Future<Map<String, dynamic>> updateItem({
    required String itemId,
    required int quantity,
  });
  Future<void> removeItem(String itemId);
  Future<void> clearCart();
}
