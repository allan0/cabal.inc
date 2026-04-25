// lib/core/services/wallet_service_stub.dart
// This is the WEB implementation using Reown AppKit.

import 'dart:async';
import 'package:cabal/main.dart'; // Import to get the navigatorKey
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletType {
  static const String evm = 'evm';
  static const String solana = 'solana';
}

class WalletService {
  ReownAppKitModal? _appKitModal;

  String? get connectedEVMAddress {
    final session = _appKitModal?.session;
    if (session == null) return null;
    final namespaces = session.namespaces;
    if (namespaces == null) return null;
    final accounts = namespaces['eip155']?.accounts;
    if (accounts == null || accounts.isEmpty) return null;
    return NamespaceUtils.getAccount(accounts.first);
  }
  String? get currentEVMChainId => _appKitModal?.selectedChain?.chainId;
  bool get isConnectedEVM => _appKitModal?.isConnected ?? false;
  
  String? get connectedSolanaAddress => null;
  bool get isConnectedSolana => false;

  Future<void> initialize() async {
    // Read directly from build environment since this is a web-only stub
    const projectId = String.fromEnvironment('WALLET_CONNECT_PROJECT_ID');
    if (projectId.isEmpty) {
      debugPrint("WalletService (Web) FATAL: WALLET_CONNECT_PROJECT_ID not defined in build environment.");
      return;
    }
    
    const sepoliaRpc = String.fromEnvironment('SEPOLIA_RPC_URL');
    if (sepoliaRpc.isEmpty) {
      throw Exception('SEPOLIA_RPC_URL not defined in build environment.');
    }

    const mainnetRpc = String.fromEnvironment('MAINNET_RPC_URL');
    if (mainnetRpc.isEmpty) {
      throw Exception('MAINNET_RPC_URL not defined in build environment.');
    }
    
    final sepoliaChain = ReownAppKitModalNetworkInfo(
      name: 'Sepolia',
      chainId: '11155111',
      currency: 'ETH',
      rpcUrl: sepoliaRpc,
      explorerUrl: 'https://sepolia.etherscan.io',
    );
    final mainnetChain = ReownAppKitModalNetworkInfo(
      name: 'Ethereum',
      chainId: '1',
      currency: 'ETH',
      rpcUrl: mainnetRpc,
      explorerUrl: 'https://etherscan.io',
    );

    _appKitModal = ReownAppKitModal(
      context: navigatorKey.currentContext!,
      projectId: projectId,
      metadata: const PairingMetadata(
        name: 'Cabal',
        description: 'Cabal Quest Platform',
        url: 'https://cabal-001.web.app',
        icons: ['https://cabal-001.web.app/icon.png'],
        redirect: Redirect(
          native: 'cabal://',
          universal: 'https://cabal-001.web.app',
          linkMode: true,
        ),
      ),
      includedWalletIds: {
        'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96',
        '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0',
        'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa',
      },
    );

    await _appKitModal!.init();
    
    _appKitModal!.selectChain(kDebugMode ? sepoliaChain : mainnetChain);
    
    debugPrint("WalletService (Web): Reown AppKit client initialized.");
  }

  Future<String?> connectEVMWallet({required BuildContext context}) async {
    if (isConnectedEVM) return connectedEVMAddress;
    if (_appKitModal == null) throw Exception("Reown AppKit service not initialized.");

    try {
      await _appKitModal!.openModalView(const SizedBox.shrink());
      return connectedEVMAddress;
    } catch (e) {
      debugPrint('Error connecting wallet via Reown AppKit: $e');
      await disconnectEVMWallet();
      rethrow;
    }
  }

  Future<void> disconnectEVMWallet() async {
    if (_appKitModal != null && _appKitModal!.isConnected) {
      await _appKitModal!.disconnect();
    }
    debugPrint("WalletService (Web): EVM wallet disconnected.");
  }

  Future<String?> signEVMMessage(String message, {String? chainId}) async {
    if (!isConnectedEVM || _appKitModal == null) throw Exception("EVM Wallet not connected.");
    
    final signature = await _appKitModal!.request(
      topic: _appKitModal!.session!.topic!,
      chainId: chainId ?? 'eip155:${_appKitModal!.selectedChain!.chainId}',
      request: SessionRequestParams(
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
    if (!isConnectedEVM || _appKitModal == null) throw Exception("EVM Wallet not connected.");
    
    final transaction = Transaction(
      from: EthereumAddress.fromHex(connectedEVMAddress!),
      to: EthereumAddress.fromHex(to),
      data: data != null ? hexToBytes(data) : null,
      value: value != null ? EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(value.substring(2), radix: 16)) : null,
    );

    final txHash = await _appKitModal!.request(
      topic: _appKitModal!.session!.topic!,
      chainId: chainId ?? 'eip155:${_appKitModal!.selectedChain!.chainId}',
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        params: [transaction.toJson()],
      ),
    );
    return txHash.toString();
  }

  Future<String?> connectSolanaWallet() async {
    throw UnsupportedError("Solana wallet connection is not available on web.");
  }

  Future<void> disconnectSolanaWallet() async {
    throw UnsupportedError("Solana wallet is not available on web.");
  }
}
