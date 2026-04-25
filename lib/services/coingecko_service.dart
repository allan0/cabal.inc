// lib/services/coingecko_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/coin_model.dart';

class CoinGeckoService {
  final String _baseUrl = "https://api.coingecko.com/api/v3";

  Future<List<Coin>> fetchTrendingCoins(int limit) async {
    final url = '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=false&price_change_percentage=24h';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Coin.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load trending coins. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching trending coins: $e');
      // Return an empty list or rethrow the exception, depending on how you want to handle errors.
      return [];
    }
  }
}
