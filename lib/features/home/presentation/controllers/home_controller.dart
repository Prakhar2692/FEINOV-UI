import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/product.dart';

part 'home_controller.g.dart';

class HomeData {
  final List<String> banners;
  final List<String> categories;
  final List<Product> bestSellers;
  final List<Product> newArrivals;
  final List<Product> trending;
  final List<Product> featured;
  final List<Product> recommended;

  HomeData({
    required this.banners,
    required this.categories,
    required this.bestSellers,
    required this.newArrivals,
    required this.trending,
    required this.featured,
    required this.recommended,
  });
}

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeData> build() async {
    return _fetchHomeData();
  }

  Future<HomeData> _fetchHomeData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final mockProducts = List.generate(
      6,
      (index) => Product(
        id: '$index',
        name: 'Product ${index + 1}',
        description: 'Luxury skincare product description.',
        price: 29.99 + (index * 10),
        imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=200&auto=format&fit=crop',
        isAvailable: true,
      ),
    );

    return HomeData(
      banners: [
        'https://images.unsplash.com/photo-1596462502278-27bfac4033c8?q=80&w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600&auto=format&fit=crop',
      ],
      categories: ['Cleansers', 'Serums', 'Moisturizers', 'Sunscreen', 'Masks', 'Toners'],
      bestSellers: mockProducts,
      newArrivals: mockProducts.reversed.toList(),
      trending: mockProducts.shuffleList(),
      featured: mockProducts.take(3).toList(),
      recommended: mockProducts,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchHomeData());
  }
}

extension ListShuffle<T> on List<T> {
  List<T> shuffleList() {
    final list = List<T>.from(this);
    list.shuffle();
    return list;
  }
}
