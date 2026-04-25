// lib/data/repositories/coin_repository.dart
import '../../models/coin_data_model.dart';
import '../../core/services/coingecko_service.dart';

class CoinRepository {
  final CoinGeckoService _coinGeckoService;

  CoinRepository(this._coinGeckoService);

  Future<List<CoinData>> getTopNCoinData({int count = 100}) async {
    try {
      return await _coinGeckoService.getTrendingCoins(topN: count);
    } catch (e) {
      // Log or re-throw as appropriate for your error handling strategy
      rethrow;
    }
  }
}
