import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory.freezed.dart';
part 'subcategory.g.dart';

@freezed
class Subcategory with _$Subcategory {
  const factory Subcategory({
    required String id,
    required String categoryId,
    required String name,
    required String imageUrl,
    @Default(0) int productCount,
  }) = _Subcategory;

  factory Subcategory.fromJson(Map<String, dynamic> json) => _$SubcategoryFromJson(json);
}
