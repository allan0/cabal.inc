// lib/models/quest_model.dart
import 'package:flutter/foundation.dart' show debugPrint; 
import '../utils/constants.dart'; // For QuestType, questTypeToString, questTypeFromString

class Quest {
  final String id; 
  final String? quest_section_id; // --- FIX: Added this to correctly map quests ---
  String title;
  String description;
  String? detailedContent;
  int xpReward;
  QuestType type;
  String? actionUrl;
  String? iconName;
  List<String> prerequisiteQuestIds; 
  Duration? cooldownPeriod;
  String? taskButtonText; 
  bool requiresManualVerification;
  int totalSteps;

  // User-specific status fields
  bool isCompletedByUser;
  bool isLockedForUser;
  DateTime? lastCompletedByUserAt; 
  bool isOnCooldownForUser;
  int userCurrentStepsCompleted; 
  String userQuestSpecificStatus; 

  Quest({
    required this.id,
    this.quest_section_id, // --- FIX ---
    required this.title,
    required this.description,
    this.detailedContent,
    required this.xpReward,
    required this.type,
    this.actionUrl,
    this.iconName,
    this.prerequisiteQuestIds = const [],
    this.cooldownPeriod,
    this.taskButtonText,
    this.requiresManualVerification = false,
    this.totalSteps = 1,
    this.isCompletedByUser = false,
    this.isLockedForUser = true, 
    this.lastCompletedByUserAt,
    this.isOnCooldownForUser = false,
    this.userCurrentStepsCompleted = 0,
    this.userQuestSpecificStatus = 'not_started', 
  });

  factory Quest.fromSupabase(Map<String, dynamic> data) {
    final idValue = data['id'];
    if (idValue == null) {
      throw ArgumentError("Quest.fromSupabase: 'id' field cannot be null.");
    }
    final String finalId = idValue.toString(); 

    final titleValue = data['title'] ?? 'Untitled Quest';
    final descriptionValue = data['description'] ?? 'No description.';
    
    String? typeString = data['type'] as String?; 
    QuestType finalType = questTypeFromString(typeString);
    
    List<String> prereqIds = [];
    if (data['prerequisite_quest_ids'] != null && data['prerequisite_quest_ids'] is List) {
        prereqIds = List<String>.from((data['prerequisite_quest_ids'] as List).map((item) => item.toString()));
    }

    return Quest(
      id: finalId, 
      quest_section_id: data['quest_section_id'] as String?, // --- FIX ---
      title: titleValue, 
      description: descriptionValue, 
      detailedContent: data['detailed_content'] as String?, 
      xpReward: (data['xp_reward'] ?? 0) as int,
      type: finalType, 
      actionUrl: data['action_url'] as String?, 
      iconName: data['icon_name'] as String?, 
      prerequisiteQuestIds: prereqIds,
      cooldownPeriod: data['cooldown_period_seconds'] != null && (data['cooldown_period_seconds'] as num) > 0
          ? Duration(seconds: (data['cooldown_period_seconds'] as num).toInt())
          : null,
      taskButtonText: data['task_button_text'] as String?, 
      requiresManualVerification: (data['requires_manual_verification'] ?? false) as bool,
      totalSteps: (data['total_steps'] ?? 1) as int,
    );
  }

  Map<String, dynamic> toSupabase() {
    String typeString = questTypeToString(type); 

    return {
      'id': id,
      'quest_section_id': quest_section_id, // --- FIX ---
      'title': title,
      'description': description,
      'detailed_content': detailedContent, 
      'xp_reward': xpReward,
      'type': typeString, 
      'action_url': actionUrl, 
      'icon_name': iconName, 
      'prerequisite_quest_ids': prerequisiteQuestIds,
      'cooldown_period_seconds': cooldownPeriod?.inSeconds,
      'task_button_text': taskButtonText, 
      'requires_manual_verification': requiresManualVerification,
      'total_steps': totalSteps,
    };
  }

  void updateUserStatus({
    required Set<String> allCompletedQuestIdsForUserInCabal, 
    required Map<String, DateTime?> userQuestCompletionTimestamps, 
    required Map<String, int> userQuestStepsCompletedMap,      
    required Map<String, String> userQuestActualStatusesMap,    
  }) {
    userQuestSpecificStatus = userQuestActualStatusesMap[id] ?? 'not_started';
    isCompletedByUser = (userQuestSpecificStatus == 'completed');

    if (isCompletedByUser && userQuestCompletionTimestamps.containsKey(id)) {
        lastCompletedByUserAt = userQuestCompletionTimestamps[id]; 
        if (cooldownPeriod != null && lastCompletedByUserAt != null) {
            DateTime cooldownEndTime = lastCompletedByUserAt!.add(cooldownPeriod!);
            isOnCooldownForUser = DateTime.now().isBefore(cooldownEndTime);
        } else {
            isOnCooldownForUser = false; 
        }
    } else {
        lastCompletedByUserAt = null;
        isOnCooldownForUser = false;
    }

    isLockedForUser = prerequisiteQuestIds.isNotEmpty &&
                      !prerequisiteQuestIds.every((reqId) => allCompletedQuestIdsForUserInCabal.contains(reqId));

    userCurrentStepsCompleted = userQuestStepsCompletedMap[id] ?? 0;
    if (isCompletedByUser) { 
        userCurrentStepsCompleted = totalSteps;
    } else if (userQuestSpecificStatus == 'not_started' || userQuestSpecificStatus == 'rejected') {
        userCurrentStepsCompleted = 0;
    }
  }

  String get statusText {
    if (isLockedForUser) return "Locked";
    if (userQuestSpecificStatus == 'pending_verification') return "Pending Review";
    if (userQuestSpecificStatus == 'rejected') return taskButtonText ?? "Try Again";

    if (isCompletedByUser && isOnCooldownForUser && lastCompletedByUserAt != null && cooldownPeriod != null) {
        final remaining = lastCompletedByUserAt!.add(cooldownPeriod!).difference(DateTime.now());
        if (remaining.isNegative) { 
            return taskButtonText ?? "Redo";
        }
        String h = remaining.inHours.toString().padLeft(2, '0');
        String m = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
        String s = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
        if (remaining.inHours > 0) return "Cooldown: ${h}h ${m}m";
        if (remaining.inMinutes > 0) return "Cooldown: ${m}m ${s}s";
        return "Cooldown: ${s}s";
    }

    if (isCompletedByUser) { 
        if (cooldownPeriod != null) return taskButtonText ?? "Redo"; 
        return "Completed"; 
    }

    if (totalSteps > 1 && userCurrentStepsCompleted > 0 && userCurrentStepsCompleted < totalSteps) {
        double progress = (userCurrentStepsCompleted / totalSteps * 100);
        return "Progress (${progress.toStringAsFixed(0)}%)";
    }
    
    return taskButtonText ?? "Start";
  }
}
