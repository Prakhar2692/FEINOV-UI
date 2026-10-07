import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/features/home/domain/models/home_models.dart';

void main() {
  group('Home models', () {
    test('HomePageData.fromJson maps API data into home sections', () {
      final data = HomePageData.fromJson({
        'banners': [
          {'id': 'b1', 'title': 'Summer Glow', 'imageUrl': 'https://example.com/banner-1.jpg'},
        ],
        'categories': [
          {'id': 'c1', 'name': 'Skincare', 'imageUrl': 'https://example.com/c1.jpg'},
        ],
        'featuredProducts': [
          {
            'id': 'p1',
            'name': 'Hydra Serum',
            'description': 'Deep hydration serum',
            'price': 49.0,
            'imageUrl': 'https://example.com/p1.jpg',
            'rating': 4.8,
            'reviewCount': 120,
            'isFeatured': true,
            'isRecommended': true,
          },
        ],
        'trendingProducts': [
          {
            'id': 'p2',
            'name': 'Repair Cream',
            'description': 'Daily repair cream',
            'price': 39.0,
            'imageUrl': 'https://example.com/p2.jpg',
            'rating': 4.7,
            'reviewCount': 95,
            'isTrending': true,
          },
        ],
      });

      expect(data.banners.first.title, 'Summer Glow');
      expect(data.categories.first.name, 'Skincare');
      expect(data.featuredProducts.first.id, 'p1');
      expect(data.trendingProducts.first.id, 'p2');
      expect(data.recommendedProducts.isEmpty, isTrue);
    });

    test('HomeProduct.toProduct converts to the shared Product model', () {
      final product = HomeProduct(
        id: 'p3',
        name: 'Cleansing Foam',
        description: 'Gentle daily cleanser',
        price: 28.0,
        imageUrl: 'https://example.com/foam.jpg',
        rating: 4.9,
        reviewCount: 210,
      );

      final mapped = product.toProduct();

      expect(mapped.id, 'p3');
      expect(mapped.name, 'Cleansing Foam');
      expect(mapped.price, 28.0);
      expect(mapped.imageUrl, 'https://example.com/foam.jpg');
    });
  });
}
