// lib/features/wallet/application/wallet_provider.dart
import 'dart:math'; // <-- FIX 1: ADDED THIS IMPORT
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';
import '../../../core/services/wallet_service.dart';
import '../../../services/web3_service.dart';

class WalletProvider with ChangeNotifier {
  final WalletService _walletService;
  final Web3Service _web3Service;

  WalletProvider(this._walletService, this._web3Service);

  bool _isLoadingEVM = false;
  bool get isLoadingEVM => _isLoadingEVM;
  String? get connectedEVMAddress => _walletService.connectedEVMAddress;
  String? get currentEVMChainId => _walletService.currentEVMChainId;
  bool get isConnectedEVM => _walletService.isConnectedEVM;
  String? _evmError;
  String? get evmError => _evmError;
  
  bool _isLoadingSolana = false;
  bool get isLoadingSolana => _isLoadingSolana;
  String? get connectedSolanaAddress => _walletService.connectedSolanaAddress;
  bool get isConnectedSolana => _walletService.isConnectedSolana;
  String? _solanaError;
  String? get solanaError => _solanaError;

  bool get isLoading => _isLoadingEVM || _isLoadingSolana;

  Future<void> connectEVMWallet({required BuildContext context}) async {
    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();
    try {
      await _walletService.connectEVMWallet(context: context);
    } catch (e) {
      if (e is UnsupportedError) {
        _evmError = "EVM Wallet connection is not available on this platform.";
      } else {
        _evmError = "Connection failed or was cancelled by user.";
      }
      debugPrint("WalletProvider EVM Connect Error: $e");
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  Future<void> disconnectEVMWallet() async {
    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();
    try {
      await _walletService.disconnectEVMWallet();
    } catch (e) {
      _evmError = e.toString();
      debugPrint("WalletProvider EVM Disconnect Error: $e");
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  /// Sends a pre-built transaction to the user's wallet for signing and execution.
  Future<String?> sendTransaction(Transaction transaction) async {
    if (!isConnectedEVM) {
      _evmError = "EVM Wallet not connected for transaction.";
      notifyListeners();
      throw Exception(_evmError);
    }
    
    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();

    try {
      final String? toAddress = transaction.to?.hex;
      if (toAddress == null) {
        throw Exception("Transaction 'to' address is missing.");
      }

      final hexData = transaction.data != null ? bytesToHex(transaction.data!, include0x: true) : null;
      final hexValue = transaction.value?.getInWei.toRadixString(16);

      final txHash = await _walletService.sendEVMTransaction(
        to: toAddress,
        data: hexData,
        value: hexValue != null ? '0x$hexValue' : null,
      );
      
      return txHash;

    } catch (e) {
      _evmError = "Transaction failed: $e";
      debugPrint("WalletProvider Transaction Error: $_evmError");
      rethrow;
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  // --- NEW METHOD FOR TOKEN DEPLOYMENT ---
  Future<String?> deployERC20Token({
    required String name,
    required String symbol,
    required BigInt initialSupply,
  }) async {
    if (!isConnectedEVM) {
      _evmError = "EVM Wallet not connected for deployment.";
      notifyListeners();
      throw Exception(_evmError);
    }

    _isLoadingEVM = true;
    _evmError = null;
    notifyListeners();

    try {
      // IMPORTANT: Getting user's private key is not possible with WalletConnect/MetaMask.
      // A real DApp would deploy contracts from a backend server (a "hot wallet")
      // or use a contract factory pattern where the user just calls a function on an
      // existing factory contract.
      // For this simulation, we'll create a random, temporary credential set.
      final credentials = EthPrivateKey.createRandom(Random.secure());
      
      // FIX 2: Corrected the function name to match what's in Web3Service
      final contractAddress = await _web3Service.deployAndInitializeERC20(
        name: name,
        symbol: symbol,
        initialSupply: initialSupply,
        credentials: credentials, // In a real app, this would be handled differently.
      );
      
      return contractAddress;

    } catch (e) {
      _evmError = "Deployment failed: $e";
      debugPrint("WalletProvider Deployment Error: $_evmError");
      rethrow;
    } finally {
      _isLoadingEVM = false;
      notifyListeners();
    }
  }

  Future<void> connectSolanaWallet() async {
    _isLoadingSolana = true;
    _solanaError = null;
    notifyListeners();
    try {
      await _walletService.connectSolanaWallet();
    } catch (e) {
      _solanaError = "Connection failed or was cancelled.";
      debugPrint("WalletProvider Solana Connect Error: $e");
    } finally {
      _isLoadingSolana = false;
      notifyListeners();
    }
  }

  Future<void> disconnectSolanaWallet() async {
    _isLoadingSolana = true;
    _solanaError = null;
    notifyListeners();
    try {
      await _walletService.disconnectSolanaWallet();
    } catch (e) {
      _solanaError = e.toString();
      debugPrint("WalletProvider Solana Disconnect Error: $e");
    } finally {
      _isLoadingSolana = false;
      notifyListeners();
    }
  }

  void clearEVMErrors() {
    _evmError = null;
    notifyListeners();
  }

  void clearSolanaErrors() { 
    _solanaError = null; 
    notifyListeners(); 
  }
}
