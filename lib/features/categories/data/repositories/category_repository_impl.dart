import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await dio.get(AppEndpoints.categories);
      final items = response.data is List
          ? response.data as List
          : (response.data['items'] as List? ?? const []);

      return items
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } on DioException {
      return _fallbackCategories();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchSubcategories(
    String categoryId,
  ) async {
    try {
      final response = await dio.get(
        '${AppEndpoints.categories}/$categoryId/subcategories',
      );
      final items = response.data is List
          ? response.data as List
          : (response.data['items'] as List? ?? const []);

      return items
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } on DioException {
      return _fallbackSubcategories(categoryId);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoryProducts({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '${AppEndpoints.categories}/$categoryId/products',
        queryParameters: {'page': page, 'limit': limit},
      );

      final items = response.data is List
          ? response.data as List
          : (response.data['items'] as List? ?? const []);

      return items
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } on DioException {
      return const [];
    }
  }

  List<Map<String, dynamic>> _fallbackCategories() {
    return [
      {
        'id': '1',
        'name': 'Cleansers',
        'imageUrl':
            'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=400&auto=format&fit=crop',
        'productCount': 24,
      },
      {
        'id': '2',
        'name': 'Serums',
        'imageUrl':
            'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=400&auto=format&fit=crop',
        'productCount': 18,
      },
      {
        'id': '3',
        'name': 'Moisturizers',
        'imageUrl':
            'https://images.unsplash.com/photo-1611080541599-8c6dbde6ed28?q=80&w=400&auto=format&fit=crop',
        'productCount': 32,
      },
      {
        'id': '4',
        'name': 'Sunscreen',
        'imageUrl':
            'https://images.unsplash.com/photo-1556229174-5e42a09e45af?q=80&w=400&auto=format&fit=crop',
        'productCount': 12,
      },
    ];
  }

  List<Map<String, dynamic>> _fallbackSubcategories(String categoryId) {
    final categoryName = categoryId.isEmpty ? 'Category' : categoryId;
    return [
      {
        'id': 'sub_1',
        'categoryId': categoryId,
        'name': '$categoryName Daily Cleanse',
        'imageUrl':
            'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=400&auto=format&fit=crop',
        'productCount': 10,
      },
      {
        'id': 'sub_2',
        'categoryId': categoryId,
        'name': '$categoryName Oil-Free',
        'imageUrl':
            'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=400&auto=format&fit=crop',
        'productCount': 8,
      },
    ];
  }
}
