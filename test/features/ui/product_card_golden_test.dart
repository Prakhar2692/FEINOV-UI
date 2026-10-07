import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/widgets/app_product_card.dart';
import 'package:feinov_ui/features/home/domain/models/product.dart';

void main() {
  testWidgets('AppProductCard renders consistently', (tester) async {
    final product = Product(
      id: 'p_gold',
      name: 'Vitamin C Serum',
      description: 'Brightening daily serum',
      price: 49.0,
      imageUrl: 'https://example.com/serum.jpg',
      originalPrice: 69.0,
      rating: 4.8,
      reviewCount: 420,
      isAvailable: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 220,
              height: 320,
              child: AppProductCard(
                product: product,
                brand: 'FEINOV',
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(AppProductCard),
      matchesGoldenFile('goldens/app_product_card.png'),
    );
  });
}
