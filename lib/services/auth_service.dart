// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  // ====================== EMAIL AUTH ======================

  Future<AuthResponse> signUpWithEmail(String email, String password, {String? referralCode}) async {
    return await _supabaseService.signUpUser(email, password, referralCode: referralCode);
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabaseService.signInUser(email, password);
  }

  // ====================== OAUTH (Google, Discord, Twitter) ======================

  /// Recommended: Use Supabase's built-in OAuth
  Future<bool> signInWithGoogle() async {
    return await _supabaseService.signInWithGoogle();
  }

  Future<bool> signInWithDiscord() async {
    return await _supabaseService.signInWithDiscord();
  }

  Future<bool> signInWithTwitter() async {
    return await _supabaseService.signInWithTwitter();
  }

  // ====================== WALLET CONNECTIONS (Stubs for now) ======================

  Future<String?> connectEthereumWallet() async {
    debugPrint("Attempting to connect Ethereum Wallet...");
    // TODO: Integrate Reown AppKit / Web3Modal here
    await Future.delayed(const Duration(seconds: 1));
    return "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"; // Placeholder
  }

  Future<String?> connectSolanaWallet() async {
    debugPrint("Attempting to connect Solana Wallet...");
    // TODO: Integrate Solana Mobile or Phantom
    await Future.delayed(const Duration(seconds: 1));
    return "YourSolanaAddressPlaceholder..."; // Placeholder
  }

  Future<String?> connectBaseWallet() async {
    debugPrint("Attempting to connect Base Wallet...");
    // Usually same as Ethereum (EVM)
    await Future.delayed(const Duration(seconds: 1));
    return "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"; // Placeholder
  }

  // ====================== SOCIAL ACTIONS ======================

  Future<bool> signInWithTwitterAction(String? targetUrl) async {
    if (targetUrl != null && targetUrl.isNotEmpty) {
      final uri = Uri.parse(targetUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    }
    debugPrint("No valid Twitter URL provided.");
    return false;
  }

  Future<bool> signInWithDiscordAction(String? targetUrl) async {
    if (targetUrl != null && targetUrl.isNotEmpty) {
      final uri = Uri.parse(targetUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    }
    debugPrint("No valid Discord URL provided.");
    return false;
  }

  Future<void> launchActionUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      throw Exception('No URL provided to launch');
    }

    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  // ====================== MISC ======================

  Future<void> signOut() async {
    await _supabaseService.signOutUser();
  }

  User? get currentUser => _supabaseService.getCurrentUser();

  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;
}
