// lib/core/services/solana_service_mobile.dart
import 'package:bs58/bs58.dart';
import 'package:flutter/foundation.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

// This is the real implementation for mobile.
class SolanaWalletService {
  String? _connectedAddress;
  AuthorizationResult? _mwaAuthResult;
  final SolanaMobileClient _solanaMobileClient = SolanaMobileClient(
    walletCluster: WalletCluster.mainnetBeta,
    identityName: 'Cabal',
    identityUri: Uri.parse('https://cabal-001.web.app'),
    iconUri: Uri.parse('https://cabal-001.web.app/icon.png'),
  );

  bool get isConnected => _connectedAddress != null;
  String? get connectedAddress => _connectedAddress;

  Future<String?> connect() async {
    if (isConnected) return _connectedAddress;
    try {
      final result = await _solanaMobileClient.authorize();
      _mwaAuthResult = result;
      _connectedAddress = base58.encode(result.publicKey);
      return _connectedAddress;
    } catch (e) {
      _clearState();
      debugPrint("Solana Connection Error: $e");
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_mwaAuthResult != null) {
      try {
        await _solanaMobileClient.deauthorize(authToken: _mwaAuthResult!.authToken);
      } catch(e) {
        debugPrint("Error deauthorizing Solana: $e");
      }
    }
    _clearState();
  }

  void _clearState() {
    _connectedAddress = null;
    _mwaAuthResult = null;
  }
}
