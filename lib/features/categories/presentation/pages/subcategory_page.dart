import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../controllers/subcategory_controller.dart';

class SubcategoryPage extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const SubcategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategoriesState = ref.watch(subcategoryControllerProvider(categoryId));

    return Scaffold(
      appBar: AppTopBar(
        title: categoryName,
      ),
      body: subcategoriesState.when(
        loading: () => const _SubcategoriesLoadingView(),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (subcategories) => RefreshIndicator(
          onRefresh: () => ref.read(subcategoryControllerProvider(categoryId).notifier).refresh(categoryId),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : constraints.maxWidth > 600
                      ? 3
                      : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.l),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: AppSpacing.m,
                  mainAxisSpacing: AppSpacing.m,
                ),
                itemCount: subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = subcategories[index];
                  return _SubcategoryCard(subcategory: subcategory);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SubcategoryCard extends StatelessWidget {
  final dynamic subcategory;

  const _SubcategoryCard({required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/products',
          extra: {
            'subcategoryId': subcategory.id,
            'title': subcategory.name,
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                child: Image.network(
                  subcategory.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.category_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            subcategory.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '${subcategory.productCount} Products',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _SubcategoriesLoadingView extends StatelessWidget {
  const _SubcategoriesLoadingView();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.l),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppShimmer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppSpacing.radiusL,
            ),
          ),
          SizedBox(height: AppSpacing.s),
          AppShimmer(width: 100, height: 16),
          SizedBox(height: 4),
          AppShimmer(width: 60, height: 12),
        ],
      ),
    );
  }
}
