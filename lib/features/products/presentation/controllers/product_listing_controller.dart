import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/home/domain/models/product.dart';
import 'product_filter_controller.dart';

part 'product_listing_controller.g.dart';

class ProductListingState {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadMore;
  final int page;
  final bool hasMore;

  ProductListingState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.page = 1,
    this.hasMore = true,
  });

  ProductListingState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadMore,
    int? page,
    bool? hasMore,
  }) {
    return ProductListingState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class ProductListingController extends _$ProductListingController {
  @override
  ProductListingState build(String? subcategoryId) {
    // Listen to filter changes to auto-apply them
    ref.listen(productFilterControllerProvider, (previous, next) {
      fetchProducts(isRefresh: true);
    });

    _init();
    return ProductListingState(isLoading: true);
  }

  Future<void> _init() async {
    await fetchProducts();
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isLoading: true, products: [], page: 1, hasMore: true);
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final filter = ref.read(productFilterControllerProvider);

      var newProducts = List.generate(
        10,
        (index) => Product(
          id: 'prod_${state.products.length + index}',
          name: 'Skincare Product ${state.products.length + index + 1}',
          description: 'A premium luxury skincare solution.',
          price: 45.0 + (index * 5) % 100, // Vary price for testing sort
          originalPrice: 60.0 + index,
          rating: (4.0 + (index % 5) * 0.2).clamp(0, 5),
          reviewCount: 10 + (index * 20),
          imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=200&auto=format&fit=crop',
          isAvailable: true,
        ),
      );

      // Apply Filter Logic (locally for mock data)
      newProducts = newProducts.where((p) => p.price >= filter.minPrice && p.price <= filter.maxPrice).toList();

      // Apply Sort Logic
      switch (filter.sortBy) {
        case 'price_low':
          newProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high':
          newProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating':
          newProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'newest':
        default:
          // For mock, newest is just descending ID
          newProducts.sort((a, b) => b.id.compareTo(a.id));
          break;
      }

      state = state.copyWith(
        products: [...state.products, ...newProducts],
        isLoading: false,
        isLoadMore: false,
        page: state.page + 1,
        hasMore: state.page < 5, // Mock 5 pages
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isLoadMore: false);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadMore || !state.hasMore) return;
    
    state = state.copyWith(isLoadMore: true);
    await fetchProducts();
  }

  void toggleWishlist(String productId) {
    final updatedProducts = state.products.map((p) {
      if (p.id == productId) {
        return p.copyWith(isWishlisted: !p.isWishlisted);
      }
      return p;
    }).toList();
    state = state.copyWith(products: updatedProducts);
  }
}
