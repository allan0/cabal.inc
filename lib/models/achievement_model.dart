// lib/models/achievement_model.dart
// No Supabase import needed if not using Supabase types.

class Achievement {
  final String id; // UUID, final
  String title;
  String description;
  String iconName; // Should map to an icon (e.g., FontAwesome)
  int xpBonus;
  final DateTime? createdAt; // Added
  DateTime? updatedAt; // Added

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.xpBonus = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Achievement.fromSupabase(Map<String, dynamic> data) {
    return Achievement(
      id: data['id'] as String, // Should always exist
      title: data['title'] as String? ?? 'Unnamed Achievement',
      description: data['description'] as String? ?? 'No description.',
      iconName: data['icon_name'] as String? ?? 'star', // Default icon if null
      xpBonus: (data['xp_bonus'] ?? 0) as int,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    // This map is for creating/updating an achievement definition.
    // 'id', 'created_at', 'updated_at' are typically DB-managed.
    return {
      'title': title,
      'description': description,
      'icon_name': iconName,
      'xp_bonus': xpBonus,
      // Other fields like criteria for awarding might be here if more complex
    };
  }
}
