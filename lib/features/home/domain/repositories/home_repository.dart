import '../models/home_models.dart';

abstract class HomeRepository {
  Future<HomePageData> fetchHomeData();

  Future<List<Map<String, dynamic>>> fetchBanners();

  Future<List<Map<String, dynamic>>> fetchCategories();

  Future<List<Map<String, dynamic>>> fetchFeaturedProducts();
}
