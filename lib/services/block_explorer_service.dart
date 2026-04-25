// lib/services/block_explorer_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlockExplorerService {
  final bool _isTestnet = kDebugMode;
  late final String _baseUrl;
  late final String _apiKey;

  BlockExplorerService() {
    _baseUrl = _isTestnet 
        ? 'https://api-sepolia.etherscan.io/api' 
        : 'https://api.etherscan.io/api';
    // UPDATED: Read API key from build environment on web, .env on mobile
    _apiKey = kIsWeb 
      ? const String.fromEnvironment('ETHERSCAN_API_KEY') 
      : dotenv.env['ETHERSCAN_API_KEY'] ?? '';
  }

  Future<int> getTokenHolderCount(String contractAddress) async {
    debugPrint("BlockExplorerService: Simulating fetch for token holder count.");
    await Future.delayed(const Duration(milliseconds: 800));
    return 1842;
  }

  Future<int> getTransactions24h(String contractAddress) async {
    debugPrint("BlockExplorerService: Simulating fetch for 24h transaction count.");
    await Future.delayed(const Duration(milliseconds: 600));
    return 431;
  }

  Future<List<Map<String, String>>> getRecentTransfers(String contractAddress, {int count = 10}) async {
    debugPrint("BlockExplorerService: Simulating fetch for recent transfers.");
    await Future.delayed(const Duration(milliseconds: 1000));
    return [
      {'hash': '0x1a2b...cdef', 'from': '0xAbC...123', 'to': '0xDeF...456', 'amount': '5,000 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String()},
      {'hash': '0x3c4d...ghij', 'from': 'Presale Contract', 'to': '0xGhi...789', 'amount': '10,000 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String()},
      {'hash': '0x5e6f...klmn', 'from': '0xJkL...abc', 'to': '0xMnP...def', 'amount': '250 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 22)).toIso8601String()},
      {'hash': '0x7g8h...opqr', 'from': '0xQrS...ghi', 'to': '0xTuV...jkl', 'amount': '1,200 CBL', 'timestamp': DateTime.now().subtract(const Duration(minutes: 31)).toIso8601String()},
    ];
  }

  Future<double> getTokenPrice() async {
    debugPrint("BlockExplorerService: Simulating fetch for token price.");
    await Future.delayed(const Duration(milliseconds: 300));
    return 0.025;
  }
}
