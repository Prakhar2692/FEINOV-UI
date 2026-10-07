import '../../domain/models/home_models.dart';

class HomeApiResponseDto {
  const HomeApiResponseDto({
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

  factory HomeApiResponseDto.fromJson(Map<String, dynamic> json) {
    return HomeApiResponseDto(
      banners: (json['banners'] as List? ?? const [])
          .map(
            (item) =>
                HomeBanner.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      categories: (json['categories'] as List? ?? const [])
          .map(
            (item) =>
                HomeCategory.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      featuredProducts:
          (json['featuredProducts'] as List? ??
                  json['featured'] as List? ??
                  const [])
              .map(
                (item) => HomeProduct.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      trendingProducts:
          (json['trendingProducts'] as List? ??
                  json['trending'] as List? ??
                  const [])
              .map(
                (item) => HomeProduct.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      recommendedProducts:
          (json['recommendedProducts'] as List? ??
                  json['recommended'] as List? ??
                  const [])
              .map(
                (item) => HomeProduct.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      newArrivals: (json['newArrivals'] as List? ?? const [])
          .map(
            (item) =>
                HomeProduct.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      recentlyViewedProducts:
          (json['recentlyViewedProducts'] as List? ?? const [])
              .map(
                (item) => HomeProduct.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
    );
  }

  HomePageData toDomain() {
    return HomePageData(
      banners: banners,
      categories: categories,
      featuredProducts: featuredProducts,
      trendingProducts: trendingProducts,
      recommendedProducts: recommendedProducts,
      newArrivals: newArrivals,
      recentlyViewedProducts: recentlyViewedProducts,
    );
  }
}
