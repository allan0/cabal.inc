// lib/widgets/app_logo_widget.dart
import 'package:flutter/material.dart';
import 'package:cabal/utils/app_colors.dart'; // Assuming your AppColors are here

class AppLogoWidget extends StatelessWidget {
  final double logoHeight;

  const AppLogoWidget({
    Key? key,
    this.logoHeight = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/cabal_logo.png', // Switched to PNG for better compatibility
      height: logoHeight,
      errorBuilder: (context, error, stackTrace) {
        // Fallback in case the image still fails to load
        print("Error loading logo asset: $error");
        return Icon(
          Icons.shield_moon_rounded,
          size: logoHeight,
          color: AppColors.gold,
        );
      },
    );
  }
}
