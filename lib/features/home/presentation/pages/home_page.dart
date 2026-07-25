import 'package:feinov_ui/core/widgets/app_top_bar.dart';
import 'package:feinov_ui/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'FEINOV'),
      body: Center(
        child: Text('Welcome to FEINOV', style: AppTypography.bodyLarge),
      ),
    );
  }
}
