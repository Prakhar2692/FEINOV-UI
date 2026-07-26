import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controllers/login_controller.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final mobileController = useTextEditingController();
    final countryCode = useState('91'); // Default to India

    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        data: (_) {
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Sent Successfully')),
            );
            // Navigate to OTP Verification screen or handle next step
          }
        },
      );
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
    WidgetRef ref,
  ) {
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
          Text(
            'Mobile Number',
            style: Theme.of(context).textTheme.labelLarge,
          ),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
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
            text: 'Continue',
            isLoading: isLoading,
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                ref.read(loginControllerProvider.notifier).sendOtp(
                      countryCode: countryCode.value,
                      mobileNumber: mobileController.text,
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}
