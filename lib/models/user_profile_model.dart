import 'dart:math';

class UserProfile {
  final String id; // UUID from Supabase Auth
  final String? displayName;
  final String? profileImageUrl;
  final int totalXp;
  final int level;
  final Map<String, dynamic> connectedWallets;
  final List<String> joinedCabalIds;
  final String? referralCode;

  UserProfile({
    required this.id,
    this.displayName,
    this.profileImageUrl,
    this.totalXp = 0,
    this.level = 1,
    this.connectedWallets = const {},
    this.joinedCabalIds = const [],
    this.referralCode,
  });

  /// Real-time level calculation based on exponential XP curve
  static int calculateLevelFromXp(int xp) {
    if (xp <= 0) return 1;
    return (sqrt(xp / 100.0).floor()) + 1;
  }

  factory UserProfile.fromSupabase(Map<String, dynamic> data) {
    final int xp = (data['total_xp'] ?? 0) as int;
    return UserProfile(
      id: data['id'] as String,
      displayName: data['display_name'] as String?,
      profileImageUrl: data['profile_image_url'] as String?,
      totalXp: xp,
      level: (data['level'] ?? calculateLevelFromXp(xp)) as int,
      connectedWallets: data['connected_wallets'] != null 
          ? Map<String, dynamic>.from(data['connected_wallets']) 
          : {},
      joinedCabalIds: data['joined_cabal_ids'] != null
          ? List<String>.from(data['joined_cabal_ids'])
          : [],
      referralCode: data['referral_code'] as String?,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'display_name': displayName,
      'profile_image_url': profileImageUrl,
      'connected_wallets': connectedWallets,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Getters for primary addresses
  String? get tonAddress => connectedWallets['ton']?.toString();
  String? get evmAddress => connectedWallets['evm']?.toString();
}
