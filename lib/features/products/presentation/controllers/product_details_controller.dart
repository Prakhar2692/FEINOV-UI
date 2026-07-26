import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../home/domain/models/product.dart';

part 'product_details_controller.g.dart';

@riverpod
class ProductDetailsController extends _$ProductDetailsController {
  @override
  Future<Product> build(String productId) async {
    return _fetchProductDetails(productId);
  }

  Future<Product> _fetchProductDetails(String productId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return Product(
      id: productId,
      name: 'Hydrating Gentle Cleanser',
      description: 'A deeply hydrating cleanser that removes impurities while maintaining the skin\'s natural moisture barrier. Formulated with Hyaluronic Acid and Ceramides for a soft, clean feel.',
      price: 24.99,
      originalPrice: 35.00,
      rating: 4.8,
      reviewCount: 256,
      imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=600&auto=format&fit=crop',
      images: [
        'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?q=80&w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1596462502278-27bfac4033c8?q=80&w=600&auto=format&fit=crop',
      ],
      variants: ['100ml', '250ml', '500ml'],
      ingredients: ['Hyaluronic Acid', 'Ceramides', 'Glycerin', 'Aloe Vera'],
      benefits: [
        'Gentle on sensitive skin',
        'Deeply hydrating',
        'pH Balanced',
        'Non-comedogenic',
      ],
      specialFeatures: 'Features a unique blend of 3 essential ceramides and hyaluronic acid to lock in moisture and help maintain the skin’s natural protective barrier.',
      usageInstructions: 'Massage cleanser onto wet skin in a gentle, circular motion. Rinse well and pat dry. Use morning and night.',
      productInfo: [
        'Skin Type: Normal to Dry',
        'Key Concern: Hydration, Barrier Repair',
        'Format: Cream-to-foam',
        'Cruelty Free: Yes',
        'Vegan: Yes',
      ],
      isAvailable: true,
      isWishlisted: false,
    );
  }
}
