import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../../features/home/domain/models/product.dart';

class AppProductCard extends StatelessWidget {
  final Product product;
  final String brand;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;
  final ValueChanged<int>? onQuantityChanged;

  const AppProductCard({
    super.key,
    required this.product,
    this.brand = 'FEINOV',
    this.quantity = 0,
    required this.onTap,
    this.onWishlistTap,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.originalPrice != null && product.originalPrice! > product.price;
    final discountPercentage = hasDiscount 
        ? (((product.originalPrice! - product.price) / product.originalPrice!) * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.image_outlined, color: AppColors.primary, size: 40),
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: AppSpacing.s,
                      left: AppSpacing.s,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                        ),
                        child: Text(
                          '-$discountPercentage%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: AppSpacing.s,
                    right: AppSpacing.s,
                    child: IconButton(
                      icon: Icon(
                        product.isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: product.isWishlisted ? AppColors.error : AppColors.primary,
                      ),
                      onPressed: onWishlistTap,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        ' (${product.reviewCount})',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.hint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 4),
                        Text(
                          '\$${product.originalPrice!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.hint,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Logic to swap button with quantity selector
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: quantity > 0
                        ? _QuantitySelector(
                            key: ValueKey('qty_${product.id}'),
                            quantity: quantity,
                            onChanged: onQuantityChanged ?? (_) {},
                          )
                        : SizedBox(
                            key: ValueKey('add_${product.id}'),
                            width: double.infinity,
                            height: 32,
                            child: OutlinedButton(
                              onPressed: () => onQuantityChanged?.call(1),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                                ),
                              ),
                              child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () => onChanged(quantity - 1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () => onChanged(quantity + 1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
