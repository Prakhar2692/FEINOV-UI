import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../domain/models/wishlist_item.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  static const _items = [
    WishlistItem(
      id: 'w1',
      productId: 'p1',
      name: 'Hydra Glow Serum',
      price: 980,
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=400&q=80',
    ),
    WishlistItem(
      id: 'w2',
      productId: 'p2',
      name: 'Barrier Repair Cream',
      price: 710,
      imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?auto=format&fit=crop&w=400&q=80',
    ),
    WishlistItem(
      id: 'w3',
      productId: 'p3',
      name: 'Cleansing Foam',
      price: 620,
      imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Scaffold(
        appBar: AppTopBar(title: 'Wishlist', showBackButton: false),
        body: Center(
          child: Text('No saved products yet'),
        ),
      );
    }

    return Scaffold(
      appBar: const AppTopBar(title: 'Wishlist', showBackButton: false),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.l),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.imageUrl ?? '',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 90,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Add to cart'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite, color: AppColors.error),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
