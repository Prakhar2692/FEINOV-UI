import 'product.dart';

class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.ctaLabel,
    this.targetRoute,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? ctaLabel;
  final String? targetRoute;

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? 'Featured offer').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? json['image'] ?? '')
          .toString(),
      subtitle: json['subtitle']?.toString(),
      ctaLabel: json['ctaLabel']?.toString(),
      targetRoute: json['targetRoute']?.toString(),
    );
  }
}

class HomeCategory {
  const HomeCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.slug,
    this.icon,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String? slug;
  final String? icon;

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Category').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? json['image'] ?? '')
          .toString(),
      slug: json['slug']?.toString(),
      icon: json['icon']?.toString(),
    );
  }
}

class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.isWishlisted = false,
    this.isFeatured = false,
    this.isTrending = false,
    this.isRecommended = false,
    this.isNewArrival = false,
    this.categoryId,
    this.brand,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isWishlisted;
  final bool isFeatured;
  final bool isTrending;
  final bool isRecommended;
  final bool isNewArrival;
  final String? categoryId;
  final String? brand;

  factory HomeProduct.fromJson(Map<String, dynamic> json) {
    return HomeProduct(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Product').toString(),
      description: (json['description'] ?? 'Premium product for everyday care.')
          .toString(),
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? json['image'] ?? '')
          .toString(),
      originalPrice: (json['originalPrice'] ?? json['original_price']) == null
          ? null
          : (json['originalPrice'] ?? json['original_price']).toDouble(),
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount:
          int.tryParse(
            (json['reviewCount'] ?? json['reviews'] ?? '0').toString(),
          ) ??
          0,
      isAvailable: json['isAvailable'] ?? true,
      isWishlisted: json['isWishlisted'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
      isNewArrival: json['isNewArrival'] ?? false,
      categoryId: json['categoryId']?.toString(),
      brand: json['brand']?.toString() ?? 'FEINOV',
    );
  }

  Product toProduct() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      originalPrice: originalPrice,
      rating: rating,
      reviewCount: reviewCount,
      isAvailable: isAvailable,
      isWishlisted: isWishlisted,
      variants: const [],
      ingredients: const [],
      benefits: const [],
      productInfo: const [],
    );
  }
}

class HomePageData {
  const HomePageData({
    required this.banners,
    required this.categories,
    required this.featuredProducts,
    required this.trendingProducts,
    required this.recommendedProducts,
    this.newArrivals = const [],
    this.recentlyViewedProducts = const [],
  });

  final List<HomeBanner> banners;
  final List<HomeCategory> categories;
  final List<HomeProduct> featuredProducts;
  final List<HomeProduct> trendingProducts;
  final List<HomeProduct> recommendedProducts;
  final List<HomeProduct> newArrivals;
  final List<HomeProduct> recentlyViewedProducts;

