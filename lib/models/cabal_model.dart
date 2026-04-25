// lib/models/cabal_model.dart
class Cabal {
    final String id;
    String name;
    String description;
    final String creatorId;
    String? creatorHandle;
    String? logoUrl;
    String? bannerImageUrl;
    String? projectUrl;
    List<String> questSectionOrder;
    String? dailyChallengeHeader;
    Map<String, dynamic>? theme;
    String? category;
    bool isPrivate;
    final DateTime? createdAt;
    DateTime? updatedAt;

    // --- WEB3 UPDATE: New fields for token integration ---
    String? tokenContractAddress;
    int? chainId;
    String? tokenSymbol;

  Cabal({
      required this.id,
      required this.name,
      required this.description,
      required this.creatorId,
      this.creatorHandle,
      this.logoUrl,
      this.bannerImageUrl,
      this.projectUrl,
      this.questSectionOrder = const [],
      this.dailyChallengeHeader,
      this.category,
      this.theme,
      this.isPrivate = false,
      this.createdAt,
      this.updatedAt,
      // --- WEB3 UPDATE ---
      this.tokenContractAddress,
      this.chainId,
      this.tokenSymbol,
  });

  factory Cabal.fromSupabase(Map<String, dynamic> data) {
    return Cabal(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      creatorId: data['creator_id'] as String,
      creatorHandle: data['creator_handle'] as String?,
      logoUrl: data['logo_url'] as String?,
      bannerImageUrl: data['banner_image_url'] as String?,
      projectUrl: data['project_url'] as String?,
      questSectionOrder: data['quest_section_order'] != null ? List<String>.from(data['quest_section_order']) : [],
      dailyChallengeHeader: data['daily_challenge_header'] as String?,
      category: data['category'] as String?,
      theme: data['theme'] != null ? Map<String, dynamic>.from(data['theme']) : null,
      isPrivate: (data['is_private'] ?? false) as bool,
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at'] as String) : null,
      // --- WEB3 UPDATE ---
      tokenContractAddress: data['token_contract_address'] as String?,
      chainId: (data['chain_id'] as num?)?.toInt(),
      tokenSymbol: data['token_symbol'] as String?,
    );
  }
  
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator_id': creatorId,
      'creator_handle': creatorHandle,
      'logo_url': logoUrl,
      'banner_image_url': bannerImageUrl,
      'project_url': projectUrl,
      'quest_section_order': questSectionOrder,
      'daily_challenge_header': dailyChallengeHeader,
      'category': category,
      'theme': theme,
      'is_private': isPrivate,
      // --- WEB3 UPDATE ---
      'token_contract_address': tokenContractAddress,
      'chain_id': chainId,
      'token_symbol': tokenSymbol,
    };
  }
}
