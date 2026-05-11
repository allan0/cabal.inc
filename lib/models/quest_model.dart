// lib/models/quest_model.dart
import 'package:flutter/foundation.dart';
import '../utils/constants.dart'; // For QuestType enum

/// Represents a quest within a Cabal.
/// Maps directly to the 'quests' table in Supabase.
class Quest {
  final String id;
  final String? questSectionId;
  final String cabalId;
  String title;
  String description;
  String? detailedContent;
  int xpReward;
  QuestType type;
  String? actionUrl;
  String? iconName;
  List<String> prerequisiteQuestIds;
  
  // Cooldown & Repetition
  Duration? cooldown; 
  int totalSteps;
  
  // UI & Requirements
  String taskButtonText;
  bool requiresManualVerification;

  // User-Specific Progress (Populated via joins in SupabaseService)
  String userStatus; // 'not_started', 'in_progress', 'pending_review', 'completed', 'rejected'
  int userCurrentSteps;
  DateTime? lastCompletedAt;

  Quest({
    required this.id,
    this.questSectionId,
    required this.cabalId,
    required this.title,
    required this.description,
    this.detailedContent,
    required this.xpReward,
    required this.type,
    this.actionUrl,
    this.iconName,
    this.prerequisiteQuestIds = const [],
    this.cooldown,
    this.totalSteps = 1,
    this.taskButtonText = 'Complete Task',
    this.requiresManualVerification = false,
    this.userStatus = 'not_started',
    this.userCurrentSteps = 0,
    this.lastCompletedAt,
  });

  factory Quest.fromSupabase(Map<String, dynamic> data) {
    // Handle the QuestType conversion safely
    final typeStr = data['type'] as String? ?? 'custom';
    
    return Quest(
      id: data['id'] as String,
      questSectionId: data['quest_section_id'] as String?,
      cabalId: data['cabal_id'] as String,
      title: data['title'] as String? ?? 'Untitled Quest',
      description: data['description'] as String? ?? '',
      detailedContent: data['detailed_content'] as String?,
      xpReward: (data['xp_reward'] ?? 0) as int,
      type: questTypeFromString(typeStr),
      actionUrl: data['action_url'] as String?,
      iconName: data['icon_name'] as String?,
      prerequisiteQuestIds: data['prerequisite_quest_ids'] != null
          ? List<String>.from(data['prerequisite_quest_ids'])
          : [],
      cooldown: data['cooldown_period_seconds'] != null
          ? Duration(seconds: data['cooldown_period_seconds'] as int)
          : null,
      totalSteps: (data['total_steps'] ?? 1) as int,
      taskButtonText: data['task_button_text'] as String? ?? 'Complete Task',
      requiresManualVerification: (data['requires_manual_verification'] ?? false) as bool,
      
      // These are usually null unless fetched via a join with user_quest_progress
      userStatus: data['status'] as String? ?? 'not_started',
      userCurrentSteps: (data['current_steps'] ?? 0) as int,
      lastCompletedAt: data['last_completed_at'] != null 
          ? DateTime.tryParse(data['last_completed_at'] as String) 
          : null,
    );
  }

  /// Logic to determine the current display status for the UI
  String get statusText {
    if (userStatus == 'completed') {
      if (isOnCooldown) {
        final remaining = cooldownTimeRemaining;
        return "Cooldown: ${remaining.inHours}h ${remaining.inMinutes % 60}m";
      }
      return "Completed";
    }
    if (userStatus == 'pending_review') return "Under Review";
    if (userStatus == 'rejected') return "Rejected - Try Again";
    if (totalSteps > 1 && userCurrentSteps > 0) {
      return "Progress: $userCurrentSteps/$totalSteps";
    }
    return taskButtonText;
  }

  /// Checks if the quest is currently in a cooldown state based on last completion
  bool get isOnCooldown {
    if (lastCompletedAt == null || cooldown == null) return false;
    return DateTime.now().difference(lastCompletedAt!) < cooldown!;
  }

  Duration get cooldownTimeRemaining {
    if (lastCompletedAt == null || cooldown == null) return Duration.zero;
    final diff = cooldown! - DateTime.now().difference(lastCompletedAt!);
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get isLocked => userStatus == 'locked';
  bool get isCompleted => userStatus == 'completed' && !isOnCooldown;

  Map<String, dynamic> toSupabase() {
    return {
      'cabal_id': cabalId,
      'quest_section_id': questSectionId,
      'title': title,
      'description': description,
      'detailed_content': detailedContent,
      'xp_reward': xpReward,
      'type': questTypeToString(type),
      'action_url': actionUrl,
      'icon_name': iconName,
      'prerequisite_quest_ids': prerequisiteQuestIds,
      'cooldown_period_seconds': cooldown?.inSeconds,
      'total_steps': totalSteps,
      'task_button_text': taskButtonText,
      'requires_manual_verification': requiresManualVerification,
    };
  }
}
