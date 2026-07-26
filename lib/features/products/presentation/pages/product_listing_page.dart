import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_product_card.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../controllers/product_listing_controller.dart';
import '../widgets/product_filter_bottom_sheet.dart';

class ProductListingPage extends HookConsumerWidget {
  final String? categoryId;
  final String? subcategoryId;
  final String title;

  const ProductListingPage({
    super.key,
    this.categoryId,
    this.subcategoryId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final state = ref.watch(productListingControllerProvider(subcategoryId));
    final notifier = ref.read(productListingControllerProvider(subcategoryId).notifier);

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) {
          notifier.loadMore();
        }
      });
      return null;
    }, [scrollController]);

    return Scaffold(
      appBar: AppTopBar(
        title: title,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const _FilterSortBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notifier.fetchProducts(isRefresh: true),
              child: state.isLoading && state.products.isEmpty
                  ? const _LoadingGrid()
                  : _ProductGrid(
                      state: state,
                      notifier: notifier,
                      scrollController: scrollController,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSortBar extends StatelessWidget {
  const _FilterSortBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () => ProductFilterBottomSheet.show(context),
              icon: const Icon(Icons.sort, size: 20),
              label: const Text('Sort'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.divider),
          Expanded(
            child: TextButton.icon(
              onPressed: () => ProductFilterBottomSheet.show(context),
              icon: const Icon(Icons.filter_list, size: 20),
              label: const Text('Filter'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final ProductListingState state;
  final ProductListingController notifier;
  final ScrollController scrollController;

  const _ProductGrid({
    required this.state,
    required this.notifier,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.l),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: AppSpacing.m,
              mainAxisSpacing: AppSpacing.m,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = state.products[index];
                return AppProductCard(
                  product: product,
                  onTap: () => context.push('/product-details/${product.id}'),
                  onWishlistTap: () => notifier.toggleWishlist(product.id),
                  onAddToCartTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                  },
                );
              },
              childCount: state.products.length,
            ),
          ),
        ),
        if (state.isLoadMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xxl),
        ),
      ],
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.l),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const AppProductShimmer(),
    );
  }
}
