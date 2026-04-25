// lib/services/supabase_service.dart
import 'dart:math';
import '../models/marketplace_models.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';

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
  final SupabaseClient _client = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  User? getCurrentUser() => _client.auth.currentUser;

  // --- Auth ---
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
  Future<AuthResponse> signInUser(String email, String password) async => await _client.auth.signInWithPassword(email: email, password: password);
  Future<bool> signInWithGoogle() async => await _signInWithOAuth(OAuthProvider.google);
  Future<bool> signInWithDiscord() async => await _signInWithOAuth(OAuthProvider.discord);
  Future<bool> signInWithTwitter() async => await _signInWithOAuth(OAuthProvider.twitter);

  Future<bool> _signInWithOAuth(OAuthProvider provider) async {
    final redirectTo = kIsWeb ? null : 'io.supabase.cabal://login-callback/';
    try {
      return await _client.auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
        authScreenLaunchMode: kIsWeb ? LaunchMode.inAppWebView : LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("OAuth Error: $e");
      return false;
    }
  }

  Future<void> signOutUser() async => await _client.auth.signOut();

  // --- Users & Profiles ---
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _client.from('users').select().eq('id', userId).maybeSingle();

      if (response == null) {
        debugPrint("User profile for $userId not found. Attempting to create one...");
        final currentUser = _client.auth.currentUser;
        if (currentUser != null && currentUser.id == userId) {
          final Map<String, dynamic> newProfileData = {
            'id': userId, 
            'email': currentUser.email,
            'display_name': 'User-${userId.substring(0, 6)}',
          };
          final insertResponse = await _client.from('users').insert(newProfileData).select().single();
          debugPrint("Successfully created a new user profile for $userId.");
          return UserProfile.fromSupabase(insertResponse);
        } else {
          debugPrint("Cannot create profile: No authenticated user or mismatched ID.");
          return null;
        }
      }
      return UserProfile.fromSupabase(response);
    } catch (e) {
      debugPrint("Error getting/creating user profile for ID $userId: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfileDetails(String profileUserId) async {
    try {
      final response = await _client.rpc('get_profile_details', params: {'profile_user_id': profileUserId});
      return response as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error getting full profile details for $profileUserId: $e");
      return null;
    }
  }
  
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

  Future<List<UserProfile>> getFollowers(String userId) async {
    try {
      final response = await _client.rpc('get_user_followers', params: {'p_user_id': userId});
      return (response as List).map((data) {
        return UserProfile(
          id: data['id'],
          displayName: data['display_name'],
          profileImageUrl: data['profile_image_url'],
        );
      }).toList();
    } catch (e) {
      debugPrint("Error getting followers for $userId: $e");
      return [];
    }
  }
  
  Future<UserProfile?> findUserProfileByTelegram(String telegramUsername) async {
    try {
        final response = await _client.from('users').select().eq('telegram_username', telegramUsername).limit(1);
        if (response.isNotEmpty) {
            return UserProfile.fromSupabase(response.first);
        }
        return null;
    } catch(e) {
        debugPrint("Error finding user by telegram $telegramUsername: $e");
        return null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final userId = getCurrentUser()?.id;
    if (userId == null) throw Exception("User not authenticated.");
    await _client.from('users').update(updates).eq('id', userId);
  }

  Future<String?> uploadProfileImage(dynamic file, String userId) async {
    try {
      final imageBytes = await file.readAsBytes();
      final imageExtension = file.path.split('.').last.toLowerCase();
      
      String contentType = 'image/jpeg';
      if (imageExtension == 'png') {
        contentType = 'image/png';
      } else if (imageExtension == 'webp') {
        contentType = 'image/webp';
      }
      
      final fileName = '${const Uuid().v4()}.$imageExtension';
      final filePath = '$userId/$fileName';

      await _client.storage.from('avatars').uploadBinary(
        filePath,
        imageBytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true),
      );
      return _client.storage.from('avatars').getPublicUrl(filePath);
    } catch(e) {
      debugPrint("Error uploading profile image: $e");
      return null;
    }
  }
  
  Future<Map<String, dynamic>> getUserBalances(String userId) async {
    try {
      final response = await _client.from('user_balances').select().eq('user_id', userId).maybeSingle();
      if (response == null) {
        return {'cabal_token_balance': 0.0, 'usdt_balance': 0.0};
      }
      return response;
    } catch (e) {
      debugPrint("Error getting user balances for $userId: $e");
      return {'cabal_token_balance': 0.0, 'usdt_balance': 0.0};
    }
  }
  
  Future<Map<String, dynamic>> convertXp(int xpAmount) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    
    final response = await _client.rpc('convert_xp_to_tokens', params: {'p_user_id': user.id, 'p_xp_to_convert': xpAmount});
    return (response as List).first as Map<String, dynamic>;
  }

  Future<String> getUserRole(String cabalId, String userId) async {
    try {
      final response = await _client.rpc('get_user_role_in_cabal', params: {'p_cabal_id': cabalId, 'p_user_id': userId});
      return response as String? ?? 'none';
    } catch (e) {
      debugPrint("Error getting user role: $e");
      return 'none';
    }
  }
  
  Future<void> toggleFavoriteNews(String articleLink) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');

    final response = await _client
        .from('users')
        .select('favorited_news_links')
        .eq('id', user.id)
        .single();
        
    final List<String> currentFavorites = (response['favorited_news_links'] as List?)
        ?.map((item) => item.toString())
        .toList() ?? [];

    if (currentFavorites.contains(articleLink)) {
      currentFavorites.remove(articleLink);
    } else {
      currentFavorites.add(articleLink);
    }

    await _client
        .from('users')
        .update({'favorited_news_links': currentFavorites})
        .eq('id', user.id);
  }
  
  // --- Cabals ---
  Future<Cabal?> getCabal(String cabalId) async {
    try {
      final response = await _client.from('cabals').select().eq('id', cabalId).single();
      return Cabal.fromSupabase(response);
    } catch (e) {
      debugPrint("Error getting cabal with ID $cabalId: $e");
      return null;
    }
  }

  Future<List<Cabal>> getAllCabals() async {
    try {
      final response = await _client.from('cabals').select().order('created_at', ascending: false);
      return (response as List).map((data) => Cabal.fromSupabase(data)).toList();
    } on PostgrestException catch (e) {
      debugPrint("Supabase DB Error in getAllCabals: ${e.message}");
      throw Exception("Database Error: ${e.message}");
    } catch (e) {
      debugPrint("Error getting all cabals: $e");
      rethrow;
    }
  }

  Future<List<Cabal>> getCabalsByIds(List<String> cabalIds) async {
      if (cabalIds.isEmpty) return [];
      try {
          final response = await _client.from('cabals').select().inFilter('id', cabalIds);
          return (response as List).map((data) => Cabal.fromSupabase(data)).toList();
      } catch (e) {
          debugPrint("Error getting cabals by IDs: $e");
          return [];
      }
  }
  
  Future<List<Cabal>> getCabalsByCreator(String creatorId) async {
      try {
          final response = await _client.from('cabals').select().eq('creator_id', creatorId);
          return (response as List).map((data) => Cabal.fromSupabase(data)).toList();
      } catch (e) {
          debugPrint("Error getting cabals by creator: $e");
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
    if (user == null) throw Exception("User must be logged in to create a cabal.");
    
    final newCabal = Cabal(
      id: const Uuid().v4(), name: name, description: description, creatorId: user.id,
      creatorHandle: creatorHandle, projectUrl: projectUrl, logoUrl: logoUrl,
      bannerImageUrl: bannerImageUrl, isPrivate: isPrivate, category: category,
      tokenContractAddress: tokenContractAddress, tokenSymbol: tokenSymbol, chainId: chainId,
    );
    
    try {
      final response = await _client.from('cabals').insert(newCabal.toSupabase()).select().single();
      
      final createdCabal = Cabal.fromSupabase(response);
      await joinCabal(createdCabal.id);
      return createdCabal;

    } catch (e) {
      debugPrint("Error creating cabal: $e");
      rethrow;
    }
  }

  Future<Cabal> updateCabal(Cabal cabal) async {
    final response = await _client
        .from('cabals')
        .update(cabal.toSupabase())
        .eq('id', cabal.id)
        .select()
        .single();
    return Cabal.fromSupabase(response);
  }

  Future<void> deleteCabal(String cabalId) async {
    await _client.from('cabals').delete().eq('id', cabalId);
  }

  Future<void> updateCabalDetailsDirect(String cabalId, Map<String, dynamic> updates) async {
    await _client.from('cabals').update(updates).eq('id', cabalId);
  }

  // --- Quests & Sections ---
  Future<List<QuestSection>> getQuestSectionsForCabal(String cabalId) async {
      try {
          final response = await _client.from('quest_sections').select().eq('cabal_id', cabalId).order('order', ascending: true);
          return (response as List).map((data) => QuestSection.fromSupabase(data)).toList();
      } catch (e) {
          debugPrint("Error getting quest sections for cabal $cabalId: $e");
          return [];
      }
  }

  Future<List<Quest>> getQuestsForCabal(String cabalId) async {
      try {
          final response = await _client.from('quests').select().eq('cabal_id', cabalId);
          return (response as List).map((data) => Quest.fromSupabase(data)).toList();
      } catch (e) {
          debugPrint("Error getting quests for cabal $cabalId: $e");
          return [];
      }
  }
  
  Future<QuestSection> createQuestSection(String cabalId, String title, int order, {String? description}) async {
    final response = await _client
        .from('quest_sections')
        .insert({
            'cabal_id': cabalId,
            'title': title,
            'description': description,
            'order': order,
        })
        .select()
        .single();
    return QuestSection.fromSupabase(response);
  }
  
  Future<QuestSection> updateQuestSection(String sectionId, Map<String, dynamic> updates) async {
    final response = await _client
        .from('quest_sections')
        .update(updates)
        .eq('id', sectionId)
        .select()
        .single();
    return QuestSection.fromSupabase(response);
  }
  
  Future<void> deleteQuestSection(String sectionId) async {
    await _client.from('quest_sections').delete().eq('id', sectionId);
  }

  Future<Quest> createQuest(String cabalId, String sectionId, Map<String, dynamic> questData) async {
    questData['cabal_id'] = cabalId;
    questData['quest_section_id'] = sectionId;
    
    final response = await _client
        .from('quests')
        .insert(questData)
        .select()
        .single();
    return Quest.fromSupabase(response);
  }
  
  Future<Quest> updateQuest(String questId, Map<String, dynamic> updates) async {
    final response = await _client
        .from('quests')
        .update(updates)
        .eq('id', questId)
        .select()
        .single();
    return Quest.fromSupabase(response);
  }
  
  Future<void> deleteQuest(String questId) async {
    await _client.from('quests').delete().eq('id', questId);
  }
  
  Future<List<Map<String, dynamic>>> getPendingManualVerifications(String cabalId) async {
    try {
        final response = await _client.rpc('get_pending_verifications', params: {'cabal_id': cabalId});
        return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
        debugPrint("Error fetching pending verifications: $e");
        return [];
    }
  }

  Future<void> approveManualVerification(String progressId, {String? adminNotes}) async {
      await _client.rpc('approve_manual_verification', params: {'progress_id': progressId, 'admin_notes': adminNotes});
  }

  Future<void> rejectManualVerification(String progressId, {String? adminNotes}) async {
      await _client.rpc('reject_manual_verification', params: {'progress_id': progressId, 'admin_notes': adminNotes});
  }

  // --- User Progress ---
  Future<Map<String, dynamic>> getUserProgressInCabal(String userId, String cabalId) async {
    try {
      final response = await _client
          .from('user_quest_progress')
          .select('quest_id, status, completed_at, current_steps')
          .eq('user_id', userId)
          .eq('cabal_id', cabalId);

      final Set<String> completedQuestIds = {};
      final Map<String, DateTime?> completionTimestamps = {};
      final Map<String, int> questSteps = {};
      final Map<String, String> questStatuses = {};

      for (final record in response as List) {
          final questId = record['quest_id'] as String;
          final status = record['status'] as String? ?? 'not_started';

          questStatuses[questId] = status;
          questSteps[questId] = record['current_steps'] as int? ?? 0;
          
          if (status == 'completed') {
              completedQuestIds.add(questId);
              if (record['completed_at'] != null) {
                  completionTimestamps[questId] = DateTime.tryParse(record['completed_at'] as String);
              }
          }
      }
      return {
          'completed_ids': completedQuestIds,
          'timestamps': completionTimestamps,
          'steps': questSteps,
          'statuses': questStatuses,
      };
    } catch (e) {
        debugPrint("Error getting user progress for cabal $cabalId: $e");
        return {'completed_ids': <String>{}, 'timestamps': <String, DateTime?>{}, 'steps': <String, int>{}, 'statuses': <String, String>{}};
    }
  }

  // --- Actions (RPC Calls) ---
  Future<Map<String, dynamic>> completeQuest(String questId, {String? verificationData}) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    
    final response = await _client.rpc('complete_quest', params: {
        'p_user_id': user.id,
        'p_quest_id': questId,
        'p_verification_data': verificationData,
    });
    
    return response as Map<String, dynamic>;
  }
  
  Future<void> joinCabal(String cabalId) async {
      await _client.rpc('join_cabal', params: {
          'p_cabal_id': cabalId,
      });
  }
  
  Future<void> requestToJoinCabal(String cabalId) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    
    await _client.rpc('request_to_join_cabal', params: {
      'p_cabal_id': cabalId
    });
  }

  Future<bool> hasPendingJoinRequest(String cabalId) async {
    final user = getCurrentUser();
    if (user == null) return false;
    
    final response = await _client
        .from('cabal_join_requests')
        .select('id')
        .eq('cabal_id', cabalId)
        .eq('user_id', user.id)
        .eq('status', 'pending')
        .limit(1);
        
    return (response as List).isNotEmpty;
  }

  // --- Community Posts & Social ---
  Future<List<CommunityPost>> getGlobalFeed() async {
    try {
      final response = await _client.rpc('get_global_feed');
      return (response as List).map((data) => CommunityPost.fromSupabase(data)).toList();
    } on PostgrestException catch (e) {
      debugPrint("Supabase DB Error in getGlobalFeed: ${e.message}");
      throw Exception("Database Error: ${e.message}");
    } catch (e) {
      debugPrint("Error getting global feed: $e");
      rethrow;
    }
  }
  
  Future<List<CommunityPost>> getCommunityPosts(String cabalId) async {
    try {
      final response = await _client
          .from('community_posts')
          .select('*, users:user_id(display_name, profile_image_url)')
          .eq('cabal_id', cabalId)
          .order('created_at', ascending: false);
      return (response as List).map((data) => CommunityPost.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting community posts for cabal $cabalId: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> toggleLike(String postId) async {
    final response = await _client.rpc('toggle_like', params: {'post_id_to_toggle': postId});
    return response as Map<String, dynamic>;
  }

  Future<List<CommunityPost>> getPostComments(String postId) async {
    try {
      final response = await _client
          .from('post_comments')
          .select('*, users:user_id(display_name, profile_image_url)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      return (response as List).map((data) {
          final postData = data as Map<String, dynamic>;
          final userData = postData['users'] as Map<String, dynamic>?;
           return CommunityPost.fromSupabase({
              'id': postData['id'],
              'user_id': postData['user_id'],
              'cabal_id': postId,
              'content': postData['content'],
              'type': 'standard',
              'likes': 0,
              'created_at': postData['created_at'],
              'author_name': userData?['display_name'],
              'author_avatar_url': userData?['profile_image_url'],
              'comment_count': 0,
              'is_liked_by_user': false,
          });
      }).toList();
    } catch (e) {
      debugPrint("Error getting post comments: $e");
      return [];
    }
  }

  Future<void> addCommentToPost({required String postId, required String content}) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    await _client.from('post_comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'content': content,
    });
  }

  Future<CommunityPost?> createCommunityPost({
    required String cabalId,
    required String content,
  }) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');

    try {
      final response = await _client
          .from('community_posts')
          .insert({
            'user_id': user.id,
            'cabal_id': cabalId,
            'content': content,
            'type': 'standard',
          })
          .select('*, users:user_id(display_name, profile_image_url)')
          .single();
      return CommunityPost.fromSupabase({
          ...response,
          'comment_count': 0,
          'is_liked_by_user': false,
      });
    } catch (e) {
      debugPrint("Error creating community post: $e");
      return null;
    }
  }

  // --- Achievements ---
  Future<List<Achievement>> getAchievementsByIds(List<String> achievementIds) async {
    if (achievementIds.isEmpty) return [];
    final response = await _client.from('achievements').select().inFilter('id', achievementIds);
    return (response as List).map((data) => Achievement.fromSupabase(data)).toList();
  }

  // --- Notifications ---
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final response = await _client.from('notifications').select().eq('user_id', userId).order('created_at', ascending: false);
      return (response as List).map((data) => NotificationModel.fromSupabase(data)).toList();
    } catch(e) {
      debugPrint("Error getting notifications: $e");
      return [];
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      await _client.from('notifications').update({'is_read': true}).eq('user_id', userId).eq('is_read', false);
    } catch (e) {
      debugPrint("Error marking notifications as read: $e");
    }
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _client.from('notifications').count(CountOption.exact).eq('user_id', userId).eq('is_read', false);
      return response;
    } catch (e) {
      debugPrint("Error getting unread notification count: $e");
      return 0;
    }
  }
  
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    String? type,
    String? referenceId,
  }) async {
    await _client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'reference_id': referenceId,
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    
    try {
      await _client
        .from('notifications')
        .delete()
        .eq('id', notificationId)
        .eq('user_id', user.id);
    } catch (e) {
      debugPrint("Error deleting notification: $e");
      rethrow;
    }
  }

  // --- Activity Feed ---
  Future<List<Activity>> getActivityFeed(String userId) async {
      try {
          final response = await _client
              .rpc('get_activity_feed', params: {'p_user_id': userId})
              .select('*, users(display_name, profile_image_url)');
          return (response as List).map((data) => Activity.fromSupabase(data)).toList();
      } catch (e) {
          debugPrint("Error getting activity feed: $e");
          return [];
      }
  }

  // --- Leaderboard ---
  Future<List<UserProfile>> getAllUsersForLeaderboard() async {
    try {
      final response = await _client.from('users').select().order('total_xp', ascending: false);
      return (response as List).map((data) => UserProfile.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting all users for leaderboard: $e");
      return [];
    }
  }
  
  Future<List<CabalLeaderboardEntry>> getGlobalLeaderboard() async {
    try {
      final response = await _client.rpc('get_global_leaderboard');
      return (response as List).map((data) {
        return CabalLeaderboardEntry(
          rank: (data['rank'] as num).toInt(),
          cabalXp: (data['total_xp'] as num).toInt(),
          userProfile: UserProfile(
            id: data['user_id'],
            displayName: data['display_name'],
            profileImageUrl: data['profile_image_url'],
            totalXp: data['total_xp'],
            level: data['level'],
          ),
        );
      }).toList();
    } catch(e) {
      debugPrint("Error fetching global leaderboard: $e");
      return [];
    }
  }
  
  // --- Trading Bots ---
  Future<List<BotModel>> getConnectedBots() async {
    final user = getCurrentUser();
    if (user == null) return [];
    try {
      final response = await _client.from('trading_bots').select().eq('user_id', user.id).order('created_at', ascending: false);
      return (response as List).map((data) {
        return BotModel(
          id: data['id'], name: data['bot_name'], type: data['bot_type'],
          status: BotStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => BotStatus.error),
          pnl24h: (Random().nextDouble() * 200) - 100,
          totalTrades: Random().nextInt(100),
        );
      }).toList();
    } catch (e) {
      debugPrint("Error fetching connected bots: $e");
      return [];
    }
  }

  Future<BotModel?> addBot({required String name, required String type, required String token}) async {
    final user = getCurrentUser();
    if (user == null) throw Exception("User not authenticated.");
    try {
      final response = await _client.from('trading_bots').insert({
        'user_id': user.id, 'bot_name': name, 'bot_type': type, 'encrypted_bot_token': token, 'status': 'active',
      }).select().single();
      return BotModel(id: response['id'], name: response['bot_name'], type: response['bot_type'], status: BotStatus.active, pnl24h: 0, totalTrades: 0);
    } catch (e) {
      debugPrint("Error adding bot: $e");
      return null;
    }
  }
  
  Future<void> updateBotStatus(String botId, BotStatus status) async {
    await _client.rpc('update_bot_status', params: {
      'bot_id_to_update': botId,
      'new_status': status.name,
    });
  }

  Future<void> deleteBot(String botId) async {
    await _client.rpc('delete_bot', params: {'bot_id_to_delete': botId});
  }

  Future<void> deleteCurrentUserAccount() async {
    await _client.rpc('delete_user_account');
  }

  // --- Marketplace ---
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

  Future<ProjectListing?> createProjectListing({
    required String projectName,
    required String projectDescription,
    required String budget,
    required String timeline,
    required List<String> requiredSkills,
    required bool isFullProject,
  }) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    try {
      final response = await _client
          .from('project_listings')
          .insert({
            'creator_id': user.id,
            'project_name': projectName,
            'project_description': projectDescription,
            'budget': budget,
            'timeline': timeline,
            'required_skills': requiredSkills,
            'is_full_project': isFullProject,
          })
          .select('*, creator_profile:creator_id(display_name, profile_image_url)')
          .single();
      return ProjectListing.fromSupabase(response);
    } catch (e) {
      debugPrint("Error creating project listing: $e");
      return null;
    }
  }

  Future<List<DeveloperProfile>> getDeveloperProfiles() async {
    try {
      final response = await _client
          .from('developer_profiles')
          .select('*, creator_profile:user_id(display_name, profile_image_url)')
          .order('created_at', ascending: false);
      return (response as List).map((data) => DeveloperProfile.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error getting developer profiles: $e");
      return [];
    }
  }

  Future<DeveloperProfile?> createDeveloperProfile({
    required String tagline,
    required String rate,
    required List<String> skills,
  }) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    try {
      final response = await _client
          .from('developer_profiles')
          .upsert({
            'user_id': user.id,
            'tagline': tagline,
            'rate': rate,
            'skills': skills,
          }, onConflict: 'user_id')
          .select('*, creator_profile:user_id(display_name, profile_image_url)')
          .single();
      return DeveloperProfile.fromSupabase(response);
    } catch (e) {
      debugPrint("Error creating/updating developer profile: $e");
      return null;
    }
  }
  
  Future<void> updateDeveloperProfile({
    required String tagline,
    required String rate,
    required List<String> skills,
    required bool isAvailable,
  }) async {
    final user = getCurrentUser();
    if (user == null) throw const AuthException('User not authenticated.');
    await _client.from('developer_profiles').update({
      'tagline': tagline,
      'rate': rate,
      'skills': skills,
      'is_available': isAvailable,
    }).eq('user_id', user.id);
  }
  
  // --- NFT Marketplace ---
  Future<NftListing> createNftListing(NftListing listing) async {
    final response = await _client
        .from('nft_listings')
        .insert(listing.toSupabase())
        .select()
        .single();
    return NftListing.fromSupabase(response);
  }

  Future<List<NftListing>> getNftListings() async {
    try {
      final response = await _client
          .from('nft_listings')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return (response as List).map((data) => NftListing.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error fetching NFT listings: $e");
      return [];
    }
  }

  Future<void> deactivateNftListing(String listingId) async {
    await _client
        .from('nft_listings')
        .update({'is_active': false})
        .eq('id', listingId);
  }

  // --- Merchandise ---
  Future<List<MerchandiseProduct>> getMerchandiseForCabal(String cabalId) async {
    try {
      final response = await _client
          .from('merchandise_products')
          .select()
          .eq('cabal_id', cabalId)
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return (response as List).map((data) => MerchandiseProduct.fromSupabase(data)).toList();
    } catch (e) {
      debugPrint("Error fetching merchandise for cabal $cabalId: $e");
      return [];
    }
  }

  Future<MerchandiseProduct> createMerchandiseProduct(Map<String, dynamic> productData) async {
    final response = await _client
        .from('merchandise_products')
        .insert(productData)
        .select()
        .single();
    return MerchandiseProduct.fromSupabase(response);
  }

  // --- Partnership ---
  Future<void> submitPartnershipApplication({
      required String contactName,
      required String contactEmail,
      required String partnershipType,
      required String proposalDetails,
      String? projectName,
      String? projectUrl,
      String? twitterHandle,
  }) async {
      await _client.from('partnerships').insert({
          'contact_name': contactName,
          'contact_email': contactEmail,
          'partnership_type': partnershipType,
          'proposal_details': proposalDetails,
          'project_name': projectName,
          'project_url': projectUrl,
          'twitter_handle': twitterHandle,
      });
  }

  // --- Activity & Metrics ---
  Future<void> recordActivity() async {
    if (_client.auth.currentUser != null) {
      await _client.rpc('record_user_activity');
    }
  }

  Future<List<Map<String, dynamic>>> getKolMetrics() async {
      final user = getCurrentUser();
      if (user == null) return [];
      final response = await _client.rpc('get_kol_metrics', params: {'p_user_id': user.id});
      return (response as List).map((item) => item as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> getKolDashboardData(String userId) async {
    try {
      final response = await _client.rpc('get_kol_dashboard_data', params: {'p_user_id': userId});
      return response as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error getting KOL dashboard data: $e");
      rethrow;
    }
  }

  Future<List<CommunityCabalPreview>> getCommunityHubCabals() async {
    try {
      final response = await _client.rpc('get_community_hub_cabals');
      return (response as List).map((data) {
        final reconstructedData = {
          'cabals': data['cabal'],
          'member_count': data['member_count'],
          'post_count': data['post_count'],
          'latest_post_snippet': data['latest_post_snippet'],
          'latest_post_timestamp': data['latest_post_timestamp'],
        };
        return CommunityCabalPreview.fromSupabase(reconstructedData);
      }).toList();
    } catch (e) {
      debugPrint("Error getting community hub cabals: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCabalCommunityStats(String cabalId) async {
    try {
      final memberCountResponse = await _client.rpc('get_cabal_member_count', params: {'p_cabal_id': cabalId});
      final memberCount = memberCountResponse as int;

      final postsResponse = await _client
        .from('community_posts')
        .select('created_at')
        .eq('cabal_id', cabalId);

      final posts = (postsResponse as List).cast<Map<String, dynamic>>();
      final postCount = posts.length;

      final Map<DateTime, int> dailyCounts = {};
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      for (var post in posts) {
        final createdAt = DateTime.parse(post['created_at']);
        if (createdAt.isAfter(thirtyDaysAgo)) {
          final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
          dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
        }
      }
      
      final List<Map<String, dynamic>> timeseriesData = [];
      for (int i = 0; i < 30; i++) {
        final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        timeseriesData.add({
          // --- THIS IS THE FIXED LINE ---
          'date': date.toIso8601String(),
          'count': dailyCounts[date] ?? 0,
        });
      }
      
      return {
        'member_count': memberCount,
        'post_count': postCount,
        'activity_timeseries': timeseriesData.reversed.toList(),
      };

    } catch (e) {
      debugPrint("Error getting getCabalCommunityStats: $e");
      rethrow;
    }
  }
}
