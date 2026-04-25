// lib/models/nft_listing_model.dart
import 'package:web3dart/web3dart.dart';

class NftListing {
  final String id;
  final String nftContractAddress;
  final int tokenId;
  final String sellerAddress;
  final String priceWei;
  final bool isActive;
  final String? listerUserId;
  final String? tokenUri;
  final String? nftName;
  final String? nftImageUrl;
  final String? collectionName;
  final DateTime createdAt;

  NftListing({
    required this.id,
    required this.nftContractAddress,
    required this.tokenId,
    required this.sellerAddress,
    required this.priceWei,
    required this.isActive,
    this.listerUserId,
    this.tokenUri,
    this.nftName,
    this.nftImageUrl,
    this.collectionName,
    required this.createdAt,
  });

  /// Convenience getter to display the price in Ether.
  double get priceInEth {
    final wei = BigInt.tryParse(priceWei) ?? BigInt.zero;
    return EtherAmount.inWei(wei).getValueInUnit(EtherUnit.ether);
  }

  factory NftListing.fromSupabase(Map<String, dynamic> data) {
    return NftListing(
      id: data['id'] as String,
      nftContractAddress: data['nft_contract_address'] as String,
      tokenId: (data['token_id'] as num).toInt(),
      sellerAddress: data['seller_address'] as String,
      priceWei: data['price_wei'] as String,
      isActive: data['is_active'] as bool,
      listerUserId: data['lister_user_id'] as String?,
      tokenUri: data['token_uri'] as String?,
      nftName: data['nft_name'] as String?,
      nftImageUrl: data['nft_image_url'] as String?,
      collectionName: data['collection_name'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'nft_contract_address': nftContractAddress,
      'token_id': tokenId,
      'seller_address': sellerAddress,
      'price_wei': priceWei,
      'is_active': isActive,
      'lister_user_id': listerUserId,
      'token_uri': tokenUri,
      'nft_name': nftName,
      'nft_image_url': nftImageUrl,
      'collection_name': collectionName,
    };
  }
}
