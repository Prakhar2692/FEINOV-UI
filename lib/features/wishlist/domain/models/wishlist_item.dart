class WishlistItem {
  const WishlistItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.isSaved = true,
  });

  final String id;
  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  final bool isSaved;

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      productId: (json['productId'] ?? json['product_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Product').toString(),
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(),
      isSaved: json['isSaved'] ?? true,
    );
  }
}
