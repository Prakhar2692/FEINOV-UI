import '../../../home/domain/models/product.dart';

class ProductDto {
  const ProductDto(this.data);

  final Map<String, dynamic> data;

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(json);

  Product toDomain() => Product.fromJson(data);
}
