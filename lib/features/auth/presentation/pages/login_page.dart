import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/auth_state.dart';
import '../controllers/login_controller.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final mobileController = useTextEditingController();
    final countryCode = useState('91');
    useListenable(mobileController);

    final loginState = ref.watch(loginControllerProvider);
    final authState = ref.watch(authControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        data: (_) {
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Sent Successfully')),
            );
            context.push(
              '/otp',
              extra: '+${countryCode.value}${mobileController.text}',
            );
          }
        },
      );
    });

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isAuthenticated) {
        final redirectTarget = GoRouter.of(
          context,
        ).state.uri.queryParameters['redirect'];
        context.go(AppRoutes.resolveRedirectAfterAuth(redirectTarget));
      }
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: ResponsiveLayout(
        mobile: _buildLoginForm(
          context,
          formKey,
          mobileController,
          countryCode,
          loginState.isLoading,
          authState,
          ref,
        ),
        desktop: Center(
          child: SizedBox(
            width: 400,
            child: _buildLoginForm(
              context,
              formKey,
              mobileController,
              countryCode,
              loginState.isLoading,
              authState,
              ref,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController mobileController,
    ValueNotifier<String> countryCode,
    bool isLoading,
    dynamic authState,
    WidgetRef ref,
  ) {
    final isFormValid = mobileController.text.trim().length >= 10;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.m),
          Text(
            'Welcome back',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Enter your mobile number to receive an OTP',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SizedBox(height: AppSpacing.m),
          AppButton(
            text: 'Continue as Guest',
            isOutlined: true,
            onPressed: () => context.go('/home'),
          ),
          const SizedBox(height: AppSpacing.l),
          const Divider(),
          const SizedBox(height: AppSpacing.l),
          Text('Mobile Number', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      countryCode.value = country.phoneCode;
                    },
                  );
                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                  ),
                  child: Center(
                    child: Text(
                      '+${countryCode.value}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 10) return 'Invalid number';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: 'Continue with OTP',
            isLoading: isLoading,
            onPressed: isFormValid
                ? () {
                    final trimmedNumber = mobileController.text.trim();
                    final isValid = formKey.currentState?.validate() ?? false;

                    if (!isValid) return;

                    if (trimmedNumber.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mobile number must be 10 digits'),
                        ),
                      );
                      return;
                    }

                    ref
                        .read(loginControllerProvider.notifier)
                        .sendOtp(
                          countryCode: countryCode.value,
                          mobileNumber: trimmedNumber,
                        );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
