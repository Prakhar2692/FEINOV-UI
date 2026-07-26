import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/address_controller.dart';
import '../../domain/models/address.dart';

class AddAddressPage extends HookConsumerWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final address1Controller = useTextEditingController();
    final address2Controller = useTextEditingController();
    final landmarkController = useTextEditingController();
    final cityController = useTextEditingController();
    final stateController = useTextEditingController();
    final pincodeController = useTextEditingController();
    final isDefault = useState(false);
    final label = useState('Home');

    return Scaffold(
      appBar: const AppTopBar(title: 'Add New Address'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: nameController,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Phone Number',
                hint: 'Enter 10-digit mobile number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length < 10) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Address Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Address Line 1',
                hint: 'House No, Building, Street',
                controller: address1Controller,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Address Line 2',
                hint: 'Area, Locality',
                controller: address2Controller,
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Landmark',
                hint: 'Near by famous place (Optional)',
                controller: landmarkController,
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'City',
                      hint: 'Enter city',
                      controller: cityController,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: AppTextField(
                      label: 'State',
                      hint: 'Enter state',
                      controller: stateController,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Pincode',
                hint: 'Enter 6-digit pincode',
                controller: pincodeController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length < 6) return 'Invalid pincode';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Save As',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.s),
              Wrap(
                spacing: AppSpacing.m,
                children: ['Home', 'Office', 'Other'].map((l) {
                  final isSelected = label.value == l;
                  return ChoiceChip(
                    label: Text(l),
                    selected: isSelected,
                    onSelected: (_) => label.value = l,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.primary),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.m),
              SwitchListTile(
                title: const Text('Set as Default Address'),
                value: isDefault.value,
                onChanged: (val) => isDefault.value = val,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: AppButton(
            text: 'SAVE ADDRESS',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final newAddress = Address(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  addressLine1: address1Controller.text,
                  addressLine2: address2Controller.text.isNotEmpty ? address2Controller.text : null,
                  landmark: landmarkController.text.isNotEmpty ? landmarkController.text : null,
                  city: cityController.text,
                  state: stateController.text,
                  zipCode: pincodeController.text,
                  country: 'India',
                  isDefault: isDefault.value,
                  label: label.value,
                );
                ref.read(addressControllerProvider.notifier).addAddress(newAddress);
                context.pop();
              }
            },
          ),
        ),
      ),
    );
  }
}
