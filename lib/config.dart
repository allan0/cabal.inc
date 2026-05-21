import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration manager for Cabal.
/// Handles environment variables for both Web (dart-define) and Mobile (.env).
class AppConfig {
  static const String appName = "CABAL";
  static const String appVersion = "1.0.0";

  // --- Supabase Config ---
  // On Web, we prioritize --dart-define. On Mobile, we check .env then fallbacks.
  static String get supabaseUrl {
    const webVal = String.fromEnvironment('SUPABASE_URL');
    if (kIsWeb && webVal.isNotEmpty) return webVal;
    return dotenv.env['SUPABASE_URL'] ?? 'https://unjwwotvbtquecgqltqp.supabase.co';
  }

  static String get supabaseAnonKey {
    const webVal = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (kIsWeb && webVal.isNotEmpty) return webVal;
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  // --- Blockchain & WalletConnect ---
  static String get walletConnectProjectId {
    const webVal = String.fromEnvironment('WALLET_CONNECT_PROJECT_ID');
    if (kIsWeb && webVal.isNotEmpty) return webVal;
    return dotenv.env['WALLET_CONNECT_PROJECT_ID'] ?? '61b4c2a7392e99d13ece7bf970f40dd2';
  }

  static const String tonManifestUrl = "https://cabal-001.web.app/tonconnect-manifest.json";
  static const bool isTelegramMiniApp = kIsWeb; // Context-aware flag

  // --- RPC URLs ---
  static String get sepoliaRpcUrl {
    const webVal = String.fromEnvironment('SEPOLIA_RPC_URL');
    if (kIsWeb && webVal.isNotEmpty) return webVal;
    return dotenv.env['SEPOLIA_RPC_URL'] ?? '';
  }

  // --- API Keys ---
  static String get coingeckoApiKey {
    const webVal = String.fromEnvironment('COINGECKO_API_KEY');
    if (kIsWeb && webVal.isNotEmpty) return webVal;
    return dotenv.env['COINGECKO_API_KEY'] ?? '';
  }
}
