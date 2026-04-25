// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- Core Black & Gold Palette ---
  static const Color gold = Color(0xFFFBC02D);
  static const Color offBlack = Color(0xFF121212);
  static const Color darkGrey = Color(0xFF1E1E1E);
  static const Color lightText = Color(0xFFFAFAFA);
  static const Color greyText = Color(0xFFAAAAAA);

  // --- NEW: Vibrant Accent Palette for Modern Web3 Feel ---
  static const Color primaryAccent = Color(0xFF8A2BE2); // Vibrant BlueViolet
  static const Color secondaryAccent = Color(0xFF00BFFF); // DeepSkyBlue
  static const Color tertiaryAccent = Color(0xFF32CD32); // LimeGreen for success states

  // --- NEW: Gradient Definitions ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryAccent, secondaryAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlayGradient = LinearGradient(
    colors: [primaryAccent, Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.center,
  );


  // Light Theme (now maps to the new dark theme for consistency)
  static const Color background = offBlack;
  static const Color primary = gold; // Gold is now the primary interactive color
  static const Color accent = gold;
  static const Color textPrimary = lightText;
  static const Color textSecondary = greyText;
  static const Color cardBackground = darkGrey;

  // Dark Theme (explicitly defined for clarity)
  static const Color darkBackground = offBlack;
  static const Color darkPrimary = gold;
  static const Color darkAccent = gold;
  static const Color darkTextPrimary = lightText;
  static const Color darkTextSecondary = greyText;
  static const Color darkCardBackground = darkGrey;

  // General Semantic Colors (Kept for universal meaning)
  static const Color success = Color(0xFF4CAF50); // A more standard green
  static const Color error = Color(0xFFF44336); // A more standard red
  static const Color warning = Color(0xFFFF9800); // A more standard orange
  static const Color info = Color(0xFF2196F3); // A more standard blue
  static const Color disabled = Colors.grey;

  // Gradients & Highlights (Updated to Gold/Black)
  static const Color gradientGoldStart = Color(0xFFD4AF37);
  static const Color gradientGoldMid = Color(0xFFC5B358);
  static const Color goldHighlight = Color(0xFFFFD700);

  // Particle Background Colors (Updated to Gold/Black)
  static const Color particleBlackBase = Color(0xFF151515);
  static const Color particleGoldSoft = Color(0x99FBC02D);
  static const Color particleGreySoft = Color(0x80AAAAAA);
  static const Color particleDarkGold = Color(0xFFB8860B);
  static const Color particleDarkGrey = Color(0xFF333333);

  // --- NEW: Re-adding missing "Blue" (now gold/black-themed) particle/gradient colors ---
  // These were causing "Member not found" errors. Assigning them values that fit the new palette.
  static const Color particleBlueLight = Color(0x33FBC02D); // A soft, transparent gold
  static const Color particleWhiteSoft = Color(0x20FAFAFA); // Very light, transparent text color
  static const Color particleBlueBase = Color(0x20121212);  // Very dark, transparent background
  static const Color particleBlueAccentSoft = Color(0x20FBC02D); // Another soft gold for particles
  static const Color particleBlueMidRgb = Color(0x25121212); // Slightly different transparent dark
  static const Color gradientBlueStart = Color(0xFFD4AF37); // Reusing an existing gold gradient color
  static const Color parachuteHighlight = Color(0xFFFFD700); // Reusing an existing gold highlight color


  // Zealy-like project specific theme (If you use this pattern) - Unchanged
  static const Color zealyBackground = Color(0xFF131417);
  static const Color zealyCard = Color(0xFF1A1B1F);
  static const Color zealyTextPrimary = Colors.white;
  static const Color zealyTextSecondary = Color(0xFF8F9094);
  static const Color zealyAccent = Color(0xFF6435F5);

  // Quest Card Specific Borders (Unchanged - these are semantic for external brands)
  static const Color questTypeTwitterBorder = Colors.lightBlueAccent;
  static const Color questTypeDiscordBorder = Color(0xFF7289DA);
  static const Color questTypeTelegramBorder = Color(0xFF2AABEE);
  static const Color questTypeYoutubeBorder = Color(0xFFFF0000);
  static const Color questTypeInstagramBorder = Color(0xFFE1306C);
  static const Color questTypeWalletBorder = Colors.greenAccent;
  static const Color questTypeManualVerificationBorder = Colors.orangeAccent;
  static const Color questTypeDefaultBorder = Colors.transparent;

  static Color questBorderColor(String questTypeString) {
    switch (questTypeString.toLowerCase()) {
      case 'twitterfollow':
      case 'twitterretweet':
      case 'twitterlike':
        return questTypeTwitterBorder;
      case 'discordjoin':
        return questTypeDiscordBorder;
      case 'telegramchanneljoin':
      case 'telegramgroupjoin':
        return questTypeTelegramBorder;
      case 'youtubesubscribe':
      case 'youtubelikevideo':
        return questTypeYoutubeBorder;
      case 'instagramfollow':
        return questTypeInstagramBorder;
      case 'connectwalleteth':
      case 'connectwalletbase':
      case 'evmsignmessage':
      case 'evmtransaction':
        return questTypeWalletBorder;
      case 'manualverification':
        return questTypeManualVerificationBorder;
      default:
        return questTypeDefaultBorder;
    }
  }
}
