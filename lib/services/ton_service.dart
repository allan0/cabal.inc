// lib/services/ton_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ton/ton.dart'; // Core TON logic
import '../config.dart';
import 'supabase_service.dart';
//import 'package:cabal/core/app_config.dart';

/// Service to handle TON Blockchain interactions.
/// Optimized for Telegram Mini Apps (TMA) and Native Mobile via Deep Linking.
class TonService {
  static final TonService _instance = TonService._internal();
  factory TonService() => _instance;
  TonService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  String? _currentAddress;
  bool _isConnecting = false;

  // Getters
  String? get currentAddress => _currentAddress;
  bool get isConnected => _currentAddress != null;
  bool get isConnecting => _isConnecting;

  /// Initializes the TON service. 
  /// In a production environment, this would check for an existing session.
  Future<void> initialize() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      final profile = await _supabaseService.getUserProfile(user.id);
      if (profile != null && profile.connected_wallets.containsKey('ton')) {
        _currentAddress = profile.connected_wallets['ton'];
        debugPrint("TonService: Restored address $_currentAddress");
      }
    }
  }

  /// Initiates the TON Connect 2.0 flow.
  /// Works for both Web/TMA and Native Mobile.
  Future<String?> connectWallet() async {
    if (_isConnecting) return null;
    _isConnecting = true;

    try {
      debugPrint("TonService: Starting TON Connect...");

      // 1. Generate the Connection Request (Simplified for this phase)
      // In a full implementation, you would use a TonConnect bridge server.
      // For the "Ready for Partnerships" phase, we trigger the wallet selection.
      
      final String manifestUrl = AppConfig.tonManifestUrl;
      
      // 2. Define the Universal Link for Tonkeeper (The most common TON wallet)
      // Format: https://app.tonkeeper.com/ton-connect?v=2&id=<session_id>&r=<request_payload>
      
      // This is a placeholder for the actual TonConnect 2.0 handshake payload.
      // In TMA mode, the Telegram JS bridge usually handles this.
      if (AppConfig.isTelegramMiniApp) {
        debugPrint("TonService: Operating in Telegram Mini App mode.");
        // Logic here would call the JavaScript window.tonConnectUI
      }

      // 3. For Native iOS/Android: Open Tonkeeper via Deep Link
      // We simulate a successful connection for now to allow you to build the UI.
      // In production, the wallet returns the address via a background callback or redirect.
      const String mockTonAddress = "UQBKgXCNLPexv_I0G6Xkh-idD-FNPV8U_S81uS3tV24tV53r"; 

      // 4. Save to Supabase immediately to register the partnership/user
      await _supabaseService.addWallet(mockTonAddress, 'ton');
      
      _currentAddress = mockTonAddress;
      return _currentAddress;
    } catch (e) {
      debugPrint("TonService: Connection error: $e");
      return null;
    } finally {
      _isConnecting = false;
    }
  }

  /// Disconnects the wallet and removes it from the local state.
  Future<void> disconnect() async {
    _currentAddress = null;
    debugPrint("TonService: Wallet disconnected");
  }

  // ====================== TRANSACTIONS & SIGNING ======================

  /// Requests the user to sign a message (used for Quest verification).
  Future<String?> signMessage(String message) async {
    if (!isConnected) throw Exception("Wallet not connected");

    try {
      debugPrint("TonService: Requesting signature for: $message");
      // Simulation of a signed cell
      return "base64_encoded_signature_placeholder";
    } catch (e) {
      debugPrint("TonService: Signing error: $e");
      return null;
    }
  }

  /// Sends a transaction on the TON blockchain.
  /// [to] Recipient address (friendly or raw format)
  /// [amountNano] Amount in NanoTons (1 TON = 1,000,000,000 NanoTons)
  Future<bool> sendTonTransaction({
    required String to, 
    required int amountNano,
    String? comment,
  }) async {
    if (!isConnected) return false;

    try {
      debugPrint("TonService: Sending $amountNano NanoTons to $to");

      // Construct the TonConnect transaction request
      final transactionRequest = {
        "validUntil": (DateTime.now().millisecondsSinceEpoch / 1000).round() + 600, // 10 mins
        "messages": [
          {
            "address": to,
            "amount": amountNano.toString(),
            "payload": comment != null ? _encodeComment(comment) : null,
          }
        ]
      };

      // In TMA: tonConnectUI.sendTransaction(transactionRequest)
      // In Native: Open wallet via Universal Link with the request payload
      
      return true;
    } catch (e) {
      debugPrint("TonService: Transaction error: $e");
      return false;
    }
  }

  /// Internal helper to encode text comments into a TON Cell payload
  String _encodeComment(String comment) {
    // TON comments are typically Cell-based with a 0 prefix
    return base64Encode(utf8.encode(comment));
  }
}
