// lib/models/merchandise_product_model.dart

class MerchandiseProduct {
  final String id;
  final String cabalId;
  final String creatorUserId;
  final int productIdOnChain;
  final String name;
  final String? description;
  final String? imageUrl;
  final String paymentTokenAddress;
  final String paymentTokenSymbol;
  final String priceInWei;
  final String? bonusTokenAddress;
  final String? bonusTokenSymbol;
  final String? bonusAmountInWei;
  final bool isActive;
  final DateTime createdAt;

  MerchandiseProduct({
    required this.id,
    required this.cabalId,
    required this.creatorUserId,
    required this.productIdOnChain,
    required this.name,
    this.description,
    this.imageUrl,
    required this.paymentTokenAddress,
    required this.paymentTokenSymbol,
    required this.priceInWei,
    this.bonusTokenAddress,
    this.bonusTokenSymbol,
    this.bonusAmountInWei,
    required this.isActive,
    required this.createdAt,
  });

  /// Convenience getter to display the price in its standard unit (assumes 18 decimals).
  double get price {
    final wei = BigInt.tryParse(priceInWei) ?? BigInt.zero;
    return wei.toDouble() / 1e18;
  }

  /// Convenience getter to display the bonus amount in its standard unit (assumes 18 decimals).
  double? get bonusAmount {
    if (bonusAmountInWei == null) return null;
    final wei = BigInt.tryParse(bonusAmountInWei!) ?? BigInt.zero;
    return wei.toDouble() / 1e18;
  }

  factory MerchandiseProduct.fromSupabase(Map<String, dynamic> data) {
    return MerchandiseProduct(
      id: data['id'] as String,
      cabalId: data['cabal_id'] as String,
      creatorUserId: data['creator_user_id'] as String,
      productIdOnChain: (data['product_id_onchain'] as num).toInt(),
      name: data['name'] as String,
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String?,
      paymentTokenAddress: data['payment_token_address'] as String,
      paymentTokenSymbol: data['payment_token_symbol'] as String,
      priceInWei: data['price_in_wei'] as String,
      bonusTokenAddress: data['bonus_token_address'] as String?,
      bonusTokenSymbol: data['bonus_token_symbol'] as String?,
      bonusAmountInWei: data['bonus_amount_in_wei'] as String?,
      isActive: data['is_active'] as bool,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'cabal_id': cabalId,
      'creator_user_id': creatorUserId,
      'product_id_onchain': productIdOnChain,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'payment_token_address': paymentTokenAddress,
      'payment_token_symbol': paymentTokenSymbol,
      'price_in_wei': priceInWei,
      'bonus_token_address': bonusTokenAddress,
      'bonus_token_symbol': bonusTokenSymbol,
      'bonus_amount_in_wei': bonusAmountInWei,
      'is_active': isActive,
    };
  }
}
