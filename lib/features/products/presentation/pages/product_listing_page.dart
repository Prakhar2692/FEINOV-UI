import 'package:flutter/material.dart';
import '../../../../core/widgets/app_top_bar.dart';

class ProductListingPage extends StatelessWidget {
  final String? categoryId;
  final String? subcategoryId;
  final String title;

  const ProductListingPage({
    super.key,
    this.categoryId,
    this.subcategoryId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: title),
      body: Center(
        child: Text('Products for $title'),
      ),
    );
  }
}
