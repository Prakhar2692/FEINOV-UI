import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_product_card.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/cart_badge.dart';
import '../controllers/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // Top Search Bar
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              centerTitle: false,
              title: Text(
                'FEINOV',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                const CartBadge(),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    0,
                    AppSpacing.l,
                    AppSpacing.m,
                  ),
                  child: AppTextField(
                    hint: 'Search products, brands...',
                    prefixIcon: const Icon(Icons.search),
                    readOnly: true,
                    onTap: () => context.push('/search'),
                  ),
                ),
              ),
            ),

            ...homeState.when(
              loading: () => [const _HomeLoadingSliver()],
              error: (err, stack) => [
                SliverFillRemaining(
                  child: Center(child: Text('Error: $err')),
                ),
              ],
              data: (data) => [
                // Banners
                SliverToBoxAdapter(
                  child: _BannerCarousel(banners: data.banners),
                ),

                // Categories
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _SectionHeader(title: 'Shop by Category', onSeeAll: () {}),
                      _CategoryList(categories: data.categories),
                    ],
                  ),
                ),

                // Best Sellers
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _SectionHeader(title: 'Best Sellers', onSeeAll: () {}),
                      _ProductHorizontalList(products: data.bestSellers),
                    ],
                  ),
                ),

                // New Arrivals
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _SectionHeader(title: 'New Arrivals', onSeeAll: () {}),
                      _ProductHorizontalList(products: data.newArrivals),
                    ],
                  ),
                ),

                // Trending
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _SectionHeader(title: 'Trending Products', onSeeAll: () {}),
                      _ProductHorizontalList(products: data.trending),
                    ],
                  ),
                ),

                // Featured
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _SectionHeader(title: 'Featured Collections', onSeeAll: () {}),
                      _FeaturedProducts(products: data.featured),
                    ],
                  ),
                ),

                // Recommended Header
                SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Recommended for You', onSeeAll: () {}),
                ),

                // Recommended Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: AppSpacing.m,
                      mainAxisSpacing: AppSpacing.m,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = data.recommended[index];
                        return AppProductCard(
                          product: product,
                          brand: 'Feinov Premium',
                          onTap: () => context.push('/product-details/${product.id}'),
                        );
                      },
                      childCount: data.recommended.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xl, AppSpacing.l, AppSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'See All',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  final List<String> banners;
  const _BannerCarousel({required this.banners});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(banners[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<String> categories;
  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.spa_outlined, color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductHorizontalList extends StatelessWidget {
  final List<dynamic> products;
  const _ProductHorizontalList({required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 190,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child: AppProductCard(
                product: product,
                brand: 'Feinov',
                onTap: () => context.push('/product-details/${product.id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedProducts extends StatelessWidget {
  final List<dynamic> products;
  const _FeaturedProducts({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products.map((product) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppSpacing.radiusL)),
                child: Image.network(product.imageUrl, width: 140, height: 140, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'FEATURED',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.secondary,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product.price}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _HomeLoadingSliver extends StatelessWidget {
  const _HomeLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: AppShimmer(width: double.infinity, height: 200),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xl, AppSpacing.l, AppSpacing.m),
          child: AppShimmer(width: 200, height: 24),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            itemCount: 5,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child: Column(
                children: [
                  AppShimmer(width: 70, height: 70, borderRadius: 35),
                  SizedBox(height: 8),
                  AppShimmer(width: 50, height: 12),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xl, AppSpacing.l, AppSpacing.m),
          child: AppShimmer(width: 150, height: 24),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            itemCount: 3,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child: SizedBox(
                width: 190,
                child: AppProductShimmer(),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
