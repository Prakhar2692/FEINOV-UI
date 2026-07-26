import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/product_filter_controller.dart';

class ProductFilterBottomSheet extends ConsumerWidget {
  const ProductFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      title: 'Filters',
      child: const ProductFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterControllerProvider);
    final notifier = ref.read(productFilterControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Sort By'),
        _buildSortOptions(context, filter.sortBy, notifier),
        const Divider(height: AppSpacing.xl),
        
        /* 
        _buildSectionTitle(context, 'Skin Type'),
        _buildChipFilter(
          options: ['Normal', 'Dry', 'Oily', 'Combination', 'Sensitive'],
          selectedOptions: filter.skinTypes,
          onToggle: notifier.toggleSkinType,
        ),
        const Divider(height: AppSpacing.xl),

        _buildSectionTitle(context, 'Concern'),
        _buildChipFilter(
          options: ['Acne', 'Aging', 'Brightening', 'Hydration', 'Pores', 'Redness'],
          selectedOptions: filter.concerns,
          onToggle: notifier.toggleConcern,
        ),
        const Divider(height: AppSpacing.xl),

        _buildSectionTitle(context, 'Ingredients'),
        _buildChipFilter(
          options: ['Retinol', 'Vitamin C', 'Hyaluronic Acid', 'Niacinamide', 'Salicylic Acid'],
          selectedOptions: filter.ingredients,
          onToggle: notifier.toggleIngredient,
        ),
        const Divider(height: AppSpacing.xl),
        */

        _buildSectionTitle(context, 'Price Range'),
        RangeSlider(
          values: RangeValues(filter.minPrice, filter.maxPrice),
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: AppColors.primary,
          labels: RangeLabels('\$${filter.minPrice.round()}', '\$${filter.maxPrice.round()}'),
          onChanged: (values) {
            notifier.setPriceRange(values.start, values.end);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$0', style: Theme.of(context).textTheme.bodySmall),
              Text('\$1000+', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Reset',
                isOutlined: true,
                onPressed: () {
                  notifier.resetFilter();
                },
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: AppButton(
                text: 'Apply Filters',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSortOptions(BuildContext context, String currentSort, ProductFilterController notifier) {
    final options = {
      'newest': 'Newest',
      'price_low': 'Price: Low to High',
      'price_high': 'Price: High to Low',
      'rating': 'Popularity',
    };

    return Wrap(
      spacing: AppSpacing.s,
      children: options.entries.map((entry) {
        final isSelected = currentSort == entry.key;
        return ChoiceChip(
          label: Text(entry.value),
          selected: isSelected,
          onSelected: (_) => notifier.setSortBy(entry.key),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipFilter({
    required List<String> options,
    required List<String> selectedOptions,
    required Function(String) onToggle,
  }) {
    return Wrap(
      spacing: AppSpacing.s,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => onToggle(option),
          selectedColor: AppColors.primary,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        );
      }).toList(),
    );
  }
}
