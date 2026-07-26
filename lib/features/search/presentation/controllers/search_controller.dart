import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../home/domain/models/product.dart';

part 'search_controller.g.dart';

class SearchState {
  final String query;
  final List<Product> results;
  final List<String> suggestions;
  final List<String> popularSearches;
  final List<String> recentSearches;
  final bool isLoading;
  final bool isLoadMore;
  final int page;
  final bool hasMore;

  SearchState({
    this.query = '',
    this.results = const [],
    this.suggestions = const [],
    this.popularSearches = const ['Cleanser', 'Retinol', 'Vitamin C', 'Moisturizer', 'SPF 50'],
    this.recentSearches = const ['Face Wash', 'Sunscreen'],
    this.isLoading = false,
    this.isLoadMore = false,
    this.page = 1,
    this.hasMore = true,
  });

  SearchState copyWith({
    String? query,
    List<Product>? results,
    List<String>? suggestions,
    List<String>? popularSearches,
    List<String>? recentSearches,
    bool? isLoading,
    bool? isLoadMore,
    int? page,
    bool? hasMore,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      popularSearches: popularSearches ?? this.popularSearches,
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class SearchController extends _$SearchController {
  Timer? _debounce;

  @override
  SearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return SearchState();
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
    
    if (query.isEmpty) {
      state = state.copyWith(suggestions: [], results: [], isLoading: false);
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    // Mock suggestions
    final allSuggestions = ['Cleansing Oil', 'Cleansing Gel', 'Cleansing Foam', 'Retinol Serum', 'Retinol Cream'];
    final filtered = allSuggestions.where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();
    state = state.copyWith(suggestions: filtered);
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return;
    
    // Add to recent searches
    final recent = List<String>.from(state.recentSearches);
    if (!recent.contains(query)) {
      recent.insert(0, query);
      if (recent.length > 5) recent.removeLast();
    }

    state = state.copyWith(
      query: query,
      isLoading: true,
      results: [],
      page: 1,
      hasMore: true,
      suggestions: [],
      recentSearches: recent,
    );

    await _fetchResults();
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadMore || !state.hasMore) return;
    
    state = state.copyWith(isLoadMore: true);
    await _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newProducts = List.generate(
        10,
        (index) => Product(
          id: 'search_${state.results.length + index}',
          name: '${state.query} Product ${state.results.length + index + 1}',
          description: 'A premium skincare product based on your search.',
          price: 35.0 + index,
          imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=200&auto=format&fit=crop',
          isAvailable: true,
        ),
      );

      state = state.copyWith(
        results: [...state.results, ...newProducts],
        isLoading: false,
        isLoadMore: false,
        page: state.page + 1,
        hasMore: state.page < 3, // Mock pagination limit
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isLoadMore: false);
    }
  }

  void clearRecent() {
    state = state.copyWith(recentSearches: []);
  }
}
