import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/models/search_result.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<SearchResult>> search({
    required String query,
    int page = 1,
  }) async {
    final response = await dio.get(
      AppEndpoints.products,
      queryParameters: {'q': query, 'page': page},
    );

    final items = (response.data['items'] as List? ?? const [])
        .map(
          (item) =>
              SearchResult.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();

    return items;
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    if (query.trim().isEmpty) return const [];

    final response = await dio.get(
      AppEndpoints.products,
      queryParameters: {'q': query, 'limit': 5},
    );

    final items = (response.data['items'] as List? ?? const [])
        .map((item) => (item as Map)['name']?.toString() ?? '')
        .where((value) => value.isNotEmpty)
        .toList();

    return items.isEmpty
        ? ['${query.trim()} serum', '${query.trim()} cleanser']
        : items;
  }
}
