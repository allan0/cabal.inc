// lib/models/coin_model.dart

class Coin {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double? priceChangePercentage24h;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    this.priceChangePercentage24h,
  });

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      id: map['id'] ?? '',
      symbol: map['symbol'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['image'] ?? '',
      currentPrice: (map['current_price'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h: (map['price_change_percentage_24h'] as num?)?.toDouble(),
    );
  }
}
