import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/models/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  const WishlistRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<WishlistItem>> fetchWishlist() async {
    final response = await dio.get('${AppEndpoints.products}/wishlist');
    final items = (response.data['items'] as List? ?? const [])
        .map((item) => WishlistItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return items;
  }

  @override
  Future<List<WishlistItem>> toggleWishlist({required String productId}) async {
    final response = await dio.post(
      '${AppEndpoints.products}/wishlist/$productId',
      data: {'productId': productId},
    );
    final items = (response.data['items'] as List? ?? const [])
        .map((item) => WishlistItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return items;
  }

  @override
  Future<List<WishlistItem>> syncWishlist({required List<String> productIds}) async {
    final response = await dio.post(
      '${AppEndpoints.products}/wishlist/sync',
      data: {'productIds': productIds},
    );
    final items = (response.data['items'] as List? ?? const [])
        .map((item) => WishlistItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return items;
  }
}
