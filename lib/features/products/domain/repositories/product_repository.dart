abstract class ProductRepository {
  Future<List<Map<String, dynamic>>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> getProductById(String productId);
  Future<List<Map<String, dynamic>>> getFeaturedProducts();
}
