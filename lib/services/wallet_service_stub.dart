// lib/core/services/wallet_service_stub.dart
// This is the WEB implementation using Web3Modal.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class WalletType {
  static const String evm = 'evm';
  static const String solana = 'solana';
}

class WalletService {
  W3MService? _w3mService;

  // --- Public Getters ---
  String? get connectedEVMAddress => _w3mService?.session?.address;
  String? get currentEVMChainId => _w3mService?.session?.chainId;
  bool get isConnectedEVM => _w3mService?.isConnected ?? false;
  
  // Solana remains unsupported on web
  String? get connectedSolanaAddress => null;
  bool get isConnectedSolana => false;

  Future<void> initialize() async {
    final projectId = dotenv.env['WALLET_CONNECT_PROJECT_ID'];
    if (projectId == null) {
      debugPrint("WalletService (Web) FATAL: WALLET_CONNECT_PROJECT_ID not found in .env");
      return;
    }

    _w3mService = W3MService(
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'Cabal',
        description: 'Cabal Quest Platform',
        url: 'https://cabal-001.web.app',
        icons: ['https://cabal-001.web.app/icon.png'],
      ),
    );

    await _w3mService!.init();
    
    debugPrint("WalletService (Web): Web3Modal client initialized.");
  }

  Future<String?> connectEVMWallet() async {
    if (isConnectedEVM) return connectedEVMAddress;
    if (_w3mService == null) throw Exception("Web3Modal service not initialized.");

    try {
      await _w3mService!.openModalView(); // Corrected method call
      // The provider will listen for state changes.
      return connectedEVMAddress;
    } catch (e) {
      debugPrint('Error connecting wallet via Web3Modal: $e');
      await disconnectEVMWallet();
      rethrow;
    }
  }

  Future<void> disconnectEVMWallet() async {
    if (_w3mService != null && _w3mService!.isConnected) {
      await _w3mService!.disconnect();
    }
    debugPrint("WalletService (Web): EVM wallet disconnected.");
  }

  Future<String?> signEVMMessage(String message, {String? chainId}) async {
    if (!isConnectedEVM || _w3mService == null) throw Exception("EVM Wallet not connected.");
    
    final signature = await _w3mService!.request(
      topic: _w3mService!.session!.topic!,
      chainId: chainId ?? 'eip155:${_w3mService!.selectedChain!.chainId}',
      request: SessionRequest(
        method: 'personal_sign',
        params: [message, connectedEVMAddress],
      ),
    );
    return signature.toString();
  }

  Future<String?> sendEVMTransaction({
    required String to,
    String? data,
    String? value,
    String? chainId,
  }) async {
    if (!isConnectedEVM || _w3mService == null) throw Exception("EVM Wallet not connected.");
    
    final transaction = Transaction(
      from: EthereumAddress.fromHex(connectedEVMAddress!),
      to: EthereumAddress.fromHex(to),
      data: data != null ? hexToBytes(data) : null,
      value: value != null ? EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.parse(value.substring(2), radix: 16)) : null,
    );

    final txHash = await _w3mService!.request(
      topic: _w3mService!.session!.topic!,
      chainId: chainId ?? 'eip155:${_w3mService!.selectedChain!.chainId}',
      request: SessionRequest(
        method: 'eth_sendTransaction',
        params: [transaction.toJson()],
      ),
    );
    return txHash.toString();
  }

  // --- Solana remains unsupported on web ---
  Future<String?> connectSolanaWallet() async {
    throw UnsupportedError("Solana wallet connection is not available on web.");
  }

  Future<void> disconnectSolanaWallet() async {
    throw UnsupportedError("Solana wallet is not available on web.");
  }
}
