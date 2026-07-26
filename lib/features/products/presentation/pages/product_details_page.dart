import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../controllers/product_details_controller.dart';
import '../../../home/domain/models/product.dart';

class ProductDetailsPage extends HookConsumerWidget {
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productDetailsControllerProvider(productId));
    final selectedVariant = useState<String?>(null);

    return productState.when(
      loading: () => const Scaffold(body: Center(child: AppLoadingIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (product) {
        if (selectedVariant.value == null && product.variants.isNotEmpty) {
          selectedVariant.value = product.variants.first;
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // 1. Image Carousel (SliverAppBar)
              _ImageCarouselSliver(images: product.images),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Title & Wishlist
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FEINOV PREMIUM',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.secondary,
                                        letterSpacing: 2,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Georgia',
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              product.isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: product.isWishlisted ? AppColors.error : AppColors.primary,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 3. Ratings
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${product.reviewCount} Reviews)',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.hint),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 4. Price Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.hint,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(((product.originalPrice! - product.price) / product.originalPrice!) * 100).round()}% OFF',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 5. Variant Selector
                      if (product.variants.isNotEmpty) ...[
                        Text('Select Size', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: product.variants.map((variant) {
                            final isSelected = selectedVariant.value == variant;
                            return ChoiceChip(
                              label: Text(variant),
                              selected: isSelected,
                              onSelected: (_) => selectedVariant.value = variant,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.primary),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusM)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const Divider(),
                      const SizedBox(height: 24),

                      // 6. Description
                      _ExpandableSection(
                        title: 'Description',
                        content: Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
                        isInitiallyExpanded: true,
                      ),

                      // 7. Benefits
                      if (product.benefits.isNotEmpty)
                        _ExpandableSection(
                          title: 'Benefits',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: product.benefits.map((b) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, color: AppColors.primaryLight, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(b, style: Theme.of(context).textTheme.bodyMedium)),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),

                      // 8. What makes it special?
                      if (product.specialFeatures != null)
                        _ExpandableSection(
                          title: 'What makes it Special?',
                          content: Text(product.specialFeatures!, style: Theme.of(context).textTheme.bodyMedium),
                        ),

                      // 9. Key Ingredients
                      if (product.ingredients.isNotEmpty)
                        _ExpandableSection(
                          title: 'Key Ingredients',
                          content: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: product.ingredients.map((i) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                              ),
                              child: Text(i, style: Theme.of(context).textTheme.bodySmall),
                            )).toList(),
                          ),
                        ),

                      // 10. How to use
                      if (product.usageInstructions != null)
                        _ExpandableSection(
                          title: 'How to use',
                          content: Text(product.usageInstructions!, style: Theme.of(context).textTheme.bodyMedium),
                        ),

                      // 11. Product Information
                      if (product.productInfo.isNotEmpty)
                        _ExpandableSection(
                          title: 'Product Information',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: product.productInfo.map((info) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: AppColors.secondary, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(info, style: Theme.of(context).textTheme.bodyMedium)),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),

                      // 12. Reviews & Ratings Placeholder
                      _ExpandableSection(
                        title: 'Reviews',
                        content: Column(
                          children: [
                            const _RatingSummaryWidget(),
                            const SizedBox(height: 16),
                            AppButton(text: 'Write a Review', isOutlined: true, onPressed: () {}),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100), // Spacing for sticky bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _StickyBottomBar(product: product),
        );
      },
    );
  }
}

class _ImageCarouselSliver extends StatelessWidget {
  final List<String> images;

  const _ImageCarouselSliver({required this.images});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.share, color: Colors.black),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _ExpandableSection extends HookWidget {
  final String title;
  final Widget content;
  final bool isInitiallyExpanded;

  const _ExpandableSection({
    required this.title,
    required this.content,
    this.isInitiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(isInitiallyExpanded);

    return Column(
      children: [
        InkWell(
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(isExpanded.value ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (isExpanded.value) ...[
          const SizedBox(height: 8),
          content,
          const SizedBox(height: 16),
        ],
        const Divider(),
      ],
    );
  }
}

class _StickyBottomBar extends StatelessWidget {
  final Product product;

  const _StickyBottomBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'ADD TO CART',
                isOutlined: true,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: 'BUY NOW',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingSummaryWidget extends StatelessWidget {
  const _RatingSummaryWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '4.8',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text('256 Ratings', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(context, '5', 0.8),
                _buildRatingBar(context, '4', 0.15),
                _buildRatingBar(context, '3', 0.03),
                _buildRatingBar(context, '2', 0.01),
                _buildRatingBar(context, '1', 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
