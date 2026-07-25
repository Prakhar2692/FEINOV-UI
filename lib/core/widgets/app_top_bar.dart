import 'package:feinov_ui/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:feinov_ui/core/theme/app_typography.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const AppTopBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(title!, style: AppTypography.headlineLarge)
          : null,
      actions: actions,
      backgroundColor: AppColors.primary,
      leading:
          leading ??
          (showBackButton && Navigator.canPop(context)
              ? const BackButton()
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
