import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'login_page.dart';
import 'register_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxl),
            // Logo or Branding
            const Icon(
              Icons.spa_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'FEINOV',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    letterSpacing: 4,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                ),
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                  ),
                  labelColor: AppColors.onPrimary,
                  unselectedLabelColor: AppColors.primary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Sign Up'),
                  ],
                ),
              ),
            ),
            // Tab View
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  LoginPage(),
                  RegisterPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
