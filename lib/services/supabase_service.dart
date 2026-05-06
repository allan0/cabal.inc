// lib/services/supabase_service.dart
import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint, kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config.dart';
import '../models/marketplace_models.dart';
import '../models/user_profile_model.dart';
import '../models/cabal_model.dart';
import '../models/cabal_leaderboard_entry.dart';
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/achievement_model.dart';
import '../models/notification_model.dart';
import '../models/activity_model.dart';
import '../models/bot_model.dart';
import '../models/community_post_model.dart';
import '../models/community_cabal_preview.dart';
import '../models/nft_listing_model.dart';
import '../models/merchandise_product_model.dart';
import '../utils/constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // --- Auth Stream ---
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? getCurrentUser() => _client.auth.currentUser;

  // ====================== AUTH ======================

  Future<AuthResponse> signUpUser(String email, String password, {String? referralCode}) async {
    Map<String, dynamic> data = {};
    if (referralCode != null && referralCode.isNotEmpty) {
      data['referred_by'] = referralCode;
    }
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<AuthResponse> signInUser(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Updated Google Sign-In (Recommended way)
  Future<bool> signInWithGoogle() async {
    try {
      final redirectTo = kIsWeb 
          ? 'https://cabal-001.web.app/auth/callback' 
          : 'io.supabase.cabal://login-callback/';

      final response = await _client.auth.signInWithOAuth(
        Provider.google,
        redirectTo: redirectTo,
        authScreenLaunchMode: kIsWeb 
            ? LaunchMode.inAppWebView 
            : LaunchMode.externalApplication,
      );
      return response;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return false;
    }
  }

  Future<bool> signInWithDiscord() async => await _signInWithOAuth(Provider.discord);
  Future<bool> signInWithTwitter() async => await _signInWithOAuth(Provider.twitter);

  Future<bool> _signInWithOAuth(Provider provider) async {
    try {
      final redirectTo = kIsWeb 
          ? 'https://cabal-001.web.app/auth/callback' 
          : 'io.supabase.cabal://login-callback/';

      return await _client.auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
        authScreenLaunchMode: kIsWeb ? LaunchMode.inAppWebView : LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("OAuth Error for $provider: $e");
      return false;
    }
  }

  Future<void> signOutUser() async {
    await _client.auth.signOut();
  }

  // ====================== USERS & PROFILES ======================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint("User profile for $userId not found. Creating one...");
        final currentUser = _client.auth.currentUser;
        if (currentUser != null && currentUser.id == userId) {
          final newProfileData = {
            'id': userId,
            'email': currentUser.email,
            'display_name': 'User-${userId.substring(0, 6)}',
          };
          final insertResponse = await _client
              .from('users')
              .insert(newProfileData)
              .select()
              .single();
          return UserProfile.fromSupabase(insertResponse);
        }
        return null;
      }
      return UserProfile.fromSupabase(response);
    } catch (e) {
      debugPrint("Error getting/creating user profile: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfileDetails(String profileUserId) async {
    try {
      final response = await _client.rpc(
        'get_profile_details',
        params: {'profile_user_id': profileUserId},
      );
      return response as Map<String, dynamic>?;
    } catch (e) {
      debugPrint("Error getting profile details: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final userId = getCurrentUser()?.id;
    if (userId == null) throw Exception("User not authenticated.");
    await _client.from('users').update(updates).eq('id', userId);
  }

  // ====================== FOLLOW SYSTEM ======================

  Future<void> followUser(String followingId) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    if (user.id == followingId) return;

    await _client.from('user_follows').insert({
      'follower_id': user.id,
      'following_id': followingId,
    });
  }

  Future<void> unfollowUser(String followingId) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    await _client
        .from('user_follows')
        .delete()
        .eq('follower_id', user.id)
        .eq('following_id', followingId);
  }

  // ====================== STORAGE ======================

  Future<String?> uploadProfileImage(dynamic file, String userId) async {
    try {
      final imageBytes = await file.readAsBytes();
      final imageExtension = file.path.split('.').last.toLowerCase();
      String contentType = 'image/jpeg';
      if (imageExtension == 'png') contentType = 'image/png';
      if (imageExtension == 'webp') contentType = 'image/webp';

      final fileName = '${const Uuid().v4()}.$imageExtension';
      final filePath = '$userId/$fileName';

      await _client.storage.from('avatars').uploadBinary(
            filePath,
            imageBytes,
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );

      return _client.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      return null;
    }
  }

  // ====================== CABALS ======================

  Future<Cabal?> getCabal(String cabalId) async {
    try {
      final response = await _client.from('cabals').select().eq('id', cabalId).single();
      return Cabal.fromSupabase(response);
    } catch (e) {
      debugPrint("Error getting cabal $cabalId: $e");
      return null;
    }
  }

  Future<List<Cabal>> getAllCabals() async {
    try {
      final response = await _client
          .from('cabals')
          .select()
          .order('created_at', ascending: false);
      return (response as List).map((data) => Cabal.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting all cabals: $e");
      return [];
    }
  }

  Future<Cabal?> createCabal({
    required String name,
    required String description,
    required String creatorHandle,
    String? projectUrl,
    String? logoUrl,
    String? bannerImageUrl,
    bool isPrivate = false,
    String? category,
    String? tokenContractAddress,
    String? tokenSymbol,
    int? chainId,
  }) async {
    final user = getCurrentUser();
    if (user == null) throw Exception("User must be logged in.");

    final newCabal = Cabal(
      id: const Uuid().v4(),
      name: name,
      description: description,
      creatorId: user.id,
      creatorHandle: creatorHandle,
      projectUrl: projectUrl,
      logoUrl: logoUrl,
      bannerImageUrl: bannerImageUrl,
      isPrivate: isPrivate,
      category: category,
      tokenContractAddress: tokenContractAddress,
      tokenSymbol: tokenSymbol,
      chainId: chainId,
    );

    try {
      final response = await _client
          .from('cabals')
          .insert(newCabal.toSupabase())
          .select()
          .single();

      final createdCabal = Cabal.fromSupabase(response);
      await joinCabal(createdCabal.id);
      return createdCabal;
    } catch (e) {
      debugPrint("Error creating cabal: $e");
      rethrow;
    }
  }

  Future<void> joinCabal(String cabalId) async {
    await _client.rpc('join_cabal', params: {'p_cabal_id': cabalId});
  }

  // ====================== QUESTS ======================

  Future<List<QuestSection>> getQuestSectionsForCabal(String cabalId) async {
    try {
      final response = await _client
          .from('quest_sections')
          .select()
          .eq('cabal_id', cabalId)
          .order('order', ascending: true);
      return (response as List).map((data) => QuestSection.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting quest sections: $e");
      return [];
    }
  }

  Future<List<Quest>> getQuestsForCabal(String cabalId) async {
    try {
      final response = await _client.from('quests').select().eq('cabal_id', cabalId);
      return (response as List).map((data) => Quest.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting quests: $e");
      return [];
    }
  }

  // ====================== NOTIFICATIONS ======================

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final response = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (response as List).map((data) => NotificationModel.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting notifications: $e");
      return [];
    }
  }

  // ====================== COMMUNITY ======================

  Future<List<CommunityPost>> getGlobalFeed() async {
    try {
      final response = await _client.rpc('get_global_feed');
      return (response as List).map((data) => CommunityPost.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting global feed: $e");
      return [];
    }
  }

  // ====================== MARKETPLACE ======================

  Future<List<ProjectListing>> getProjectListings() async {
    try {
      final response = await _client
          .from('project_listings')
          .select('*, creator_profile:creator_id(display_name, profile_image_url)')
          .order('created_at', ascending: false);
      return (response as List).map((data) => ProjectListing.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting project listings: $e");
      return [];
    }
  }

  // ====================== OTHER METHODS (kept as-is) ======================

  Future<Map<String, dynamic>> getUserBalances(String userId) async { ... } // keep existing
  Future<Map<String, dynamic>> convertXp(int xpAmount) async { ... }
  Future<void> toggleFavoriteNews(String articleLink) async { ... }
  Future<List<BotModel>> getConnectedBots() async { ... }
  // ... (all other methods you already have)

  // You can keep all the remaining methods exactly as they were.
}
