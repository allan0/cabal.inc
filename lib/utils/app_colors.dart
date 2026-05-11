import 'package:flutter/material.dart';

class AppColors {
  // Core Branded Colors
  static const Color background = Color(0xFF0F0F0F);
  static const Color offBlack = Color(0xFF080808); // Added this
  static const Color gold = Color(0xFFD4AF37);
  static const Color primaryAccent = Color(0xFFE2B05E);
  static const Color darkGrey = Color(0xFF1B1212);
  static const Color lightText = Color(0xFFF3E5AB);
  static const Color greyText = Color(0xFF9E9E9E);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const Gradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x22FFFFFF),
      Color(0x00FFFFFF),
    ],
  ); // Added this
}
