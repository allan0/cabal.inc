// lib/core/services/wallet_service_mobile.dart
// This is the mobile-only implementation that includes Solana and EVM.
import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:bs58/bs58.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WalletType {
  static const String evm = 'evm';
  static const String solana = 'solana';
}

class WalletService {
  // --- EVM (WalletConnect) ---
  Web3App? _wcClient;
  SessionData? _wcSession;
  String? get _wcAddress => _wcSession != null ? NamespaceUtils.getAccount(
          _wcSession!.namespaces.values.first.accounts.first) : null;
  String? get _wcChainId => _wcSession != null ? NamespaceUtils.getChainFromAccount(
          _wcSession!.namespaces.values.first.accounts.first) : null;

  // --- Solana (Mobile Wallet Adapter) ---
  String? _connectedSolanaAddress;
  AuthorizationResult? _mwaAuthResult;
  final SolanaMobileClient _solanaMobileClient = SolanaMobileClient(
    walletCluster: WalletCluster.mainnetBeta,
    identityName: 'Cabal',
    identityUri: Uri.parse('https://cabal-001.web.app'),
    iconUri: Uri.parse('https://cabal-001.web.app/icon.png'),
  );

  // --- Public Getters ---
  String? get connectedEVMAddress => _wcAddress;
  String? get currentEVMChainId => _wcChainId;
  bool get isConnectedEVM => _wcSession != null && _wcAddress != null;

  String? get connectedSolanaAddress => _connectedSolanaAddress;
  bool get isConnectedSolana => _connectedSolanaAddress != null;

  Future<void> initialize() async {
    final projectId = env['WALLET_CONNECT_PROJECT_ID'];
    if (projectId == null) {
      debugPrint("WalletService FATAL: WALLET_CONNECT_PROJECT_ID not found in .env");
      return;
    }

    _wcClient = await Web3App.createInstance(
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'Cabal',
        description: 'Cabal Quest Platform',
        url: 'https://cabal-001.web.app',
        icons: ['https://cabal-001.web.app/icon.png'],
      ),
    );
    debugPrint("WalletService (Mobile): WalletConnect client initialized.");
  }

  void _clearEVMConnectionState() {
    _wcSession = null;
  }
  
  void _clearSolanaConnectionState() {
    _connectedSolanaAddress = null;
    _mwaAuthResult = null;
  }

  Future<String?> connectEVMWallet() async {
    if (isConnectedEVM) return _wcAddress;
    if (_wcClient == null) throw Exception("WalletConnect client is not initialized.");

    try {
      ConnectResponse response = await _wcClient!.connect(
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            chains: ['eip155:11155111'], // Sepolia Testnet
            methods: ['personal_sign', 'eth_sendTransaction'],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
      );

      final Uri? uri = response.uri;
      if (uri != null) {
        await launchUrlString(uri.toString(), mode: LaunchMode.externalApplication);
      }

      _wcSession = await response.session.future;
      debugPrint("WalletService (Mobile): EVM wallet connected: ${_wcAddress}");
      return _wcAddress;
    } catch (e) {
      _clearEVMConnectionState();
      debugPrint("WalletService (Mobile): EVM connection error: $e");
      throw Exception("Failed to connect EVM wallet: $e");
    }
  }

  Future<void> disconnectEVMWallet() async {
    if (_wcSession != null) {
      await _wcClient?.disconnectSession(
        topic: _wcSession!.topic,
        reason: const WalletConnectError(code: 1, message: 'User disconnected'),
      );
    }
    _clearEVMConnectionState();
    debugPrint("WalletService (Mobile): EVM wallet disconnected.");
  }

  Future<String?> connectSolanaWallet() async {
    if (isConnectedSolana) return _connectedSolanaAddress;
    try {
      final result = await _solanaMobileClient.authorize();
      _mwaAuthResult = result;
      _connectedSolanaAddress = base58.encode(result.publicKey);
      return _connectedSolanaAddress;
    } catch (e) {
      _clearSolanaConnectionState();
      throw Exception("Failed to connect Solana wallet: $e");
    }
  }

  Future<void> disconnectSolanaWallet() async {
    try {
      if (_mwaAuthResult != null) {
        await _solanaMobileClient.deauthorize(authToken: _mwaAuthResult!.authToken);
      }
    } catch (e) {
      debugPrint("WalletService: Error deauthorizing Solana wallet, but clearing state anyway. Error: $e");
    } finally {
      _clearSolanaConnectionState();
    }
  }

  Future<String?> signEVMMessage(String message, {String? chainId}) async {
    if (!isConnectedEVM || _wcClient == null) throw Exception("EVM Wallet not connected.");

    final response = await _wcClient!.request(
      topic: _wcSession!.topic,
      chainId: chainId ?? 'eip155:11155111',
      request: SessionRequest(
        method: 'personal_sign',
        params: [message, _wcAddress],
      ),
    );

    return response.toString(); // The signed message hash
  }

  Future<String?> sendEVMTransaction({
    required String to, String? data, String? value, String? chainId,
  }) async {
    if (!isConnectedEVM || _wcClient == null) throw Exception("EVM Wallet not connected.");
    
    final transaction = {
      'from': _wcAddress,
      'to': to,
      'data': data ?? '0x',
      'value': value, // e.g., '0x...' for 1 ETH
    };

    final response = await _wcClient!.request(
      topic: _wcSession!.topic,
      chainId: chainId ?? 'eip155:11155111',
      request: SessionRequest(
        method: 'eth_sendTransaction',
        params: [transaction],
      ),
    );
    
    return response.toString(); // The transaction hash
  }
}
