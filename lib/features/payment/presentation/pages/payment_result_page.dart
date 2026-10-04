import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/payment_controller.dart';

class PaymentResultPage extends ConsumerWidget {
  const PaymentResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIcon(paymentState.status),
              const SizedBox(height: AppSpacing.xl),
              Text(
                _getTitle(paymentState.status),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getColor(paymentState.status),
                    ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                paymentState.message ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (paymentState.paymentId != null) ...[
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Payment ID: ${paymentState.paymentId}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.hint),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                text: paymentState.status == PaymentStatus.success ? 'CONTINUE SHOPPING' : 'TRY AGAIN',
                onPressed: () {
                  ref.read(paymentControllerProvider.notifier).reset();
                  if (paymentState.status == PaymentStatus.success) {
                    context.go('/home');
                  } else {
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(PaymentStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case PaymentStatus.success:
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case PaymentStatus.failure:
      case PaymentStatus.cancelled:
        icon = Icons.error_outline;
        color = AppColors.error;
        break;
      default:
        icon = Icons.payment;
        color = AppColors.primary;
    }

    return Icon(icon, size: 100, color: color);
  }

  String _getTitle(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return 'Payment Successful';
      case PaymentStatus.failure:
        return 'Payment Failed';
      case PaymentStatus.cancelled:
        return 'Payment Cancelled';
      default:
        return 'Processing Payment';
    }
  }

  Color _getColor(PaymentStatus status) {
    if (status == PaymentStatus.success) return Colors.green;
    if (status == PaymentStatus.failure || status == PaymentStatus.cancelled) return AppColors.error;
    return AppColors.primary;
  }
}
