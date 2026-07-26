import 'package:flutter/material.dart';
import '../../../../core/widgets/app_top_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Profile', showBackButton: false),
      body: Center(child: Text('Profile Content')),
    );
  }
}
