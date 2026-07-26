import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    return Scaffold(
      appBar: const AppTopBar(
        title: 'Shopping Cart',
        showBackButton: true,
      ),
      body: cartState.when(
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyCartView();
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => cartNotifier.refresh(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    children: [
                      ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.m),
                        child: CartItemTile(item: item),
                      )),
                      const SizedBox(height: AppSpacing.m),
                      _CouponSection(),
                      const SizedBox(height: AppSpacing.xl),
                      _CartSummary(
                        subtotal: cartNotifier.subtotal,
                        shipping: 5.0,
                        total: cartNotifier.total,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
              _StickyCheckoutBar(total: cartNotifier.total),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.divider),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.s),
          const Text('Start shopping for your favorite products!'),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: 200,
            child: AppButton(
              text: 'Shop Now',
              onPressed: () {
                // Navigate to home or shop
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promotions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: AppTextField(
                hint: 'Enter promo code',
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            SizedBox(
              width: 100,
              height: 56,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const _CartSummary({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Shipping', value: '\$${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Tax', value: '\$0.00'),
          const Divider(height: 32),
          _SummaryRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _StickyCheckoutBar extends StatelessWidget {
  final double total;

  const _StickyCheckoutBar({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Payable', style: Theme.of(context).textTheme.labelSmall),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: AppButton(
                text: 'PROCEED TO CHECKOUT',
                onPressed: () => context.push('/checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
