import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_product_card.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/cart_badge.dart';
import '../../../auth/application/auth_state.dart';
import '../../domain/models/home_models.dart';
import '../controllers/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final isLoggedIn = authState.isAuthenticated;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
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
              error: (error, stackTrace) => [
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 12),
                        Text('Unable to load home content'),
                        const SizedBox(height: 8),
                        Text('$error', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
              data: (data) => _buildHomeSections(context, data, isLoggedIn),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHomeSections(
    BuildContext context,
    HomePageData data,
    bool isLoggedIn,
  ) {
    final sectionProducts = isLoggedIn
        ? data.recommendedProducts
        : data.featuredProducts;

    return [
      if (data.banners.isNotEmpty)
        SliverToBoxAdapter(child: _BannerCarousel(banners: data.banners)),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.l,
            AppSpacing.l,
            AppSpacing.s,
          ),
          child: _OfferStrip(banners: data.banners),
        ),
      ),
      SliverToBoxAdapter(
        child: Column(
          children: [
            _SectionHeader(
              title: 'Shop by Category',
              onSeeAll: () => context.push('/categories'),
            ),
            _CategoryList(categories: data.categories),
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: Column(
          children: [
            _SectionHeader(
              title: 'Featured brands',
              onSeeAll: () => context.push('/categories'),
            ),
            _BrandStrip(),
          ],
        ),
      ),
      if (data.trendingProducts.isNotEmpty)
        SliverToBoxAdapter(
          child: Column(
            children: [
              _SectionHeader(
                title: 'Trending Products',
                onSeeAll: () => context.push('/products'),
              ),
              _ProductHorizontalList(products: data.trendingProducts),
            ],
          ),
        ),
      if (data.newArrivals.isNotEmpty)
        SliverToBoxAdapter(
          child: Column(
            children: [
              _SectionHeader(
                title: 'New Arrivals',
                onSeeAll: () => context.push('/products'),
              ),
              _ProductHorizontalList(products: data.newArrivals),
            ],
          ),
        ),
      if (data.featuredProducts.isNotEmpty)
        SliverToBoxAdapter(
          child: Column(
            children: [
              _SectionHeader(
                title: 'Featured Collections',
                onSeeAll: () => context.push('/products'),
              ),
              _FeaturedProducts(products: data.featuredProducts),
            ],
          ),
        ),
      if (data.recentlyViewedProducts.isNotEmpty)
        SliverToBoxAdapter(
          child: Column(
            children: [
              _SectionHeader(
                title: 'Recently viewed',
                onSeeAll: () => context.push('/products'),
              ),
              _ProductHorizontalList(products: data.recentlyViewedProducts),
            ],
          ),
        ),
      SliverToBoxAdapter(
        child: _SectionHeader(
          title: isLoggedIn ? 'Recommended for You' : 'Explore our picks',
          onSeeAll: () => context.push('/products'),
        ),
      ),
      if (sectionProducts.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text(
                isLoggedIn
                    ? 'No personalized picks yet.'
                    : 'No products available right now.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSpacing.m,
              mainAxisSpacing: AppSpacing.m,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = sectionProducts[index];
              final mapped = product.toProduct();
              return AppProductCard(
                product: mapped,
                brand: product.brand ?? 'FEINOV',
                onTap: () => context.push('/product-details/${product.id}'),
              );
            }, childCount: sectionProducts.length),
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.xl,
        AppSpacing.l,
        AppSpacing.m,
      ),
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
  final List<HomeBanner> banners;

  const _BannerCarousel({required this.banners});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: GestureDetector(
              onTap: () => banner.targetRoute != null
                  ? context.push(banner.targetRoute!)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                  image: DecorationImage(
                    image: NetworkImage(banner.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (banner.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          banner.subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OfferStrip extends StatelessWidget {
  const _OfferStrip({required this.banners});

  final List<HomeBanner> banners;

  @override
  Widget build(BuildContext context) {
    final promoCards = banners.take(3).toList();

    if (promoCards.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: promoCards.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
        itemBuilder: (context, index) {
          final banner = promoCards[index];
          return Container(
            width: 220,
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  banner.subtitle ?? 'Limited time offer',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<HomeCategory> categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: GestureDetector(
              onTap: () => context.push(
                '/products',
                extra: {'categoryId': category.id, 'title': category.name},
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: category.imageUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              category.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.spa_outlined,
                                    color: AppColors.primary,
                                    size: 28,
                                  ),
                            ),
                          )
                        : const Icon(
                            Icons.spa_outlined,
                            color: AppColors.primary,
                            size: 28,
                          ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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

class _BrandStrip extends StatelessWidget {
  const _BrandStrip();

  @override
  Widget build(BuildContext context) {
    final brands = ['FEINOV', 'AELIA', 'LUMA', 'NOVA'];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return Container(
            width: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              brand,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductHorizontalList extends StatelessWidget {
  final List<HomeProduct> products;

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
          final mapped = product.toProduct();
          return SizedBox(
            width: 190,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child: AppProductCard(
                product: mapped,
                brand: product.brand ?? 'FEINOV',
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
  final List<HomeProduct> products;

  const _FeaturedProducts({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products
          .map(
            (product) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.s,
              ),
              child: GestureDetector(
                onTap: () => context.push('/product-details/${product.id}'),
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
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(AppSpacing.radiusL),
                        ),
                        child: Image.network(
                          product.imageUrl,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_outlined),
                        ),
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
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.secondary,
                                      letterSpacing: 2,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
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
          padding: EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.xl,
            AppSpacing.l,
            AppSpacing.m,
          ),
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
          padding: EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.xl,
            AppSpacing.l,
            AppSpacing.m,
          ),
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
              child: SizedBox(width: 190, child: AppProductShimmer()),
            ),
          ),
        ),
      ]),
    );
  }
}
