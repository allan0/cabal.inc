// lib/models/activity_model.dart
import 'package:flutter/foundation.dart' show debugPrint;

enum ActivityType {
  unknown,
  userJoined,
  questCompleted,
  cabalCreated,
  achievementUnlocked,
}

ActivityType activityTypeFromString(String? typeStr) {
  if (typeStr == null) return ActivityType.unknown;
  switch (typeStr.toLowerCase()) {
    case 'user_joined':
      return ActivityType.userJoined;
    case 'quest_completed':
      return ActivityType.questCompleted;
    case 'cabal_created':
      return ActivityType.cabalCreated;
    case 'achievement_unlocked':
      return ActivityType.achievementUnlocked;
    default:
      debugPrint("Unknown activity type string: '$typeStr'");
      return ActivityType.unknown;
  }
}

class Activity {
  final String id;
  final ActivityType type;
  final String userId; // The user who performed the action
  final String? targetId; // e.g., cabal_id, quest_id, achievement_id
  final String? content; // e.g., "Cabal Name", "Quest Title"
  final DateTime createdAt;

  // Enriched data, populated after initial fetch
  String? userDisplayName;
  String? userProfileImageUrl;

  Activity({
    required this.id,
    required this.type,
    required this.userId,
    this.targetId,
    this.content,
    required this.createdAt,
    this.userDisplayName,
    this.userProfileImageUrl,
  });

  factory Activity.fromSupabase(Map<String, dynamic> data) {
    return Activity(
      id: data['id'] as String,
      type: activityTypeFromString(data['type'] as String?),
      userId: data['user_id'] as String,
      targetId: data['target_id'] as String?,
      content: data['content'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      // The 'users' table is joined in the RPC, so we can get this directly
      userDisplayName: (data['users'] != null) ? data['users']['display_name'] as String? : null,
      userProfileImageUrl: (data['users'] != null) ? data['users']['profile_image_url'] as String? : null,
    );
  }
}
