import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../../home/domain/models/product.dart';

part 'product_details_controller.g.dart';

@riverpod
class ProductDetailsController extends _$ProductDetailsController {
  @override
  Future<Product> build(String productId) async {
    return _fetchProductDetails(productId);
  }

  Future<Product> _fetchProductDetails(String productId) async {
    final repository = ref.read(productRepositoryProvider);
    final response = await repository.getProductById(productId);
    return Product.fromJson(response);
  }
}
