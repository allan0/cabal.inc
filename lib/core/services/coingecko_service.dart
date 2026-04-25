// lib/core/services/coingecko_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:cabal/config.dart'; // Import the new config helper
import '../../models/coin_data_model.dart';

class CoinGeckoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';
  late final String _apiKey;

  CoinGeckoService() {
    // Use AppConfig to get the API key
    _apiKey = AppConfig.coingeckoApiKey;
    if (_apiKey.isEmpty) {
      debugPrint("CoinGeckoService WARNING: COINGECKO_API_KEY not found in environment.");
    }
  }

  Map<String, String> get _headers => {
        'accept': 'application/json',
        'x-cg-demo-api-key': _apiKey,
      };

  Future<List<CoinData>> getTrendingCoins({int topN = 100}) async {
    final String url = '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$topN&page=1&sparkline=false&price_change_percentage=24h';
    try {
      debugPrint("CoinGeckoService: Fetching top $topN trending coins from $url");
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        debugPrint("CoinGeckoService: Successfully fetched ${jsonList.length} market coins.");
        return jsonList.map((json) => CoinData.fromJson(json)).toList();
      } else {
        debugPrint("CoinGeckoService: Failed to load market data: ${response.statusCode} ${response.body}");
        throw Exception('Failed to load market data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("CoinGeckoService: Error fetching market data: $e");
      throw Exception('Error fetching market data: $e');
    }
  }

  Future<List<dynamic>> getCoinChartData(String coinId) async {
    final String url = '$_baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=14';
    try {
      debugPrint("CoinGeckoService: Fetching chart data for $coinId from $url");
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['prices'] as List<dynamic>;
      } else {
        debugPrint("CoinGeckoService: Failed to load chart data: ${response.statusCode} ${response.body}");
        throw Exception('Failed to load chart data for $coinId: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("CoinGeckoService: Error fetching chart data for $coinId: $e");
      throw Exception('Error fetching chart data for $coinId: $e');
    }
  }
}
