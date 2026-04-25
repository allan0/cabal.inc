// lib/core/services/solana_service_stub.dart
// This is the stub implementation for web.
class SolanaWalletService {
  Future<String?> connect() async {
    throw UnsupportedError('Solana wallet connection is not supported on Web.');
  }

  Future<void> disconnect() async {
    throw UnsupportedError('Solana wallet disconnection is not supported on Web.');
  }

  bool get isConnected => false;
  String? get connectedAddress => null;
}
