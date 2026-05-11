import 'dart:math';

class UserProfile {
  final String id; // UUID from auth.users
  String? displayName;
  String? telegramUsername;
  String? profileImageUrl;
  int totalXp;
  int level;
  
  // FIXED: Renamed to connected_wallets to match Service calls
  Map<String, dynamic> connected_wallets;
  // FIXED: Renamed to connected_socials for consistency
  Map<String, dynamic> connected_socials;
  
  // Array Columns (TEXT[] / UUID[])
  List<String> preferredCoinIds;
  List<String> interests;
  List<String> favoritedCabalIds;
  List<String> joinedCabalIds;
  List<String> earnedAchievementIds;
  List<String> favoritedNewsLinks;

  // Referral & Verification
  String? referralCode;
  String? referredBy; // UUID of the referrer
  String? twitterHandle;
  bool isTwitterVerified;
  bool isAdmin;

  // Timestamps
  final DateTime? createdAt;
  DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.displayName,
    this.telegramUsername,
    this.profileImageUrl,
    this.totalXp = 0,
    this.level = 1,
    this.connected_wallets = const {},
    this.connected_socials = const {},
    this.preferredCoinIds = const [],
    this.interests = const [],
    this.favoritedCabalIds = const [],
    this.joinedCabalIds = const [],
    this.earnedAchievementIds = const [],
    this.favoritedNewsLinks = const [],
    this.referralCode,
    this.referredBy,
    this.twitterHandle,
    this.isTwitterVerified = false,
    this.isAdmin = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Logic for Level calculation matching the SQL: floor(sqrt(v_new_xp / 100.0)) + 1
  static int calculateLevelFromXp(int xp) {
    if (xp <= 0) return 1;
    return (sqrt(xp / 100.0).floor()) + 1;
  }

  /// Alias for fromSupabase to fix compatibility with SupabaseService
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile.fromSupabase(json);

  /// Maps Supabase JSON response to the UserProfile model
  factory UserProfile.fromSupabase(Map<String, dynamic> data) {
    final int xp = (data['total_xp'] ?? 0) as int;
    
    return UserProfile(
      id: data['id'] as String,
      displayName: data['display_name'] as String?,
      telegramUsername: data['telegram_username'] as String?,
      profileImageUrl: data['profile_image_url'] as String?,
      totalXp: xp,
      level: (data['level'] ?? calculateLevelFromXp(xp)) as int,
      
      // Fixed field names
      connected_wallets: data['connected_wallets'] != null 
          ? Map<String, dynamic>.from(data['connected_wallets']) 
          : {},
      connected_socials: data['connected_socials'] != null 
          ? Map<String, dynamic>.from(data['connected_socials']) 
          : {},

      preferredCoinIds: _parseList(data['preferred_coin_ids']),
      interests: _parseList(data['interests']),
      favoritedCabalIds: _parseList(data['favorited_cabal_ids']),
      joinedCabalIds: _parseList(data['joined_cabal_ids']),
      earnedAchievementIds: _parseList(data['earned_achievement_ids']),
      favoritedNewsLinks: _parseList(data['favorited_news_links']),

      referralCode: data['referral_code'] as String?,
      referredBy: data['referred_by'] as String?,
      twitterHandle: data['twitter_handle'] as String?,
      isTwitterVerified: (data['is_twitter_verified'] ?? false) as bool,
      isAdmin: (data['is_admin'] ?? false) as bool,
      
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'] as String) 
          : null,
      updatedAt: data['updated_at'] != null 
          ? DateTime.tryParse(data['updated_at'] as String) 
          : null,
    );
  }

  /// Converts the model to a Map for Supabase updates
  Map<String, dynamic> toSupabase() {
    return {
      'display_name': displayName,
      'telegram_username': telegramUsername,
      'profile_image_url': profileImageUrl,
      'total_xp': totalXp,
      'level': level,
      'connected_wallets': connected_wallets,
      'connected_socials': connected_socials,
      'preferred_coin_ids': preferredCoinIds,
      'interests': interests,
      'favorited_cabal_ids': favoritedCabalIds,
      'joined_cabal_ids': joinedCabalIds,
      'earned_achievement_ids': earnedAchievementIds,
      'favorited_news_links': favoritedNewsLinks,
      'twitter_handle': twitterHandle,
      'is_twitter_verified': isTwitterVerified,
      'is_admin': isAdmin,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static List<String> _parseList(dynamic data) {
    if (data == null) return [];
    return List<String>.from(data.map((item) => item.toString()));
  }

  // Updated helper methods to use snake_case
  bool hasWallet(String chain) => connected_wallets.containsKey(chain.toLowerCase());
  String? get tonAddress => connected_wallets['ton']?.toString();
}
