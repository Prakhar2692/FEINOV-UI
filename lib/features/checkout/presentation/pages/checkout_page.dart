import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../profile/presentation/controllers/address_controller.dart';
import '../controllers/checkout_controller.dart';
import '../../../profile/domain/models/address.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutControllerProvider);
    final checkoutNotifier = ref.read(checkoutControllerProvider.notifier);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    // Set default address if none selected
    ref.listen(addressControllerProvider, (previous, next) {
      if (checkoutState.selectedAddress == null && next.hasValue && next.value!.isNotEmpty) {
        final defaultAddr = next.value?.firstWhere((a) => a.isDefault, orElse: () => next.value!.first);
        if (defaultAddr != null) {
          checkoutNotifier.selectAddress(defaultAddr);
        }
      }
    });

    return Scaffold(
      appBar: const AppTopBar(title: 'Checkout'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          _SectionTitle(
            title: 'Shipping Address',
            actionText: 'Change',
            onAction: () async {
              final result = await context.push(
                '/addresses',
                extra: {'isSelection': true},
              );
              if (result != null && result is Address) {
                checkoutNotifier.selectAddress(result);
              }
            },
          ),
          _AddressSection(address: checkoutState.selectedAddress),
          const SizedBox(height: AppSpacing.xl),
          
          const _SectionTitle(title: 'Payment Method'),
          _PaymentMethodsSection(
            selectedMethod: checkoutState.selectedPaymentMethod,
            onChanged: (method) => checkoutNotifier.selectPaymentMethod(method!),
          ),
          const SizedBox(height: AppSpacing.xl),

          const _SectionTitle(title: 'Order Summary'),
          _OrderSummarySection(
            subtotal: cartNotifier.subtotal,
            shipping: 5.0,
            total: cartNotifier.total,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
      bottomNavigationBar: _StickyPlaceOrderBar(
        total: cartNotifier.total,
        isLoading: checkoutState.isPlacingOrder,
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final goRouter = GoRouter.of(context);
          
          final success = await checkoutNotifier.placeOrder();
          
          if (success) {
             messenger.showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
            goRouter.go('/home');
          } else {
            messenger.showSnackBar(
              const SnackBar(content: Text('Please select an address')),
            );
          }
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionTitle({required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (actionText != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  final Address? address;
  const _AddressSection({this.address});

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Text('No address selected'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${address!.addressLine1}, ${address!.city}'),
            Text('${address!.state} - ${address!.zipCode}'),
            const SizedBox(height: 4),
            Text(address!.phoneNumber, style: const TextStyle(color: AppColors.hint)),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodsSection extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod?> onChanged;

  const _PaymentMethodsSection({required this.selectedMethod, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.upi,
            groupValue: selectedMethod,
            onChanged: onChanged,
            title: const Text('UPI'),
            secondary: const Icon(Icons.account_balance_wallet_outlined),
          ),
          const Divider(height: 1, indent: 56),
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.creditCard,
            groupValue: selectedMethod,
            onChanged: onChanged,
            title: const Text('Credit Card'),
            secondary: const Icon(Icons.credit_card_outlined),
          ),
          const Divider(height: 1, indent: 56),
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.debitCard,
            groupValue: selectedMethod,
            onChanged: onChanged,
            title: const Text('Debit Card'),
            secondary: const Icon(Icons.credit_card),
          ),
        ],
      ),
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const _OrderSummarySection({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            _SummaryRow(label: 'Order Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _SummaryRow(label: 'Shipping Charges', value: '\$${shipping.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            const _SummaryRow(label: 'Estimated Tax', value: '\$0.00'),
            const Divider(height: 24),
            _SummaryRow(
              label: 'Total Amount',
              value: '\$${total.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final style = isBold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _StickyPlaceOrderBar extends StatelessWidget {
  final double total;
  final bool isLoading;
  final VoidCallback onPressed;

  const _StickyPlaceOrderBar({
    required this.total,
    required this.isLoading,
    required this.onPressed,
  });

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
            Expanded(
              child: Column(
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
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              flex: 2,
              child: AppButton(
                text: 'PLACE ORDER',
                isLoading: isLoading,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
