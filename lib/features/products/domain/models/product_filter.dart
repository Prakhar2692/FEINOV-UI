import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_filter.freezed.dart';
part 'product_filter.g.dart';

@freezed
class ProductFilter with _$ProductFilter {
  const factory ProductFilter({
    String? categoryId,
    String? subcategoryId,
    @Default([]) List<String> skinTypes,
    @Default([]) List<String> concerns,
    @Default([]) List<String> ingredients,
    @Default(0) double minPrice,
    @Default(1000) double maxPrice,
    @Default('newest') String sortBy,
  }) = _ProductFilter;

  factory ProductFilter.fromJson(Map<String, dynamic> json) => _$ProductFilterFromJson(json);
}
