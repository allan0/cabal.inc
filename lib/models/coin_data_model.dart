// lib/models/coin_data_model.dart

class CoinData {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double? currentPrice; // <-- ADD THIS
  final double? priceChangePercentage24h; // <-- ADD THIS

  CoinData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    this.currentPrice, // <-- ADD THIS
    this.priceChangePercentage24h, // <-- ADD THIS
  });

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      imageUrl: json['image'] as String,
      // Handle potential null or incorrect types from the API
      currentPrice: (json['current_price'] as num?)?.toDouble(), // <-- ADD THIS
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble(), // <-- ADD THIS
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': imageUrl,
      'current_price': currentPrice, // <-- ADD THIS
      'price_change_percentage_24h': priceChangePercentage24h, // <-- ADD THIS
    };
  }
}
