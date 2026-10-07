import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loading_indicator.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final opacity = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    useEffect(() {
      opacity.forward();
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: opacity,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.spa_outlined,
                    size: 96,
                    color: AppColors.onPrimary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'FEINOV',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.onPrimary,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Luxury skincare, simplified.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const AppLoadingIndicator(color: AppColors.onPrimary),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Get started',
                          onPressed: () => context.go('/home'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/auth'),
                    child: const Text(
                      'Already a customer?',
                      style: TextStyle(color: AppColors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
