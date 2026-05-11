import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';
import '../models/cabal_model.dart';
import '../models/quest_model.dart';
import '../models/quest_section_model.dart';
import '../models/notification_model.dart';
import '../models/community_post_model.dart';
import '../models/activity_model.dart';
import '../models/marketplace_models.dart';
import '../models/merchandise_product_model.dart';
import '../models/nft_listing_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ====================== AUTH & SESSION ======================

  User? getCurrentUser() => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signOutUser() async => await _client.auth.signOut();

  // ====================== PROFILE LOGIC ======================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return UserProfile.fromJson(data); // Matches the fromJson in the model
    } catch (e) {
      debugPrint("SupabaseService: Error fetching profile: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final user = getCurrentUser();
    if (user == null) return;
    await _client.from('profiles').update(updates).eq('id', user.id);
  }

  Future<void> addWallet(String address, String chain) async {
    final user = getCurrentUser();
    if (user == null) return;

    final profile = await getUserProfile(user.id);
    if (profile == null) return;

    final Map<String, dynamic> currentWallets = Map<String, dynamic>.from(profile.connected_wallets);
    currentWallets[chain.toLowerCase()] = address;

    await _client.from('profiles').update({
      'connected_wallets': currentWallets,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  // ====================== CABAL LOGIC ======================

  Future<List<Cabal>> getAllCabals() async {
    final List<dynamic> data = await _client
        .from('cabals')
        .select()
        .order('created_at', ascending: false);
    return data.map((json) => Cabal.fromSupabase(json)).toList();
  }

  Future<Cabal?> getCabal(String cabalId) async {
    final data = await _client.from('cabals').select().eq('id', cabalId).maybeSingle();
    return data != null ? Cabal.fromSupabase(data) : null;
  }

  Future<Cabal?> createCabal({
    required String name,
    required String description,
    required String creatorHandle,
    bool isPrivate = false,
    String? category,
    String? projectUrl,
    String? logoUrl,
    String? bannerImageUrl,
    String? tokenContractAddress,
    String? tokenSymbol,
    int? chainId,
  }) async {
    final user = getCurrentUser();
    if (user == null) return null;

    final response = await _client.from('cabals').insert({
      'name': name,
      'description': description,
      'creator_id': user.id,
      'creator_handle': creatorHandle,
      'is_private': isPrivate,
      'category': category,
      'project_url': projectUrl,
      'logo_url': logoUrl,
      'banner_image_url': bannerImageUrl,
      'token_contract_address': tokenContractAddress,
      'token_symbol': tokenSymbol,
      'chain_id': chainId,
    }).select().single();

    return Cabal.fromSupabase(response);
  }

  Future<void> joinCabal(String cabalId) async {
    await _client.rpc('join_cabal', params: {'p_cabal_id': cabalId});
  }

  // ====================== QUEST LOGIC ======================

  Future<List<QuestSection>> getQuestSectionsForCabal(String cabalId) async {
    final List<dynamic> data = await _client
        .from('quest_sections')
        .select()
        .eq('cabal_id', cabalId)
        .order('order', ascending: true);
    return data.map((json) => QuestSection.fromSupabase(json)).toList();
  }

  Future<List<Quest>> getQuestsForCabal(String cabalId) async {
    final List<dynamic> data = await _client
        .from('quests')
        .select()
        .eq('cabal_id', cabalId);
    return data.map((json) => Quest.fromSupabase(json)).toList();
  }

  Future<Map<String, dynamic>> completeQuest(String questId) async {
    final user = getCurrentUser();
    if (user == null) throw Exception("User not logged in");

    await _client.from('user_quest_progress').upsert({
      'user_id': user.id,
      'quest_id': questId,
      'status': 'completed',
      'last_completed_at': DateTime.now().toIso8601String(),
    });

    final questData = await _client.from('quests').select('xp_reward').eq('id', questId).single();
    final int reward = questData['xp_reward'] as int;

    await _client.rpc('award_xp', params: {
      'p_user_id': user.id,
      'p_amount': reward,
    });

    return {'success': true, 'xp_earned': reward};
  }

  // ====================== SOCIAL & FEED ======================

  Future<List<CommunityPost>> getGlobalFeed() async {
    final List<dynamic> data = await _client
        .from('community_posts')
        .select('*, profiles(username, profile_image_url)')
        .order('created_at', ascending: false)
        .limit(50);
    
    return data.map((json) {
      final profile = json['profiles'] as Map<String, dynamic>;
      json['author_name'] = profile['username'];
      json['author_avatar_url'] = profile['profile_image_url'];
      return CommunityPost.fromSupabase(json);
    }).toList();
  }

  // ====================== UTILS & COUNTERS ======================

  Future<void> recordActivity() async {
    final user = getCurrentUser();
    if (user == null) return;
    await _client.from('profiles').update({
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  /// FIXED: Removed the invalid positional argument and 'const' FetchOptions
  /// Uses the explicit .count() modifier which is safer for Flutter Web builds.
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _client
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false)
          .count(CountOption.exact);
      
      return response.count;
    } catch (e) {
      debugPrint("Error fetching notification count: $e");
      return 0;
    }
  }
}
