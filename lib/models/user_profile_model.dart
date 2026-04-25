// lib/models/user_profile_model.dart
import 'marketplace_models.dart'; // CORRECTED: Was 'package.cabal/models/marketplace_models.dart'
import '../utils/constants.dart'; // For calculateLevel function

class UserProfile {
  final String id; // Supabase Auth User ID (UUID) - Primary Key
  String? displayName;
  String? telegramUsername;
  int totalXp;
  int level;
  String? profileImageUrl;
  Map<String, String> connectedWallets;
  Map<String, String> connectedSocials;
  List<String> preferredCoinIds;
  List<String> interests;
  List<String> favoritedCabalIds;
  List<String> joinedCabalIds;
  List<String> earnedAchievementIds;
  List<String> followersUserIds;
  List<String> followingUserIds;
  bool isAdmin;
  final DateTime? createdAt;
  DateTime? lastUpdatedAt;

  // --- NEW: Referral and Verification Fields ---
  String? referralCode;
  String? referredBy;
  String? twitterHandle;
  bool? is_twitter_verified; // Using snake_case to match DB
  // --- END OF NEW FIELDS ---
  
  // --- NEW: News Favorites ---
  List<String> favoritedNewsLinks;

  int? followerCount;
  int? followingCount;
  bool? isFollowedByCurrentUser;

  // --- Enriched Profile Data ---
  List<ProjectListing>? createdProjectListings;
  DeveloperProfile? developerProfile;

  UserProfile({
    required this.id,
    this.displayName,
    this.telegramUsername,
    this.totalXp = 0,
    this.level = 1,
    this.profileImageUrl,
    this.connectedWallets = const {},
    this.connectedSocials = const {},
    this.preferredCoinIds = const [],
    this.interests = const [],
    this.favoritedCabalIds = const [],
    this.joinedCabalIds = const [],
    this.earnedAchievementIds = const [],
    this.followersUserIds = const [],
    this.followingUserIds = const [],
    this.isAdmin = false,
    this.createdAt,
    this.lastUpdatedAt,
    
    // NEW
    this.referralCode,
    this.referredBy,
    this.twitterHandle,
    this.is_twitter_verified,
    this.favoritedNewsLinks = const [], // NEW
    
    this.followerCount,
    this.followingCount,
    this.isFollowedByCurrentUser,
    
    // Enriched
    this.createdProjectListings,
    this.developerProfile,
  });

  factory UserProfile.fromSupabase(Map<String, dynamic> data) {
    int currentTotalXp = (data['total_xp'] ?? 0) as int;
    String? fetchedDisplayName = data['display_name'] as String?;
    String? fetchedTelegramUsername = data['telegram_username'] as String?;

    // --- FIX: Generate a sensible default display name to prevent 'NULL' ---
    String defaultName = 'User-${(data['id'] as String).substring(0, 6)}';

    String effectiveDisplayName = (fetchedDisplayName != null && fetchedDisplayName.trim().isNotEmpty)
        ? fetchedDisplayName.trim()
        : (fetchedTelegramUsername != null && fetchedTelegramUsername.trim().isNotEmpty)
            ? fetchedTelegramUsername.trim()
            : defaultName;

    return UserProfile(
      id: data['id'] as String,
      displayName: effectiveDisplayName,
      telegramUsername: fetchedTelegramUsername,
      totalXp: currentTotalXp,
      level: (data['level'] ?? calculateLevel(currentTotalXp)) as int,
      profileImageUrl: data['profile_image_url'] as String?,
      connectedWallets: data['connected_wallets'] != null
          ? Map<String, String>.from(data['connected_wallets'])
          : {},
      connectedSocials: data['connected_socials'] != null
          ? Map<String, String>.from(data['connected_socials'])
          : {},
      preferredCoinIds: data['preferred_coin_ids'] != null
          ? List<String>.from(data['preferred_coin_ids'].map((item) => item.toString()))
          : [],
      interests: data['interests'] != null
          ? List<String>.from(data['interests'].map((item) => item.toString()))
          : [],
      favoritedCabalIds: data['favorited_cabal_ids'] != null
          ? List<String>.from(data['favorited_cabal_ids'].map((item) => item.toString()))
          : [],
      joinedCabalIds: data['joined_cabal_ids'] != null
          ? List<String>.from(data['joined_cabal_ids'].map((item) => item.toString()))
          : [],
      earnedAchievementIds: data['earned_achievement_ids'] != null
          ? List<String>.from(data['earned_achievement_ids'].map((item) => item.toString()))
          : [],
      followersUserIds: data['followers_user_ids'] != null
          ? List<String>.from(data['followers_user_ids'].map((item) => item.toString()))
          : [],
      followingUserIds: data['following_user_ids'] != null
          ? List<String>.from(data['following_user_ids'].map((item) => item.toString()))
          : [],
      isAdmin: (data['is_admin'] ?? false) as bool,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
      lastUpdatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'] as String)
          : null,
      
      // NEW
      referralCode: data['referral_code'] as String?,
      referredBy: data['referred_by'] as String?,
      twitterHandle: data['twitter_handle'] as String?,
      is_twitter_verified: (data['is_twitter_verified'] ?? false) as bool,
      // --- FIX: Read the new column from the database ---
      favoritedNewsLinks: data['favorited_news_links'] != null 
          ? List<String>.from(data['favorited_news_links'].map((item) => item.toString()))
          : [],
    );
  }

