import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/subcategory.dart';

part 'subcategory_controller.g.dart';

@riverpod
class SubcategoryController extends _$SubcategoryController {
  @override
  Future<List<Subcategory>> build(String categoryId) async {
    return _fetchSubcategories(categoryId);
  }

  Future<List<Subcategory>> _fetchSubcategories(String categoryId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock subcategories based on categoryId
    return [
      Subcategory(
        id: 'sub_1',
        categoryId: categoryId,
        name: 'Daily Cleanse',
        imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=400&auto=format&fit=crop',
        productCount: 10,
      ),
      Subcategory(
        id: 'sub_2',
        categoryId: categoryId,
        name: 'Oil-Free',
        imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=400&auto=format&fit=crop',
        productCount: 8,
      ),
      Subcategory(
        id: 'sub_3',
        categoryId: categoryId,
        name: 'Exfoliating',
        imageUrl: 'https://images.unsplash.com/photo-1611080541599-8c6dbde6ed28?q=80&w=400&auto=format&fit=crop',
        productCount: 12,
      ),
      Subcategory(
        id: 'sub_4',
        categoryId: categoryId,
        name: 'Gentle Care',
        imageUrl: 'https://images.unsplash.com/photo-1556229174-5e42a09e45af?q=80&w=400&auto=format&fit=crop',
        productCount: 6,
      ),
    ];
  }

  Future<void> refresh(String categoryId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSubcategories(categoryId));
  }
}
