import '../utils/constants.dart';

class Quest {
  final String id;
  final String cabalId;
  final String? sectionId;
  final String title;
  final String description;
  final int xpReward;
  final QuestType type;
  final String? actionUrl;
  final int? cooldownSeconds;
  final bool requiresManualVerification;
  
  // User-specific progress (Populated via joins)
  final String status; // 'not_started', 'completed', 'pending', 'rejected'
  final DateTime? lastCompletedAt;

  Quest({
    required this.id,
    required this.cabalId,
    this.sectionId,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.type,
    this.actionUrl,
    this.cooldownSeconds,
    this.requiresManualVerification = false,
    this.status = 'not_started',
    this.lastCompletedAt,
  });

  bool get isLocked => status == 'locked';
  
  bool get isOnCooldown {
    if (lastCompletedAt == null || cooldownSeconds == null) return false;
    final cooldownExpiry = lastCompletedAt!.add(Duration(seconds: cooldownSeconds!));
    return DateTime.now().isBefore(cooldownExpiry);
  }

  Duration get remainingCooldown {
    if (lastCompletedAt == null || cooldownSeconds == null) return Duration.zero;
    final expiry = lastCompletedAt!.add(Duration(seconds: cooldownSeconds!));
    return expiry.difference(DateTime.now());
  }

  factory Quest.fromSupabase(Map<String, dynamic> data) {
    return Quest(
      id: data['id'],
      cabalId: data['cabal_id'],
      sectionId: data['section_id'],
      title: data['title'] ?? 'Untitled Mission',
      description: data['description'] ?? '',
      xpReward: data['xp_reward'] ?? 0,
      type: questTypeFromString(data['type']),
      actionUrl: data['action_url'],
      cooldownSeconds: data['cooldown_period_seconds'],
      requiresManualVerification: data['requires_manual_verification'] ?? false,
      status: data['user_status'] ?? 'not_started',
      lastCompletedAt: data['last_completed_at'] != null 
          ? DateTime.tryParse(data['last_completed_at']) 
          : null,
    );
  }
}
