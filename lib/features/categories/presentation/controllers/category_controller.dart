import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/category.dart';

part 'category_controller.g.dart';

@riverpod
class CategoryController extends _$CategoryController {
  @override
  Future<List<Category>> build() async {
    return _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return const [
      Category(
        id: '1',
        name: 'Cleansers',
        imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=400&auto=format&fit=crop',
        productCount: 24,
      ),
      Category(
        id: '2',
        name: 'Serums',
        imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=400&auto=format&fit=crop',
        productCount: 18,
      ),
      Category(
        id: '3',
        name: 'Moisturizers',
        imageUrl: 'https://images.unsplash.com/photo-1611080541599-8c6dbde6ed28?q=80&w=400&auto=format&fit=crop',
        productCount: 32,
      ),
      Category(
        id: '4',
        name: 'Sunscreen',
        imageUrl: 'https://images.unsplash.com/photo-1556229174-5e42a09e45af?q=80&w=400&auto=format&fit=crop',
        productCount: 12,
      ),
      Category(
        id: '5',
        name: 'Toners',
        imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=400&auto=format&fit=crop',
        productCount: 15,
      ),
      Category(
        id: '6',
        name: 'Face Masks',
        imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=400&auto=format&fit=crop',
        productCount: 20,
      ),
      Category(
        id: '7',
        name: 'Eye Care',
        imageUrl: 'https://images.unsplash.com/photo-1591130901921-3f0652bb3915?q=80&w=400&auto=format&fit=crop',
        productCount: 8,
      ),
      Category(
        id: '8',
        name: 'Body Care',
        imageUrl: 'https://images.unsplash.com/photo-1552046122-03184de85e08?q=80&w=400&auto=format&fit=crop',
        productCount: 25,
      ),
    ];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCategories());
  }
}
