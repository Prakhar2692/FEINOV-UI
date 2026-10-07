import '../../../home/domain/models/product.dart';

class ProductDetailDto {
  const ProductDetailDto(this.data);

  final Map<String, dynamic> data;

  factory ProductDetailDto.fromJson(Map<String, dynamic> json) =>
      ProductDetailDto(json);

  Product toDomain() => Product.fromJson(data);
}
