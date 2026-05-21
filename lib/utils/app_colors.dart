import 'package:flutter/material.dart';

class AppColors {
  // --- Core Obsidian Palette ---
  static const Color background = Color(0xFF050505); // Deep Obsidian
  static const Color surface = Color(0xFF0F0F0F);    // Card Surface
  static const Color darkGrey = Color(0xFF1A1A1A);   // Lighter Obsidian
  
  // --- Cabal Gold (Metallic) ---
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color primaryAccent = Color(0xFFE2B05E);
  
  // --- Semantic Colors ---
  static const Color success = Color(0xFF00FFA3); // Neon Green
  static const Color error = Color(0xFFFF3333);   // Vibrant Red
  static const Color warning = Color(0xFFFFAB40); // Amber
  static const Color info = Color(0xFF00E5FF);    // Electric Blue
  static const Color greyText = Color(0xFF8E8E93);
  static const Color lightText = Color(0xFFF5F5F5);

  // --- Gradients ---
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFE2B05E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Specific Component Styles ---
  static BoxDecoration glassDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.05),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
  );
}
