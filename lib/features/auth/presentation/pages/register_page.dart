import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final mobileController = useTextEditingController();
    final countryCode = useState('91');
    useListenable(
      Listenable.merge([
        firstNameController,
        lastNameController,
        emailController,
        mobileController,
      ]),
    );

    final registerState = ref.watch(registerControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: ResponsiveLayout(
        mobile: _buildRegisterForm(
          context,
          formKey,
          firstNameController,
          lastNameController,
          emailController,
          mobileController,
          countryCode,
          registerState.isLoading,
          ref,
        ),
        desktop: Center(
          child: SizedBox(
            width: 400,
            child: _buildRegisterForm(
              context,
              formKey,
              firstNameController,
              lastNameController,
              emailController,
              mobileController,
              countryCode,
              registerState.isLoading,
              ref,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController mobileController,
    ValueNotifier<String> countryCode,
    bool isLoading,
    WidgetRef ref,
  ) {
    final nameFormatter = FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z]'),
    );

    final isFormValid =
        firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(emailController.text.trim()) &&
        mobileController.text.trim().length >= 10;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'First Name',
                  hint: 'Enter first name',
                  controller: firstNameController,
                  inputFormatters: [nameFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: AppTextField(
                  label: 'Last Name',
                  hint: 'Enter last name',
                  controller: lastNameController,
                  inputFormatters: [nameFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          AppTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) return 'Invalid email format';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.m),
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
                    onSelect: (Country country) =>
                        countryCode.value = country.phoneCode,
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
                  child: Center(child: Text('+${countryCode.value}')),
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
            text: 'Sign Up',
            isLoading: isLoading,
            onPressed: isFormValid
                ? () {
                    final firstName = firstNameController.text.trim();
                    final lastName = lastNameController.text.trim();
                    final email = emailController.text.trim();
                    final mobile = mobileController.text.trim();

                    if (firstName.isEmpty || lastName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'First name and last name are required',
                          ),
                        ),
                      );
                      return;
                    }

                    if (email.isEmpty ||
                        !RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a valid email address'),
                        ),
                      );
                      return;
                    }

                    if (mobile.isEmpty || mobile.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Mobile number must be at least 10 digits',
                          ),
                        ),
                      );
                      return;
                    }

                    if (formKey.currentState?.validate() ?? false) {
                      ref
                          .read(registerControllerProvider.notifier)
                          .register(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: '',
                            countryCode: countryCode.value,
                            mobileNumber: mobile,
                          );
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
