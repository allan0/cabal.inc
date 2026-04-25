// SUPABASE_MIGRATION: This file is no longer used. All logic should be in supabase_service.dart.
/*
// SUPABASE_MIGRATION: Firestore import removed
import '../models/user_profile_model.dart';
import '../models/cabal_model.dart';
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/notification_model.dart';
import '../models/achievement_model.dart';
import '../utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirestoreService {
  final FirebaseFirestore _db = // [Supabase Fix] Commented out: FirebaseFirestore\.instance;

  String _cleanTgUsername(String tgUsername) {
    return tgUsername.startsWith('@') ? tgUsername.substring(1) : tgUsername;
  }

  Future<UserProfile?> getUserProfile(String telegramUsername) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    try {
      final docRef = _db.collection(FirestoreCollections.users).doc(cleanUsername);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        return UserProfile.fromFirestore(docSnap as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        final newUser = UserProfile(telegramUsername: cleanUsername, displayName: cleanUsername);
        await docRef.set(newUser.toFirestore());
        return newUser;
      }
    } catch (e) {
      print("Error getting/creating user profile for $cleanUsername: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(String telegramUsername, Map<String, dynamic> data) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    try {
      await _db.collection(FirestoreCollections.users).doc(cleanUsername).update({
        ...data,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating user profile for $cleanUsername: $e");
      rethrow;
    }
  }
  
  Future<List<UserProfile>> getTopUsers(int limit) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(FirestoreCollections.users)
          .orderBy('totalXp', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print("Error getting top users: $e");
      return [];
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return;
    final currentUserClean = _cleanTgUsername(currentUserId);
    final targetUserClean = _cleanTgUsername(targetUserId);
    final currentUserRef = _db.collection(FirestoreCollections.users).doc(currentUserClean);
    final targetUserRef = _db.collection(FirestoreCollections.users).doc(targetUserClean);

    await _db.runTransaction((transaction) async {
      transaction.update(currentUserRef, {'followingUserIds': FieldValue.arrayUnion([targetUserClean])});
      transaction.update(targetUserRef, {'followersUserIds': FieldValue.arrayUnion([currentUserClean])});
    });
    // TODO: Create a notification for targetUserId
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserClean = _cleanTgUsername(currentUserId);
    final targetUserClean = _cleanTgUsername(targetUserId);
    final currentUserRef = _db.collection(FirestoreCollections.users).doc(currentUserClean);
    final targetUserRef = _db.collection(FirestoreCollections.users).doc(targetUserClean);

    await _db.runTransaction((transaction) async {
      transaction.update(currentUserRef, {'followingUserIds': FieldValue.arrayRemove([targetUserClean])});
      transaction.update(targetUserRef, {'followersUserIds': FieldValue.arrayRemove([currentUserClean])});
    });
  }

  Future<List<Cabal>> getAllCabals() async {
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.cabals).get();
      return snapshot.docs
          .map((doc) => Cabal.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print("Error getting all projects: $e");
      return [];
    }
  }

  Future<Cabal?> getCabal(String cabalId) async {
    try {
      DocumentSnapshot doc = await _db.collection(FirestoreCollections.cabals).doc(cabalId).get();
      if (doc.exists) {
        return Cabal.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }
    } catch (e) {
      print("Error getting project $cabalId: $e");
    }
    return null;
  }

  Future<List<QuestSection>> getQuestSectionsForCabal(String cabalId, List<String> sectionOrder) async {
    try {
      final List<QuestSection> sections = [];
      if (sectionOrder.isEmpty) { 
         QuerySnapshot snapshot = await _db
            .collection(FirestoreCollections.cabals).doc(cabalId)
            .collection(FirestoreCollections.questSections).orderBy('order').get();
          return snapshot.docs.map((doc) => QuestSection.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      }
      for (String sectionId in sectionOrder) {
         final docSnap = await _db.collection(FirestoreCollections.cabals).doc(cabalId)
            .collection(FirestoreCollections.questSections).doc(sectionId).get();
        if (docSnap.exists) {
            sections.add(QuestSection.fromFirestore(docSnap as DocumentSnapshot<Map<String, dynamic>>));
        }
      }
      return sections;
    } catch (e) {
      print("Error getting quest sections for project $cabalId: $e");
      return [];
    }
  }

  Future<List<Quest>> getQuestsForSection(String cabalId, String sectionId) async {
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.cabals).doc(cabalId)
          .collection(FirestoreCollections.questSections).doc(sectionId)
          .collection(FirestoreCollections.quests).get();
      return snapshot.docs.map((doc) => Quest.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error getting quests for project $cabalId, section $sectionId: $e");
      return [];
    }
  }

  Future<Map<String, DateTime?>> getCompletedQuestTimestampsForUser(String telegramUsername, String cabalId) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    Map<String, DateTime?> completedQuestTimestamps = {};
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.users).doc(cleanUsername)
          .collection(FirestoreCollections.userCabalProgress).doc(cabalId)
          .collection(FirestoreCollections.completedQuests).get();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['completedAt'] is DateTime?) {
          completedQuestTimestamps[doc.id] = data['completedAt'] as DateTime?;
        }
      }
    } catch (e) {
      print("Error getting completed quests timestamps for $cleanUsername, project $cabalId: $e");
    }
    return completedQuestTimestamps;
  }
  
  Future<Set<String>> getCompletedQuestIdsForUser(String telegramUsername, String cabalId) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    Set<String> completedIds = {};
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.users).doc(cleanUsername)
          .collection(FirestoreCollections.userCabalProgress).doc(cabalId)
          .collection(FirestoreCollections.completedQuests).get();
      for (var doc in snapshot.docs) {
        completedIds.add(doc.id);
      }
    } catch (e) {
      print("Error getting completed quest IDs for $cleanUsername, project $cabalId: $e");
    }
    return completedIds;
  }

  Future<void> completeQuestForUser({
    required String telegramUsername,
    required String cabalId,
    required Quest quest,
    required UserProfile userProfile,
  }) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);    
    final userDocRef = _db.collection(FirestoreCollections.users).doc(cleanUsername);
    final completedQuestRef = userDocRef
        .collection(FirestoreCollections.userCabalProgress).doc(cabalId)
        .collection(FirestoreCollections.completedQuests).doc(quest.id);
    
    await _db.runTransaction((transaction) async {
        int newTotalXp = userProfile.totalXp + quest.xpReward;
        int newLevel = calculateLevel(newTotalXp);
        
        transaction.update(userDocRef, {
            'totalXp': newTotalXp,
            'level': newLevel,
            'joinedCabalIds': FieldValue.arrayUnion([cabalId])
        });
        
        transaction.set(completedQuestRef, {
          'completedAt': FieldValue.serverTimestamp(),
          'questTitle': quest.title,
          'xpAwarded': quest.xpReward
        });
        userProfile.totalXp = newTotalXp; // Update local model immediately for subsequent checks
        userProfile.level = newLevel;
    });

    await checkAndAwardAchievements(userProfile, questId: quest.id, cabalId: cabalId);
    await addNotification(
        userId: cleanUsername,
        title: "Quest Complete!",
        body: "You earned ${quest.xpReward} XP for completing '${quest.title}'.",
        type: "quest_complete",
        referenceId: quest.id
    );
    print("Quest ${quest.id} completed for $cleanUsername. XP Awarded: ${quest.xpReward}");
  }

  Future<List<Achievement>> getGlobalAchievements() async { // Renamed for clarity
      try {
          QuerySnapshot snapshot = await _db.collection('achievements').get();
          return snapshot.docs.map((doc) => Achievement.fromFirestore(doc as DocumentSnapshot<Map<String,dynamic>>)).toList();
      } catch (e) {
          print("Error getting achievements: $e");
          return [];
      }
  }
  
  Future<List<Achievement>> getEarnedAchievementsDetails(List<String> achievementIds) async {
    if (achievementIds.isEmpty) return [];
    List<Achievement> achievements = [];
    try {
      List<List<String>> chunks = [];
      for (var i = 0; i < achievementIds.length; i += 30) { // Updated to 30 (current Firestore limit)
          chunks.add(achievementIds.sublist(i, i + 30 > achievementIds.length ? achievementIds.length : i + 30));
      }
      for (var chunk in chunks) {
          if (chunk.isNotEmpty) {
            final snapshot = await _db.collection('achievements').where(FieldPath.documentId, whereIn: chunk).get();
            achievements.addAll(snapshot.docs.map((doc) => Achievement.fromFirestore(doc as DocumentSnapshot<Map<String,dynamic>>)));
          }
      }
    } catch(e) {
        print("Error fetching achievement details: $e");
    }
    return achievements;
  }

  Future<void> checkAndAwardAchievements(UserProfile userProfile, {String? questId, String? cabalId}) async {
    print("Checking achievements for ${userProfile.telegramUsername}...");
    
    // Example: Award an achievement for completing the quest "first_quest_ever"
    final firstQuestAchievementId = "ach_first_quest";
    if (questId == "first_quest_ever" && !userProfile.earnedAchievementIds.contains(firstQuestAchievementId)) {
        int bonusXp = 50; 
        try {
            await _db.collection(FirestoreCollections.users).doc(userProfile.telegramUsername).update({
                'earnedAchievementIds': FieldValue.arrayUnion([firstQuestAchievementId]),
                'totalXp': FieldValue.increment(bonusXp),
            });
            // Update local profile for immediate UI reflection and further checks if any
            userProfile.earnedAchievementIds.add(firstQuestAchievementId); 
            userProfile.totalXp += bonusXp;
            userProfile.level = calculateLevel(userProfile.totalXp);
            
            print("Awarded achievement: $firstQuestAchievementId to ${userProfile.telegramUsername}");
            await addNotification(
              userId: userProfile.telegramUsername,
              title: "Achievement Unlocked!",
              body: "You've earned the achievement: 'First Quest Conqueror!' (+${bonusXp} XP)", // Example name
              type: "achievement_unlocked",
              referenceId: firstQuestAchievementId
            );
        } catch (e) {
            print("Error awarding achievement $firstQuestAchievementId: $e");
        }
    }
    // TODO: Implement more comprehensive achievement checking logic.
    // Fetch all defined achievements (getGlobalAchievements).
    // For each achievement not yet earned by the user:
    //   - Check if its criteria are met based on userProfile data 
    //     (e.g., userProfile.totalXp, userProfile.level, count of completed quests).
    //   - If met, award it similar to the example above.
  }

  Future<List<NotificationModel>> getUserNotifications(String userId, {int limit = 20}) async {
    try {
      QuerySnapshot snapshot = await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
          .collection('notifications').orderBy('createdAt', descending: true).limit(limit).get();
      return snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print("Error getting user notifications: $e");
      return [];
    }
  }
  
  Future<int> getUnreadNotificationCount(String userId) async {
      try {
          final snapshot = await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
              .collection('notifications').where('isRead', isEqualTo: false).count().get();
          return snapshot.count ?? 0; 
      } catch (e) {
          print("Error getting unread notification count: $e");
          return 0;
      }
  }

  Future<void> addNotification({ required String userId, required String title, required String body,
    String? type, String? referenceId}) async {
    try {
      await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId)).collection('notifications').add({
        'userId': _cleanTgUsername(userId), 'title': title, 'body': body, 'type': type,
        'referenceId': referenceId, 'createdAt': FieldValue.serverTimestamp(), 'isRead': false,
      });
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    try {
      await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
          .collection('notifications').doc(notificationId).update({'isRead': true});
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }
  
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final batch = _db.batch();
      final snapshot = await _db.collection(FirestoreCollections.users).doc(_cleanTgUsername(userId))
          .collection('notifications').where('isRead', isEqualTo: false).get();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      print("Error marking all notifications as read: $e");
    }
  }
  
  Future<void> linkWallet(String telegramUsername, String walletType, String address) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    await _db.collection(FirestoreCollections.users).doc(cleanUsername).update({
      'connectedWallets.${walletType}': address,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
    print("Wallet $walletType linked for $cleanUsername");
  }

  Future<void> linkSocialAccount(String telegramUsername, String platform, String accountId) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
     await _db.collection(FirestoreCollections.users).doc(cleanUsername).update({
      'connectedSocials.${platform}': accountId,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
    print("Social account $platform linked for $cleanUsername");
  }

  Future<bool> isAdmin(String telegramUsername) async {
    final cleanUsername = _cleanTgUsername(telegramUsername);
    if (cleanUsername.isEmpty) return false;
    try {
      DocumentSnapshot userDoc = await _db.collection(FirestoreCollections.users).doc(cleanUsername).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?; 
        return data?['isAdmin'] == true; 
      }
      return false; 
    } catch (e) {
      print("Error checking admin status for $cleanUsername: $e");
      return false; 
    }
  }
}

*\/ \/\/ End of FirestoreService
