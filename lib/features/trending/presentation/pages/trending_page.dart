import 'package:e_commerce_app/core/widgets/app_background.dart';
import 'package:e_commerce_app/core/widgets/app_color_custom.dart';
import 'package:flutter/material.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        backgroundColor: AppColorsCustom.primary,
      ),
      body: AppBackground(
        isScrollable: false,
        child: Center(
          child: Text(
            'Trending Products will be displayed here',
            style: TextStyle(color: AppColorsCustom.textPrimary),
          ),
        ),
      ),
    );
  }
}
