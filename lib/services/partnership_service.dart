// lib/services/partnership_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

/// Logic-only service to handle partner attribution and referrals.
class PartnershipService {
  static const String _refKey = 'pending_referral_code';

  /// Captures the referral code from the entry point.
  /// Should be called in the initState of the very first screen.
  static Future<void> captureReferral() async {
    String? incomingRef;

    if (kIsWeb) {
      // 1. Check URL parameters (e.g., cabal.app/?ref=ALPHA)
      incomingRef = Uri.base.queryParameters['ref'];
      
      // 2. Check Telegram Mini App start parameter
      if (incomingRef == null && AppConfig.isTelegramMiniApp) {
        incomingRef = Uri.base.queryParameters['tgWebAppStartParam'];
      }
    }

    if (incomingRef != null && incomingRef.isNotEmpty) {
      debugPrint("PartnershipService: Captured ref code: $incomingRef");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refKey, incomingRef);
    }
  }

  /// Retrieves the stored referral code to pass to the Supabase signup.
  static Future<String?> getPendingReferral() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refKey);
  }

  /// Clears the referral after a successful signup/attribution.
  static Future<void> clearReferral() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refKey);
  }

  /// Logic to determine if the current user is a "Whale" or "KOL" 
  /// based on their connected wallet history.
  /// Used for unlocking hidden partnership quests.
  static bool meetsPartnershipThreshold(int totalXp, int balance) {
    // Non-UI business logic
    if (totalXp > 5000 || balance > 100) return true;
    return false;
  }
}
