import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../../features/home/domain/models/product.dart';

class AppProductCard extends StatelessWidget {
  final Product product;
  final String brand;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onAddToCartTap;

  const AppProductCard({
    super.key,
    required this.product,
    this.brand = 'FEINOV',
    required this.onTap,
    this.onWishlistTap,
    this.onAddToCartTap,
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
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: onAddToCartTap,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
