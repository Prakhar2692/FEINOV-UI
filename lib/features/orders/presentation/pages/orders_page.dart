import 'package:flutter/material.dart';
import '../../../../core/widgets/app_top_bar.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'My Orders', showBackButton: false),
      body: Center(child: Text('Orders Content')),
    );
  }
}
