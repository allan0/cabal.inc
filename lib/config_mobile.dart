// lib/config_mobile.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static final String walletConnectProjectId = dotenv.env['WALLET_CONNECT_PROJECT_ID'] ?? '';
  static final String sepoliaRpcUrl = dotenv.env['SEPOLIA_RPC_URL'] ?? '';
  static final String mainnetRpcUrl = dotenv.env['MAINNET_RPC_URL'] ?? '';
  static final String coingeckoApiKey = dotenv.env['COINGECKO_API_KEY'] ?? '';
  static final String etherscanApiKey = dotenv.env['ETHERSCAN_API_KEY'] ?? '';
  static final String pinataApiKey = dotenv.env['PINATA_API_KEY'] ?? '';
  static final String pinataApiSecret = dotenv.env['PINATA_API_SECRET'] ?? '';
  
  static String getContractAddress(String name) {
    final prefix = kDebugMode ? 'SEPOLIA' : 'MAINNET';
    return dotenv.env['${prefix}_${name}'] ?? '';
  }
}
