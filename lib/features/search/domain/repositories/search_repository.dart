import '../models/search_result.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> search({required String query, int page = 1});
  Future<List<String>> getSuggestions(String query);
}
