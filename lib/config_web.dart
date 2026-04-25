// lib/config_web.dart

class AppConfig {
  // --- Core Services ---
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String walletConnectProjectId = String.fromEnvironment('WALLET_CONNECT_PROJECT_ID');

  // --- RPC & API Keys ---
  static const String sepoliaRpcUrl = String.fromEnvironment('SEPOLIA_RPC_URL');
  static const String mainnetRpcUrl = String.fromEnvironment('MAINNET_RPC_URL');
  static const String coingeckoApiKey = String.fromEnvironment('COINGECKO_API_KEY');
  static const String etherscanApiKey = String.fromEnvironment('ETHERSCAN_API_KEY');
  static const String pinataApiKey = String.fromEnvironment('PINATA_API_KEY');
  static const String pinataApiSecret = String.fromEnvironment('PINATA_API_SECRET');
  
  // --- Sepolia Contract Addresses ---
  static const String sepoliaCabalTokenAddress = String.fromEnvironment('SEPOLIA_CABAL_TOKEN_ADDRESS');
  static const String sepoliaCabalTgeAddress = String.fromEnvironment('SEPOLIA_CABAL_TGE_ADDRESS');
  static const String sepoliaCabalAchievementsAddress = String.fromEnvironment('SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS');
  static const String sepoliaPresaleAddress = String.fromEnvironment('SEPOLIA_PRESALE_ADDRESS');
  static const String sepoliaRealEstateDeedAddress = String.fromEnvironment('SEPOLIA_REAL_ESTATE_DEED_ADDRESS');
  static const String sepoliaEscrowAddress = String.fromEnvironment('SEPOLIA_ESCROW_ADDRESS');
  static const String sepoliaNftMarketplaceAddress = String.fromEnvironment('SEPOLIA_NFT_MARKETPLACE_ADDRESS');
  static const String sepoliaMerchandiseStoreAddress = String.fromEnvironment('SEPOLIA_MERCHANDISE_STORE_ADDRESS');

  // --- Mainnet Contract Addresses ---
  static const String mainnetCabalTokenAddress = String.fromEnvironment('MAINNET_CABAL_TOKEN_ADDRESS');
  static const String mainnetCabalTgeAddress = String.fromEnvironment('MAINNET_CABAL_TGE_ADDRESS');
  static const String mainnetCabalAchievementsAddress = String.fromEnvironment('MAINNET_CABAL_ACHIEVEMENTS_ADDRESS');
  static const String mainnetPresaleAddress = String.fromEnvironment('MAINNET_PRESALE_ADDRESS');
  static const String mainnetRealEstateDeedAddress = String.fromEnvironment('MAINNET_REAL_ESTATE_DEED_ADDRESS');
  static const String mainnetEscrowAddress = String.fromEnvironment('MAINNET_ESCROW_ADDRESS');
  static const String mainnetNftMarketplaceAddress = String.fromEnvironment('MAINNET_NFT_MARKETPLACE_ADDRESS');
  static const String mainnetMerchandiseStoreAddress = String.fromEnvironment('MAINNET_MERCHANDISE_STORE_ADDRESS');
}
