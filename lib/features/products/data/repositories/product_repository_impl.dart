import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Map<String, dynamic>>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      AppEndpoints.catalogProducts,
      queryParameters: {
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
        'PageNumber': page,
        'PageSize': limit,
      },
    );

    final items = response.data['items'] as List? ?? const [];
    return items.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<Map<String, dynamic>> getProductById(String productId) async {
    final response = await dio.get(
      AppEndpoints.catalogProductDetails.replaceFirst('{productId}', productId),
    );
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    final response = await dio.get(
      AppEndpoints.catalogProducts,
      queryParameters: {'featured': true, 'PageSize': 10},
    );
    final items = response.data['items'] as List? ?? const [];
    return items.map((item) => Map<String, dynamic>.from(item)).toList();
  }
}
