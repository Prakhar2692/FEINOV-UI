import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../constants/app_spacing.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.radiusM,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutral90,
      highlightColor: AppColors.neutral95,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class AppProductShimmer extends StatelessWidget {
  const AppProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer(
            width: double.infinity,
            height: 150,
            borderRadius: AppSpacing.radiusL,
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 60, height: 12),
                SizedBox(height: 8),
                AppShimmer(width: double.infinity, height: 16),
                SizedBox(height: 8),
                AppShimmer(width: 40, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
