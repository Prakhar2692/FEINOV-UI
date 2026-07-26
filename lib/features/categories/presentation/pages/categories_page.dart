import 'package:flutter/material.dart';
import '../../../../core/widgets/app_top_bar.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Categories', showBackButton: false),
      body: Center(child: Text('Categories Content')),
    );
  }
}
