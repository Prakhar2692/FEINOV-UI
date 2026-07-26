import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_product_card.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/search_controller.dart' as search_ctrl;

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(search_ctrl.searchControllerProvider);
    final searchNotifier = ref.read(search_ctrl.searchControllerProvider.notifier);
    final searchController = useTextEditingController(text: searchState.query);
    final scrollController = useScrollController();

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          searchNotifier.loadMore();
        }
      });
      return null;
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.m),
            child: AppTextField(
              controller: searchController,
              hint: 'Search for products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchState.query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        searchNotifier.onQueryChanged('');
                      },
                    )
                  : null,
              onChanged: (value) => searchNotifier.onQueryChanged(value),
              onSubmitted: (value) => searchNotifier.search(value),
            ),
          ),
        ),
      ),
      body: _buildBody(context, searchState, searchNotifier, searchController, scrollController),
    );
  }

  Widget _buildBody(
    BuildContext context,
    search_ctrl.SearchState state,
    search_ctrl.SearchController notifier,
    TextEditingController textController,
    ScrollController scrollController,
  ) {
    if (state.isLoading) {
      return const _SearchLoadingView();
    }

    if (state.results.isNotEmpty) {
      return _SearchResultsView(state: state, notifier: notifier, scrollController: scrollController);
    }

    if (state.suggestions.isNotEmpty && state.query.isNotEmpty) {
      return _SearchSuggestionsView(state: state, notifier: notifier, textController: textController);
    }

    return _InitialSearchView(state: state, notifier: notifier, textController: textController);
  }
}

class _InitialSearchView extends StatelessWidget {
  final search_ctrl.SearchState state;
  final search_ctrl.SearchController notifier;
  final TextEditingController textController;

  const _InitialSearchView({
    required this.state,
    required this.notifier,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        if (state.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () => notifier.clearRecent(),
                child: const Text('Clear All'),
              ),
            ],
          ),
          Wrap(
            spacing: AppSpacing.s,
            children: state.recentSearches.map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () {
                  textController.text = search;
                  notifier.search(search);
                },
                backgroundColor: AppColors.surfaceVariant,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusCircular)),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        Text('Popular Searches', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.m),
        Wrap(
          spacing: AppSpacing.s,
          children: state.popularSearches.map((search) {
            return ActionChip(
              label: Text(search),
              onPressed: () {
                textController.text = search;
                notifier.search(search);
              },
              backgroundColor: AppColors.surfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusCircular)),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SearchSuggestionsView extends StatelessWidget {
  final search_ctrl.SearchState state;
  final search_ctrl.SearchController notifier;
  final TextEditingController textController;

  const _SearchSuggestionsView({
    required this.state,
    required this.notifier,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: state.suggestions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          leading: const Icon(Icons.history, size: 20),
          title: Text(suggestion),
          trailing: const Icon(Icons.north_west, size: 16),
          onTap: () {
            textController.text = suggestion;
            notifier.search(suggestion);
          },
        );
      },
    );
  }
}

class _SearchResultsView extends StatelessWidget {
  final search_ctrl.SearchState state;
  final search_ctrl.SearchController notifier;
  final ScrollController scrollController;

  const _SearchResultsView({
    required this.state,
    required this.notifier,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.l),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSpacing.m,
              mainAxisSpacing: AppSpacing.m,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = state.results[index];
                return AppProductCard(
                  imageUrl: product.imageUrl,
                  name: product.name,
                  brand: 'Feinov Premium',
                  price: product.price,
                  onTap: () {},
                );
              },
              childCount: state.results.length,
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

class _SearchLoadingView extends StatelessWidget {
  const _SearchLoadingView();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.l),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const AppProductShimmer(),
    );
  }
}
