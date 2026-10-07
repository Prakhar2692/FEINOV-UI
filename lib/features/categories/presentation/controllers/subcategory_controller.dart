import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../domain/models/subcategory.dart';

part 'subcategory_controller.g.dart';

@riverpod
class SubcategoryController extends _$SubcategoryController {
  @override
  Future<List<Subcategory>> build(String categoryId) async {
    return _fetchSubcategories(categoryId);
  }

  Future<List<Subcategory>> _fetchSubcategories(String categoryId) async {
    final repository = ref.read(categoryRepositoryProvider);
    final items = await repository.fetchSubcategories(categoryId);
    return items.map(Subcategory.fromJson).toList();
  }

  Future<void> refresh(String categoryId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSubcategories(categoryId));
  }
}