  factory HomePageData.fromJson(Map<String, dynamic> json) {
    final bannerList = (json['banners'] as List? ?? const [])
        .map(
          (item) => HomeBanner.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
    final categoryList = (json['categories'] as List? ?? const [])
        .map(
          (item) =>
              HomeCategory.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
    final featured =
        (json['featuredProducts'] as List? ??
                json['featured'] as List? ??
                const [])
            .map(
              (item) =>
                  HomeProduct.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
    final trending =
        (json['trendingProducts'] as List? ??
                json['trending'] as List? ??
                const [])
            .map(
              (item) =>
                  HomeProduct.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
    final recommended =
        (json['recommendedProducts'] as List? ??
                json['recommended'] as List? ??
                const [])
            .map(
              (item) =>
                  HomeProduct.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
    final arrivals = (json['newArrivals'] as List? ?? const [])
        .map(
          (item) =>
              HomeProduct.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
    final recentlyViewed = (json['recentlyViewedProducts'] as List? ?? const [])
        .map(
          (item) =>
              HomeProduct.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();

    return HomePageData(
      banners: bannerList,
      categories: categoryList,
      featuredProducts: featured,
      trendingProducts: trending,
      recommendedProducts: recommended,
      newArrivals: arrivals,
      recentlyViewedProducts: recentlyViewed,
    );
  }

  static HomePageData fallback() {
    return HomePageData(
      banners: [
        const HomeBanner(
          id: 'banner-1',
          title: 'Summer Skin Reset',
          imageUrl:
              'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1200&q=80',
          subtitle: 'Save up to 40% on glow essentials',
          ctaLabel: 'Shop now',
        ),
        const HomeBanner(
          id: 'banner-2',
          title: 'Barrier repair essentials',
          imageUrl:
              'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?auto=format&fit=crop&w=1200&q=80',
          subtitle: 'New hydration rituals for sensitive skin',
          ctaLabel: 'Explore',
        ),
      ],
      categories: const [
        HomeCategory(
          id: 'cat-1',
          name: 'Cleansers',
          imageUrl:
              'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=500&q=80',
        ),
        HomeCategory(
          id: 'cat-2',
          name: 'Serums',
          imageUrl:
              'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?auto=format&fit=crop&w=500&q=80',
        ),
        HomeCategory(
          id: 'cat-3',
          name: 'Moisturizers',
          imageUrl:
              'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=500&q=80',
        ),
        HomeCategory(
          id: 'cat-4',
          name: 'Sunscreen',
          imageUrl:
              'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=500&q=80',
        ),
      ],
      featuredProducts: [
        HomeProduct(
          id: 'p-feature-1',
          name: 'Hydra Dew Serum',
          description: 'Plumps and strengthens the skin barrier.',
          price: 64.0,
          imageUrl:
              'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?auto=format&fit=crop&w=900&q=80',
          originalPrice: 92.0,
          rating: 4.8,
          reviewCount: 321,
          isFeatured: true,
          isRecommended: true,
          brand: 'FEINOV',
        ),
        HomeProduct(
          id: 'p-feature-2',
          name: 'Night Repair Cream',
          description: 'Recover overnight with ceramides and peptides.',
          price: 76.0,
          imageUrl:
              'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?auto=format&fit=crop&w=900&q=80',
          originalPrice: 104.0,
          rating: 4.9,
          reviewCount: 287,
          isFeatured: true,
          brand: 'FEINOV',
        ),
      ],
      trendingProducts: [
        HomeProduct(
          id: 'p-trend-1',
          name: 'Vitamin C Glow',
          description: 'Brightening serum for dull skin.',
          price: 58.0,
          imageUrl:
              'https://images.unsplash.com/photo-1617897903246-719242758050?auto=format&fit=crop&w=900&q=80',
          rating: 4.7,
          reviewCount: 198,
          isTrending: true,
        ),
        HomeProduct(
          id: 'p-trend-2',
          name: 'Barrier Essence',
          description: 'Deeply soothing and replenishing treatment.',
          price: 49.0,
          imageUrl:
              'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80',
          rating: 4.6,
          reviewCount: 164,
          isTrending: true,
        ),
      ],
      recommendedProducts: [
        HomeProduct(
          id: 'p-rec-1',
          name: 'Daily Dew Cleanser',
          description: 'Low-foaming cleanser for smooth, clean skin.',
          price: 32.0,
          imageUrl:
              'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?auto=format&fit=crop&w=900&q=80',
          rating: 4.8,
          reviewCount: 240,
          isRecommended: true,
        ),
        HomeProduct(
          id: 'p-rec-2',
          name: 'Soft Reset Mask',
          description: 'Resurfacing mask with gentle exfoliating actives.',
          price: 42.0,
          imageUrl:
              'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80',
          rating: 4.7,
          reviewCount: 148,
          isRecommended: true,
        ),
      ],
      newArrivals: [
        HomeProduct(
          id: 'p-new-1',
          name: 'Cloud Cream',
          description: 'A cushiony moisturizer for instant comfort.',
          price: 46.0,
          imageUrl:
              'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?auto=format&fit=crop&w=900&q=80',
          rating: 4.8,
          reviewCount: 122,
          isNewArrival: true,
        ),
      ],
      recentlyViewedProducts: [
        HomeProduct(
          id: 'p-recent-1',
          name: 'Peptide Recovery',
          description: 'Made for post-sun and dry weather comfort.',
          price: 51.0,
          imageUrl:
              'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=900&q=80',
          rating: 4.9,
          reviewCount: 205,
        ),
      ],
    );
  }
}
