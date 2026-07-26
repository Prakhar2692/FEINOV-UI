import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../theme/app_colors.dart';

class CartBadge extends ConsumerWidget {
  final Color? iconColor;

  const CartBadge({super.key, this.iconColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final count = cartState.when(
      data: (items) => items.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: iconColor),
          onPressed: () => context.push('/cart'),
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
