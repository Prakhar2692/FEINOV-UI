import '../models/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> fetchWishlist();
  Future<List<WishlistItem>> toggleWishlist({required String productId});
  Future<List<WishlistItem>> syncWishlist({required List<String> productIds});
}
