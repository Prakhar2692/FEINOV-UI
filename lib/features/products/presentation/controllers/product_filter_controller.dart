import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/product_filter.dart';

part 'product_filter_controller.g.dart';

@riverpod
class ProductFilterController extends _$ProductFilterController {
  @override
  ProductFilter build() {
    return const ProductFilter();
  }

  void updateFilter(ProductFilter filter) {
    state = filter;
  }

  void resetFilter() {
    state = const ProductFilter();
  }

  void toggleSkinType(String type) {
    final types = List<String>.from(state.skinTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }
    state = state.copyWith(skinTypes: types);
  }

  void toggleConcern(String concern) {
    final concerns = List<String>.from(state.concerns);
    if (concerns.contains(concern)) {
      concerns.remove(concern);
    } else {
      concerns.add(concern);
    }
    state = state.copyWith(concerns: concerns);
  }

  void toggleIngredient(String ingredient) {
    final ingredients = List<String>.from(state.ingredients);
    if (ingredients.contains(ingredient)) {
      ingredients.remove(ingredient);
    } else {
      ingredients.add(ingredient);
    }
    state = state.copyWith(ingredients: ingredients);
  }

  void setPriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }
}
