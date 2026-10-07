abstract class CategoryRepository {
  Future<List<Map<String, dynamic>>> fetchCategories();

  Future<List<Map<String, dynamic>>> fetchSubcategories(String categoryId);

  Future<List<Map<String, dynamic>>> getCategoryProducts({
    required String categoryId,
    int page = 1,
    int limit = 20,
  });
}
