import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  static const String appName = "CABAL";
  static const bool isTelegramMiniApp = true; 
  static const String tonManifestUrl = "https://cabal-001.web.app/tonconnect-manifest.json";

  // API Keys
  static const String coingeckoApiKey = 'YOUR_KEY_HERE';

  // Contract Addresses (Empty for now to prevent build errors)
  static const String sepoliaRpcUrl = '';
  static const String mainnetRpcUrl = '';
  static const String sepoliaCabalTokenAddress = '';
  static const String mainnetCabalTokenAddress = '';
  static const String sepoliaCabalTgeAddress = '';
  static const String mainnetCabalTgeAddress = '';
  static const String sepoliaCabalAchievementsAddress = '';
  static const String mainnetCabalAchievementsAddress = '';
  static const String sepoliaPresaleAddress = '';
  static const String mainnetPresaleAddress = '';
  static const String sepoliaRealEstateDeedAddress = '';
  static const String mainnetRealEstateDeedAddress = '';
  static const String sepoliaEscrowAddress = '';
  static const String mainnetEscrowAddress = '';
  static const String sepoliaNftMarketplaceAddress = '';
  static const String mainnetNftMarketplaceAddress = '';
  static const String sepoliaMerchandiseStoreAddress = '';
  static const String mainnetMerchandiseStoreAddress = '';
}
