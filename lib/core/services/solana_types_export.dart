// lib/core/services/solana_types_export.dart
library airloot.solana_types; // Library name

// Re-export the necessary types from solana_mobile_client
// This forces them into the 'airloot.solana_types' library namespace.
export 'package:solana_mobile_client/solana_mobile_client.dart' 
    show SolanaMobileClient, WalletCluster, AuthorizationResult, Commitment;
