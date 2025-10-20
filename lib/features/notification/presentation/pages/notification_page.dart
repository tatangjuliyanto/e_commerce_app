import 'package:e_commerce_app/core/widgets/app_background.dart';
import 'package:e_commerce_app/core/widgets/app_color_custom.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColorsCustom.primary,
      ),
      body: AppBackground(
        isScrollable: false,
        child: Center(
          child: Text(
            'No new notifications',
            style: TextStyle(color: AppColorsCustom.textPrimary),
          ),
        ),
      ),
    );
  }
}
