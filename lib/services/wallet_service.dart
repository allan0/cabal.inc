// lib/services/wallet_service.dart
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'supabase_service.dart';
import 'ton_service.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  late ReownAppKitModal _appKit;

  void initialize(BuildContext context) {
    _appKit = ReownAppKitModal.of(context);
  }

  Future<void> connectEvmWallet(BuildContext context) async {
    try {
      await _appKit.openModal();
      if (_appKit.session != null) {
        final address = _appKit.getAddress();
        if (address != null) {
          await SupabaseService().addWallet(address, 'evm');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("EVM Wallet Connected")),
          );
        }
      }
    } catch (e) {
      debugPrint("EVM Connect Error: $e");
    }
  }

  Future<void> connectTonWallet(BuildContext context) async {
    final address = await TonService().connectTonWallet();
    if (address != null) {
      await SupabaseService().addWallet(address, 'ton');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("TON Connected: ${address.substring(0, 8)}...")),
      );
    }
  }

  String? getEvmAddress() => _appKit.getAddress();
}
