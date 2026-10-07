class SearchResult {
  const SearchResult({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.brand,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? brand;
  final bool isAvailable;

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Product').toString(),
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(),
      brand: json['brand']?.toString(),
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