  factory UserProfile.fromProfileDetails(Map<String, dynamic> data) {
    final profileData = data['profile'] as Map<String, dynamic>? ?? {};
    final baseProfile = UserProfile.fromSupabase(profileData);

    baseProfile.followerCount = (data['follower_count'] ?? 0) as int;
    baseProfile.followingCount = (data['following_count'] ?? 0) as int;
    baseProfile.isFollowedByCurrentUser = (data['is_followed_by_current_user'] ?? false) as bool;
    
    final devProfileData = data['developer_profile'] as Map<String, dynamic>?;
    if (devProfileData != null) {
      devProfileData['creator_profile'] = {
        'display_name': baseProfile.displayName,
        'profile_image_url': baseProfile.profileImageUrl,
      };
      baseProfile.developerProfile = DeveloperProfile.fromSupabase(devProfileData);
    }

    final listingsData = data['project_listings'] as List?;
    if (listingsData != null) {
      baseProfile.createdProjectListings = listingsData.map((listing) {
        (listing as Map<String, dynamic>)['creator_profile'] = {
            'display_name': baseProfile.displayName,
            'profile_image_url': baseProfile.profileImageUrl,
        };
        return ProjectListing.fromSupabase(listing);
      }).toList();
    }
    
    return baseProfile;
  }

  Map<String, dynamic> toSupabase() {
    Map<String,dynamic> mapData = {
      if (displayName != null && displayName!.trim().isNotEmpty) 'display_name': displayName!.trim(),
      'telegram_username': (telegramUsername == null || telegramUsername!.trim().isEmpty) ? null : telegramUsername!.trim(),
      'total_xp': totalXp,
      'level': level,
      'profile_image_url': profileImageUrl,
      'connected_wallets': connectedWallets,
      'connected_socials': connectedSocials,
      'preferred_coin_ids': preferredCoinIds,
      'interests': interests,
      'favorited_cabal_ids': favoritedCabalIds,
      'joined_cabal_ids': joinedCabalIds,
      'earned_achievement_ids': earnedAchievementIds,
      'followers_user_ids': followersUserIds,
      'following_user_ids': followingUserIds,
      'is_admin': isAdmin,
      
      'twitter_handle': twitterHandle,
      'is_twitter_verified': is_twitter_verified,
      // --- FIX: Write the new column to the database ---
      'favorited_news_links': favoritedNewsLinks,
    };
    
    return mapData;
  }
}
