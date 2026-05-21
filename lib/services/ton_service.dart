import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import 'supabase_service.dart';

class TonService {
  static final TonService _instance = TonService._internal();
  factory TonService() => _instance;
  TonService._internal();

  final SupabaseService _supabase = SupabaseService();
  String? _currentAddress;

  String? get currentAddress => _currentAddress;
  bool get isConnected => _currentAddress != null;

  Future<void> initialize() async {
    final user = _supabase.currentUser;
    if (user != null) {
      final profile = await _supabase.getUserProfile(user.id);
      if (profile?.tonAddress != null) {
        _currentAddress = profile!.tonAddress;
      }
    }
  }

  /// Initiates TON Connect logic and syncs with Supabase
  Future<String?> connectWallet() async {
    try {
      debugPrint("TonService: Connecting...");
      
      // MOCK: In production, this calls the TON Connect JS bridge or deep link
      // We simulate a successful handshake for development
      await Future.delayed(const Duration(seconds: 1));
      const mockAddress = "UQBKgXCNLPexv_I0G6Xkh-idD-FNPV8U_S81uS3tV24tV53r";

      // Ensure we have an anonymous Supabase session to attach the wallet to
      if (_supabase.currentUser == null) {
        await Supabase.instance.client.auth.signInAnonymously();
      }

      await _supabase.syncWalletToProfile(mockAddress, 'ton');
      _currentAddress = mockAddress;
      return _currentAddress;
    } catch (e) {
      debugPrint("TonService: Connection error: $e");
      return null;
    }
  }

  Future<void> disconnect() async {
    _currentAddress = null;
    debugPrint("TonService: Disconnected");
  }
}
