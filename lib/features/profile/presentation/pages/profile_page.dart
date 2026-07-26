import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Profile', showBackButton: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          const _ProfileHeader(),
          const SizedBox(height: AppSpacing.xl),
          _ProfileMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            onTap: () => context.push('/addresses'),
          ),
          _ProfileMenuItem(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
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
  const _ProfileHeader();

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'john.doe@example.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.hint),
            ),
          ],
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
