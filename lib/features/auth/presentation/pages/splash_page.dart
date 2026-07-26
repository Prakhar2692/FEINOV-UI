import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../data/repositories/auth_repository_impl.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacity = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    useEffect(() {
      opacity.forward();
      
      // Check auth status
      Future.microtask(() async {
        final authRepo = ref.read(authRepositoryProvider);
        final authenticated = await authRepo.isAuthenticated();
        
        if (context.mounted) {
          if (authenticated) {
            context.go('/home');
          } else {
            context.go('/auth');
          }
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for Logo
              const Icon(
                Icons.spa_outlined,
                size: 100,
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
              const SizedBox(height: 48),
              const AppLoadingIndicator(color: AppColors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
