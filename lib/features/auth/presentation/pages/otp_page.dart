import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controllers/otp_controller.dart';

class OtpPage extends HookConsumerWidget {
  final String mobileNumber;

  const OtpPage({
    super.key,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = useTextEditingController();
    final focusNode = useFocusNode();
    final timerSeconds = ref.watch(otpTimerProvider);
    final verificationState = ref.watch(otpVerificationControllerProvider);

    useEffect(() {
      Future.microtask(() => ref.read(otpTimerProvider.notifier).startTimer());
      return null;
    }, []);

    ref.listen(otpVerificationControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        data: (_) {
          if (previous is AsyncLoading) {
            // Check if it was a verification or resend
            // For now assume verification success leads to home
            context.go('/home');
          }
        },
      );
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
      color: AppColors.surface,
    );

    return Scaffold(
      appBar: const AppTopBar(title: 'Verify OTP'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: ResponsiveLayout(
              mobile: _buildContent(
                context,
                otpController,
                focusNode,
                timerSeconds,
                verificationState.isLoading,
                ref,
                defaultPinTheme,
                focusedPinTheme,
              ),
              desktop: SizedBox(
                width: 450,
                child: _buildContent(
                  context,
                  otpController,
                  focusNode,
                  timerSeconds,
                  verificationState.isLoading,
                  ref,
                  defaultPinTheme,
                  focusedPinTheme,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TextEditingController otpController,
    FocusNode focusNode,
    int timerSeconds,
    bool isLoading,
    WidgetRef ref,
    PinTheme defaultPinTheme,
    PinTheme focusedPinTheme,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Verification Code',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.s),
        Text(
          'We have sent a 6-digit code to\n$mobileNumber',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Pinput(
          length: 6,
          controller: otpController,
          focusNode: focusNode,
          autofocus: true,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (pin) {
            ref.read(otpVerificationControllerProvider.notifier).verifyOtp(pin);
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Didn't receive the code? "),
            if (timerSeconds > 0)
              Text(
                'Resend in ${timerSeconds}s',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            else
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        ref
                            .read(otpVerificationControllerProvider.notifier)
                            .resendOtp(mobileNumber);
                      },
                child: const Text('Resend OTP'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(
          text: 'Verify',
          isLoading: isLoading,
          onPressed: () {
            if (otpController.text.length == 6) {
              ref
                  .read(otpVerificationControllerProvider.notifier)
                  .verifyOtp(otpController.text);
            }
          },
        ),
      ],
    );
  }
}
