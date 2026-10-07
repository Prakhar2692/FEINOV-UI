import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../domain/models/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _profile = UserProfile(
    id: 'u_1',
    firstName: 'Aditi',
    lastName: 'Sharma',
    email: 'aditi@example.com',
    phone: '+91 98765 43210',
    addresses: [
      Address(
        id: 'a1',
        label: 'Home',
        street: '24 Residency Road',
        city: 'Bengaluru',
        state: 'Karnataka',
        country: 'India',
        postalCode: '560025',
        isDefault: true,
      ),
      Address(
        id: 'a2',
        label: 'Office',
        street: '7th Floor, Brigade Tech Park',
        city: 'Bengaluru',
        state: 'Karnataka',
        country: 'India',
        postalCode: '560066',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Profile', showBackButton: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          const _ProfileHeader(profile: _profile),
          const SizedBox(height: AppSpacing.xl),
          _ProfileMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            onTap: () => context.push('/addresses'),
          ),
          _ProfileMenuItem(
            icon: Icons.favorite_border,
            title: 'Wishlist',
            onTap: () => context.push('/wishlist'),
          ),
          _ProfileMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            onTap: () => context.push('/orders'),
          ),
          _ProfileMenuItem(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          const Divider(height: AppSpacing.xxl),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacy mode'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          const Divider(height: AppSpacing.xxl),
          _ProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            titleColor: AppColors.error,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surfaceVariant,
          child: Icon(Icons.person, size: 40, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profile.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.hint),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                profile.phone ?? 'No phone added',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.hint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
