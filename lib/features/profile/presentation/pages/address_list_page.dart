import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../controllers/address_controller.dart';
import '../../domain/models/address.dart';

class AddressListPage extends ConsumerWidget {
  final bool isSelectionMode;

  const AddressListPage({
    super.key,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressControllerProvider);
    final notifier = ref.read(addressControllerProvider.notifier);

    return Scaffold(
      appBar: const AppTopBar(
        title: 'Saved Addresses',
      ),
      body: addressState.when(
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (addresses) {
          if (addresses.isEmpty) {
            return _EmptyAddressView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _AddressCard(
                address: address,
                isSelectionMode: isSelectionMode,
                onTap: () {
                  if (isSelectionMode) {
                    context.pop(address);
                  }
                },
                onDelete: () => notifier.removeAddress(address.id),
                onSetDefault: () => notifier.setDefault(address.id),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: AppButton(
            text: 'ADD NEW ADDRESS',
            onPressed: () => context.push('/addresses/add'),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.isSelectionMode,
    required this.onTap,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                    ),
                    child: Text(
                      address.label.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (address.isDefault)
                    Text(
                      'DEFAULT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                address.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${address.addressLine1}${address.addressLine2 != null ? ", ${address.addressLine2}" : ""}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (address.landmark != null)
                Text(
                  'Landmark: ${address.landmark}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              Text(
                '${address.city}, ${address.state} - ${address.zipCode}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Phone: ${address.phoneNumber}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.hint),
              ),
              const Divider(height: 32),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {}, // Edit logic
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  ),
                  const Spacer(),
                  if (!address.isDefault)
                    TextButton(
                      onPressed: onSetDefault,
                      child: const Text('Set as Default'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined, size: 80, color: AppColors.divider),
          const SizedBox(height: AppSpacing.m),
          Text(
            'No addresses found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.s),
          const Text('Add an address to proceed with your orders.'),
        ],
      ),
    );
  }
}
