import 'package:flutter/material.dart';
import '../../../../core/widgets/app_top_bar.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Wishlist', showBackButton: false),
      body: Center(child: Text('Wishlist Content')),
    );
  }
}
